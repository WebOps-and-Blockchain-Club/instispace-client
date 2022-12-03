class CourseModel {
  final String courseCode;
  final String courseName;
  final String slot;
  final String? alternateSlot;

  CourseModel({
    required this.courseCode,
    required this.courseName,
    required this.slot,
    this.alternateSlot,
  });
}

class CoursesModel {
  final List<CourseModel> courses;
  CoursesModel({required this.courses});
}
