const String userTable = 'UserTimeTable';

class UserTableFields {
  static const List<String> columns = [
    id,
    slot,
    courseCode,
    courseName,
  ];
  static const String id = '_id';
  static const String slot = 'slot';
  static const String courseCode = 'courseCode';
  static const String courseName = 'courseName';
}

class CourseModel {
  final int? id;
  final String slot;
  final String? alternateSlot;
  final String courseCode;
  final String courseName;

  CourseModel({
    this.id,
    required this.slot,
    this.alternateSlot,
    required this.courseCode,
    required this.courseName,
  });

  Map<String, Object?> toJson() => {
        UserTableFields.id: id,
        UserTableFields.slot: slot,
        UserTableFields.courseCode: courseCode,
        UserTableFields.courseName: courseName,
      };

  CourseModel copy(
          {int? id,
          String? slot,
          String? courseCode,
          String? courseName,
          DateTime? start,
          DateTime? end}) =>
      CourseModel(
        id: id ?? this.id,
        slot: slot ?? this.slot,
        courseCode: courseCode ?? this.courseCode,
        courseName: courseName ?? this.courseName,
      );

  static CourseModel fromJson(Map<String, Object?> json) => CourseModel(
        id: json[UserTableFields.id] as int?,
        slot: json[UserTableFields.slot] as String,
        courseCode: json[UserTableFields.courseCode] as String,
        courseName: json[UserTableFields.courseName] as String,
      );
}

class CoursesModel {
  final List<CourseModel> courses;
  CoursesModel({required this.courses});
}
