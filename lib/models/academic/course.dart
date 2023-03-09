import 'package:client/models/date_time_format.dart';
import 'package:client/utils/time_of_day_extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../database/config.dart';

class CoursesModel {
  final List<CourseModel> list;
  final int total;

  CoursesModel({required this.list, required this.total});

  CoursesModel.fromJson(dynamic data)
      : list = (data["findAllCourse"]["list"] as List<dynamic>)
            .map((e) => CourseModel.fromSJson(e))
            .toList(),
        total = data["findAllCourse"]['total'];
}

// class Course1Model {
//   String id;
//   String code;
//   String name;
//   String from;
//   String to;
//   String instructorName;
//   String semester;
//   String slots;

//   Course1Model({
//     required this.id,
//     required this.code,
//     required this.name,
//     required this.from,
//     required this.to,
//     required this.instructorName,
//     required this.semester,
//     required this.slots,
//   });

//   Course1Model.fromJson(dynamic data)
//       : id = data['id'],
//         code = data['code'],
//         name = data['name'],
//         from = data['from'],
//         to = data['to'],
//         instructorName = data['instructorName'],
//         semester = data['semester'],
//         slots = data['slots'];
// }

class CourseQueryVariableModel {
  final int take;
  final String lastCourseId;
  final String? search;
  final String? code;
  final String? date;
  final String? semester;
  final String? slot;

  CourseQueryVariableModel({
    this.take = 20,
    this.lastCourseId = '',
    this.search,
    this.code,
    this.date,
    this.semester,
    this.slot,
  });

  Map<String, dynamic> toJson() {
    return {
      "take": take,
      "lastCourseId": lastCourseId,
      "courseFilteringConditions": {
        "search": search?.trim(),
        "code": null,
        "date": null,
        "name": null,
        "semester": null,
        "slot": null
      },
    };
  }
}

class CourseModel {
  String? id;
  String courseCode;
  String courseName;
  List<SlotModel>? slots;
  DateTime fromDate;
  DateTime toDate;
  int reminder;

  CourseModel({
    this.id,
    required this.courseCode,
    required this.courseName,
    this.slots,
    required this.fromDate,
    required this.toDate,
    this.reminder = 0,
  });

  CourseModel.fromSJson(dynamic data)
      : id = data['id'],
        courseCode = data['code'],
        courseName = data['name'],
        fromDate = DateTimeFormatModel.fromString(data['from']).dateTime,
        toDate = DateTimeFormatModel.fromString(data['to']).dateTime,
        slots = data['slots'] != null
            ? getMSlotOptions(data['slots'].split(' AND '))
            : null,
        reminder = 0;

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    // List<dynamic> slotJson = json['slots'];
    // List<SlotModel> slots = [];
    // slots = slotJson.map((slot) => SlotModel.fromJson(slot)).toList();

    return CourseModel(
      id: json['courseId'].toString(),
      courseCode: json['courseCode'],
      courseName: json['courseName'],
      // ignore: prefer_null_aware_operators
      slots: json["slots"] != null
          ? json["slots"].map((slot) => SlotModel.fromJson(slot)).toList()
          : null,
      fromDate: DateTime.parse(json['fromDate']),
      toDate: DateTime.parse(json['toDate']), reminder: json['reminder'],
    );
  }

  Map<String, dynamic> toJson() => {
        'courseId': id,
        'courseCode': courseCode,
        'courseName': courseName,
        'fromDate': fromDate.toIso8601String(),
        'toDate': toDate.toIso8601String(),
        'slots': slots != null
            ? List<dynamic>.from(slots!.map((x) => x.toJson()))
            : null,
      };
}

class SlotModel {
  int? id;
  String slotName;
  TimeOfDay fromTime;
  TimeOfDay toTime;
  String day;
  CourseModel? course;

  String get fromTimeStr =>
      DateTimeFormatModel(dateTime: fromTime.toDateTime()).toFormat('h:mm a');
  String get toTimeStr =>
      DateTimeFormatModel(dateTime: toTime.toDateTime()).toFormat('h:mm a');

  SlotModel({
    required this.id,
    required this.slotName,
    required this.fromTime,
    required this.toTime,
    required this.day,
    this.course,
  });

  factory SlotModel.fromJson(Map<String, dynamic> json) {
    var course = json['courseId'] != null
        ? CourseModel(
            id: json['courseId'].toString(),
            courseCode: json['courseCode'],
            courseName: json['courseName'],
            fromDate: DateTime.parse(json['fromDate']),
            toDate: DateTime.parse(json['toDate']),
          )
        : null;
    return SlotModel(
      id: json['slotId'],
      slotName: json['slotName'],
      fromTime: TimeOfDay(
          hour: DateFormat('HH:mm').parse(json['fromTime']).hour,
          minute: DateFormat('HH:mm').parse(json['fromTime']).minute),
      toTime: TimeOfDay(
          hour: DateFormat('HH:mm').parse(json['toTime']).hour,
          minute: DateFormat('HH:mm').parse(json['toTime']).minute),
      day: json['day'],
      course: course ??
          (json['course'] != null
              ? CourseModel.fromJson(json['course'])
              : null),
    );
  }

  Map<String, dynamic> toJson() => {
        'slotId': id,
        'slotName': slotName,
        'fromTime': DateTimeFormatModel(dateTime: fromTime.toDateTime())
            .toFormat('HH:mm'),
        'toTime': DateTimeFormatModel(dateTime: toTime.toDateTime())
            .toFormat('HH:mm'),
        'day': day,
        'course': course != null ? course!.toJson() : null,
      };
}
