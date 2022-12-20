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
    slot,
    courseCode,
    courseName,
    alternateSlot1,
    alternateSlot2,
    alternateSlot3,
    monday,
    tuesday,
    wednesday,
    thursday,
    friday,
  ];
  static const String id = '_id';
  static const String slot = 'slot';
  static const String courseCode = 'courseCode';
  static const String courseName = 'courseName';
  static const String alternateSlot1 = 'alternateSlot1';
  static const String alternateSlot2 = 'alternateSlot2';
  static const String alternateSlot3 = 'alternateSlot3';
  static const String monday = 'monday';
  static const String tuesday = 'tuesday';
  static const String wednesday = 'wednesday';
  static const String thursday = 'thursday';
  static const String friday = 'friday';
}

class CourseModel {
  final int? id;
  final String slot;
  final String? alternateSlot1;
  final String courseCode;
  final String courseName;
  final String? alternateSlot2;
  final String? alternateSlot3;
  final bool monday;
  final bool tuesday;
  final bool wednesday;
  final bool thursday;
  final bool friday;
  CourseModel({
    this.id,
    required this.slot,
    this.alternateSlot1,
    this.alternateSlot2,
    this.alternateSlot3,
    required this.courseCode,
    required this.courseName,
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
  });

  Map<String, Object?> toJson() => {
        UserTableFields.id: id,
        UserTableFields.slot: slot,
        UserTableFields.courseCode: courseCode,
        UserTableFields.courseName: courseName,
        UserTableFields.alternateSlot1: alternateSlot1,
        UserTableFields.alternateSlot2: alternateSlot2,
        UserTableFields.alternateSlot3: alternateSlot3,
        UserTableFields.monday: monday.toString(),
        UserTableFields.tuesday: tuesday.toString(),
        UserTableFields.wednesday: wednesday.toString(),
        UserTableFields.thursday: thursday.toString(),
        UserTableFields.friday: friday.toString(),
      };

  CourseModel copy({
    int? id,
    String? slot,
    String? courseCode,
    String? courseName,
    String? alternateSlot1,
    String? alternateSlot2,
    String? alternateSlot3,
    bool? monday,
    bool? tuesday,
    bool? wednesday,
    bool? thursday,
    bool? friday,
  }) =>
      CourseModel(
        id: id ?? this.id,
        slot: slot ?? this.slot,
        courseCode: courseCode ?? this.courseCode,
        courseName: courseName ?? this.courseName,
        alternateSlot1: alternateSlot1 ?? this.alternateSlot1,
        alternateSlot2: alternateSlot1 ?? this.alternateSlot2,
        alternateSlot3: alternateSlot1 ?? this.alternateSlot3,
        monday: monday ?? this.monday,
        tuesday: tuesday ?? this.tuesday,
        wednesday: wednesday ?? this.wednesday,
        thursday: thursday ?? this.thursday,
        friday: friday ?? this.friday,
      );

  static CourseModel fromJson(Map<String, Object?> json) => CourseModel(
        id: json[UserTableFields.id] as int?,
        slot: json[UserTableFields.slot] as String,
        courseCode: json[UserTableFields.courseCode] as String,
        courseName: json[UserTableFields.courseName] as String,
        alternateSlot1: json[UserTableFields.alternateSlot1] as String?,
        alternateSlot2: json[UserTableFields.alternateSlot2] as String?,
        alternateSlot3: json[UserTableFields.alternateSlot3] as String?,
        monday: (json[UserTableFields.monday])!.parseBool() as bool,
        tuesday: json[UserTableFields.tuesday]!.parseBool() as bool,
        wednesday: json[UserTableFields.wednesday]!.parseBool() as bool,
        thursday: json[UserTableFields.thursday]!.parseBool() as bool,
        friday: json[UserTableFields.friday]!.parseBool() as bool,
      );
}

class CoursesModel {
  final List<CourseModel> courses;
  CoursesModel({required this.courses});
}
