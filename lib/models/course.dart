const String userTable = 'UserTimeTable';

class UserTableFields {
  static const List<String> columns = [
    id,
    slot,
    courseCode,
    courseName,
    start,
    end
  ];
  static const String id = '_id';
  static const String slot = 'slot';
  static const String courseCode = 'courseCode';
  static const String courseName = 'courseName';
  static const String start = 'startTime';
  static const String end = 'endTime';
}

class CourseModel {
  final int? id;
  final String slot;
  final String? alternateSlot;
  final String courseCode;
  final String courseName;
  final DateTime start;
  final DateTime end;

  CourseModel({
    this.id,
    required this.slot,
    this.alternateSlot,
    required this.courseCode,
    required this.courseName,
    required this.start,
    required this.end,
  });

  Map<String, Object?> toJson() => {
        UserTableFields.id: id,
        UserTableFields.slot: slot,
        UserTableFields.courseCode: courseCode,
        UserTableFields.courseName: courseName,
        UserTableFields.start: start.toIso8601String(),
        UserTableFields.end: end.toIso8601String()
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
          start: start ?? this.start,
          end: end ?? this.end);

  static CourseModel fromJson(Map<String, Object?> json) => CourseModel(
      id: json[UserTableFields.id] as int?,
      slot: json[UserTableFields.slot] as String,
      courseCode: json[UserTableFields.courseCode] as String,
      courseName: json[UserTableFields.courseName] as String,
      start: DateTime.parse(json[UserTableFields.start] as String),
      end: DateTime.parse(json[UserTableFields.end] as String));
}

class CoursesModel {
  final List<CourseModel> courses;
  CoursesModel({required this.courses});
}
