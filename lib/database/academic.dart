import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/course.dart';

class AcademicDatabase {
  static final AcademicDatabase instance = AcademicDatabase._init();
  static Database? _db;
  AcademicDatabase._init();

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDB('academic.db');

    return _db!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    await db.execute(''' 
    CREATE TABLE $userTable (
      ${UserTableFields.id} $idType,
      ${UserTableFields.courseCode} $textType,
      ${UserTableFields.courseName} $textType,
      ${UserTableFields.slots} $textType
    );
    ''');
  }

  Future<CourseModel> addCourse(CourseModel course) async {
    final database = await instance.db;

    final id = await database.insert(userTable, course.toJson());

    return course.copy(id: id);
  }

  Future<int> updateCourse(CourseModel course) async {
    final database = await instance.db;

    final count = await database.update(userTable, course.toJson(),
        where: '${UserTableFields.id} = ?', whereArgs: [course.id]);
    return count;
  }

  Future<CoursesModel?> getCourses(String day) async {
    final database = await instance.db;
    var maps;
    maps = await database.query(userTable,
        columns: UserTableFields.columns,
        where: '${UserTableFields.slots} LIKE ?',
        whereArgs: ['%$day*%']);
    if (maps.isNotEmpty) {
      /*CoursesModel courses = CoursesModel(w
          courses: maps
              .map((course) => CourseModel.fromJson(course))
              .toList<CourseModel>());*/
      //print(maps);
      List<CourseModel> courses = [];
      for (var map in maps) {
        courses.add(CourseModel.fromJson(map));
      }
      CoursesModel coursesModel = CoursesModel(courses: courses);
      return coursesModel;
    }
    return null;
  }

  Future<CoursesModel> getAllCourses() async {
    final database = await instance.db;

    final list = await database.query(userTable);

    return CoursesModel(
        courses: list.map((json) => CourseModel.fromJson(json)).toList());
  }

  Future<int> deleteCourse(int id) async {
    final database = await instance.db;
    return await database
        .delete(userTable, where: '${UserTableFields.id} = ?', whereArgs: [id]);
  }

  Future close() async {
    final database = await instance.db;

    database.close();
  }
}
