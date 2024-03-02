import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

import '../models/academic/course.dart';
import '../models/date_time_format.dart';
import '../services/notification.dart';

class AcademicDatabaseService {
  static final AcademicDatabaseService instance =
      AcademicDatabaseService._init();

  LocalNotificationService notificationService = LocalNotificationService();

  static Database? _database;

  AcademicDatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('academic.db');
    return _database!;
  }

  Future<Database> _initDB(String filepath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE courses(
        courseId INTEGER PRIMARY KEY AUTOINCREMENT,
        courseCode TEXT NOT NULL,
        courseName TEXT NOT NULL,
        fromDate TEXT NOT NULL,
        toDate TEXT NOT NULL,
        reminder INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE slots(
        slotId INTEGER PRIMARY KEY AUTOINCREMENT,
        slotName TEXT NOT NULL,
        fromTime TEXT NOT NULL,
        toTime TEXT NOT NULL,
        day TEXT NOT NULL,
        courseId INTEGER NOT NULL,
        FOREIGN KEY (courseId) REFERENCES courses(courseId) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> insertCourseWithSlots(CourseModel course) async {
    final db = await database;
    await db.transaction((txn) async {
      // Insert the course
      var data = {
        "courseCode": course.courseCode,
        "courseName": course.courseName,
        "fromDate": course.fromDate.toIso8601String(),
        "toDate": course.toDate.toIso8601String(),
        "reminder": course.reminder,
      };
      final courseId = await txn.insert('courses', data);

      // Insert the slots associated with the course
      final batch = txn.batch();
      for (final slot in course.slots!) {
        var slotData = slot.toJson();
        slotData.remove('course');
        slotData['courseId'] = courseId;
        batch.insert('slots', slotData);
      }
      await batch.commit();
      notificationService.scheduleWeeklyNotification(
          title: course.courseName,
          description: course.courseCode,
          courseId: courseId);
    });
  }

  Future<void> updateCourseWithSlots(
      int courseId, CourseModel updatedCourse) async {
    final db = await database;
    await db.transaction((txn) async {
      // Update the course
      var courseMap = updatedCourse.toJson();
      courseMap['courseId'] = courseId;
      courseMap.remove('slots');
      await txn.update('courses', courseMap,
          where: 'courseId = ?', whereArgs: [courseId]);

      // Delete the existing slots associated with the course
      await txn.delete('slots', where: 'courseId = ?', whereArgs: [courseId]);

      // Insert the updated slots associated with the course
      final batch = txn.batch();

      for (final slot in updatedCourse.slots!) {
        var slotMap = slot.toJson();
        slotMap.remove('course');
        slotMap['courseId'] = courseId;
        batch.insert('slots', slotMap);
      }
      await batch.commit();
    });
  }

  Future<List<CourseModel>> fetchCoursesWithSlots() async {
    final db = await database;
    // final currentDate = DateTime.now().toIso8601String();

    final courseRows = await db.query(
      'courses LEFT JOIN slots ON courses.courseId = slots.courseId',
      // where: 'courses.fromDate <= ? AND courses.toDate >= ?',
      // whereArgs: [currentDate, currentDate],
      orderBy: 'courses.courseId, slots.slotId',
    );
    // db.rawQuery('delete from slots');
    // db.rawQuery('delete from courses');

    final courses = <CourseModel>[];
    CourseModel? currentCourse;
    for (final row in courseRows) {
      final course = CourseModel.fromJson(row);
      if (currentCourse != null && currentCourse.id != course.id) {
        courses.add(currentCourse);
      }
      if (currentCourse == null || currentCourse.id != course.id) {
        currentCourse = course;
        currentCourse.slots = [];
      }
      if (row['slotName'] != null) {
        final slot = SlotModel.fromJson(row);
        currentCourse.slots!.add(slot);
      }
    }
    if (currentCourse != null) courses.add(currentCourse);
    return courses;
  }

  Future<List<SlotModel>> fetchSlotsByDay(String day) async {
    final db = await database;
    final res = await db.rawQuery(
        '''SELECT slots.*, courses.courseCode, courses.courseName, courses.fromDate, courses.toDate
         FROM slots 
         INNER JOIN courses 
         ON slots.courseId = courses.courseId 
         WHERE slots.day = ?
         ORDER BY slots.fromTime''',
        [
          day,
        ]);

    fetchNextClass();
    return res.isNotEmpty
        ? res.map((slot) => SlotModel.fromJson(slot)).toList()
        : [];
  }

  Future<SlotModel?> fetchNextClass() async {
    SlotModel? result;
    int itr = 0;
    final db = await database;
    DateTime currTime = DateTime.now();

    while ((itr <= 1 && result == null)) {
      final res = await db.rawQuery(
          '''SELECT slots.*, courses.courseCode, courses.courseName, courses.fromDate, courses.toDate
         FROM slots 
         INNER JOIN courses 
         ON slots.courseId = courses.courseId 
         WHERE slots.day = ? AND slots.fromTime >= ? AND courses.fromDate <= ? AND courses.toDate >= ?
         ORDER BY slots.fromTime''',
          [
            DateFormat('E').format(currTime),
            itr == 0 ? DateTimeFormatModel(currTime).toFormat('HH:mm') : '%',
            DateTime.now().toIso8601String(),
            DateTime.now().toIso8601String()
          ]);

      itr = itr + 1;
      currTime = currTime.add(const Duration(hours: 24));
      result = res.isNotEmpty
          ? res.map((slot) => SlotModel.fromJson(slot)).toList()[0]
          : null;
    }

    return result;
  }

  Future<DateTime?> getNextClassTime(int courseId) async {
    TimeOfDay? result;
    int reminder = 0;
    int itr = 0;
    final db = await database;
    DateTime currTime = DateTime.now();

    while ((itr <= 14 && result == null)) {
      final res = await db.rawQuery(
          '''SELECT slots.*, courses.courseCode, courses.courseName, courses.fromDate, courses.toDate, courses.reminder
         FROM slots 
         INNER JOIN courses 
         ON slots.courseId = courses.courseId 
         WHERE courses.courseId = ? AND slots.day = ? AND slots.fromTime >= ? AND courses.fromDate <= ? AND courses.toDate >= ? AND courses.reminder != 0
         ORDER BY slots.fromTime''',
          [
            courseId,
            DateFormat('E').format(currTime),
            itr == 0 ? DateTimeFormatModel(currTime).toFormat('HH:mm') : '%',
            DateTime.now().toIso8601String(),
            DateTime.now().toIso8601String()
          ]);

      itr = itr + 1;
      currTime = currTime.add(const Duration(hours: 24));
      result = res.isNotEmpty
          ? res.map((slot) => SlotModel.fromJson(slot)).toList()[0].fromTime
          : null;
      reminder = res.isNotEmpty ? (res[0]["reminder"] as int) : 0;
    }

    currTime = currTime.subtract(const Duration(hours: 24));
    if (result == null) {
      return null;
    }

    return DateTime(currTime.year, currTime.month, currTime.day, result.hour,
        result.minute - reminder);
  }

  Future<void> deleteCourseWithSlots(int courseId) async {
    final db = await database;

    await db.transaction((txn) async {
      await txn.delete('slots', where: 'courseId = ?', whereArgs: [courseId]);
      await txn.delete('courses', where: 'courseId = ?', whereArgs: [courseId]);
    });

    await notificationService.deleteNotification(courseId);
  }
}
