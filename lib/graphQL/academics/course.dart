class CourseGQL {
  static const get = """
query FindAllCourse(
  \$courseFilteringConditions: CourseFilteringConditions!
  \$take: Int!
  \$lastCourseId: String!
) {
  findAllCourse(
    courseFilteringConditions: \$courseFilteringConditions
    take: \$take
    lastCourseId: \$lastCourseId
  ) {
    list {
      code
      from
      id
      instructorName
      name
      semester
      slots
      to
      venue
    }
    total
  }
}
""";
}
