import 'package:flutter/cupertino.dart';

const String userTable = 'UserTimeTable';

extension BoolParsing on Object {
  bool parseBool() {
    return this == 'true';
  }
}

class UserTableFields {
  static const List<String> columns = [
    id,
    slots,
    courseCode,
    courseName,
  ];
  static const String id = '_id';
  static const String slots = 'slots';
  static const String courseCode = 'courseCode';
  static const String courseName = 'courseName';
}

class CourseModel {
  final int? id;
  final String slots;
  final String courseCode;
  final String courseName;
  CourseModel({
    this.id,
    required this.slots,
    required this.courseCode,
    required this.courseName,
  });

  Map<String, Object?> toJson() => {
        UserTableFields.id: id,
        UserTableFields.slots: slots,
        UserTableFields.courseCode: courseCode,
        UserTableFields.courseName: courseName
      };

  CourseModel copy(
          {int? id, String? slots, String? courseCode, String? courseName}) =>
      CourseModel(
          id: id ?? this.id,
          slots: slots ?? this.slots,
          courseCode: courseCode ?? this.courseCode,
          courseName: courseName ?? this.courseName);

  static CourseModel fromJson(Map<String, Object?> json) => CourseModel(
      id: json[UserTableFields.id] as int?,
      slots: json[UserTableFields.slots] as String,
      courseCode: json[UserTableFields.courseCode] as String,
      courseName: json[UserTableFields.courseName] as String);
}

class CoursesModel {
  final List<CourseModel> courses;
  CoursesModel({required this.courses});
}
