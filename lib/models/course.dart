const String userTable = 'UserTimeTable';

class UserTableFields {
  static const List<String> columns = [
    id,
    slot,
    courseCode,
    courseName,
    alternateSlot1,
    alternateSlot2,
    alternateSlot3
  ];
  static const String id = '_id';
  static const String slot = 'slot';
  static const String courseCode = 'courseCode';
  static const String courseName = 'courseName';
  static const String alternateSlot1 = 'alternateSlot1';
  static const String alternateSlot2 = 'alternateSlot2';
  static const String alternateSlot3 = 'alternateSlot3';
}

class CourseModel {
  final int? id;
  final String slot;
  final String? alternateSlot1;
  final String courseCode;
  final String courseName;
  final String? alternateSlot2;
  final String? alternateSlot3;

  CourseModel({
    this.id,
    required this.slot,
    this.alternateSlot1,
    this.alternateSlot2,
    this.alternateSlot3,
    required this.courseCode,
    required this.courseName,
  });

  Map<String, Object?> toJson() => {
        UserTableFields.id: id,
        UserTableFields.slot: slot,
        UserTableFields.courseCode: courseCode,
        UserTableFields.courseName: courseName,
        UserTableFields.alternateSlot1: alternateSlot1,
        UserTableFields.alternateSlot2: alternateSlot2,
        UserTableFields.alternateSlot3: alternateSlot3,
      };

  CourseModel copy({
    int? id,
    String? slot,
    String? courseCode,
    String? courseName,
    String? alternateSlot1,
    String? alternateSlot2,
    String? alternateSlot3,
  }) =>
      CourseModel(
        id: id ?? this.id,
        slot: slot ?? this.slot,
        courseCode: courseCode ?? this.courseCode,
        courseName: courseName ?? this.courseName,
        alternateSlot1: alternateSlot1 ?? this.alternateSlot1,
        alternateSlot2: alternateSlot1 ?? this.alternateSlot2,
        alternateSlot3: alternateSlot1 ?? this.alternateSlot3,
      );

  static CourseModel fromJson(Map<String, Object?> json) => CourseModel(
        id: json[UserTableFields.id] as int?,
        slot: json[UserTableFields.slot] as String,
        courseCode: json[UserTableFields.courseCode] as String,
        courseName: json[UserTableFields.courseName] as String,
        alternateSlot1: json[UserTableFields.alternateSlot1] as String,
        alternateSlot2: json[UserTableFields.alternateSlot2] as String,
        alternateSlot3: json[UserTableFields.alternateSlot3] as String,
      );
}

class CoursesModel {
  final List<CourseModel> courses;
  CoursesModel({required this.courses});
}
