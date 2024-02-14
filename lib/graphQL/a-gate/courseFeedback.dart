class FeedbackGQL {
  static const createFeedback = """ 
  mutation AddFeedback(\$createFeedbackInput: CreateFeedbackInput!) {
  addFeedback(createFeedbackInput: \$createFeedbackInput) {
    courseCode
    courseName
    profName
    id
    rating
    review
    createdBy {
    ldapName
    }
    createdAt
  }
}
  """;

  static const findAllFeedback = """
  query FindAllFeedback(\$search: String!, \$lastpostId: String!, \$take: Float!) {
  findAllFeedback(search: \$search, lastpostId: \$lastpostId, take: \$take) {
    list {
      id
      courseCode
      createdAt
      courseName
      createdBy {
        name
        id
      }
      rating
      review
      profName
    }
  }
}
""";
}
