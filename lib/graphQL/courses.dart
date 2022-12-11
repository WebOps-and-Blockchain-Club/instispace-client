class CoursesGQL {
  String searchCourses = """\
  query(\$filter: String!) {
  searchCourses(Filter: \$filter)
}
""";
}
