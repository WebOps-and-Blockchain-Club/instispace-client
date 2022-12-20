class CoursesGQL {
  String searchCourses = """\
  query Query(\$filter: String!) {
    searchCourses(Filter: \$filter){
    courseName
    courseCode
    id
    slots
    additionalSlots
    }
}
""";
  String getCourse = """\
  query Query(\$getCourseFilter2: String!) {
  getCourse(Filter: \$getCourseFilter2) {
    slots
    id
    courseName
    courseCode
    additionalSlots
  }
}
""";
}
