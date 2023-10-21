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
  query FindAllFeedback {
  findAllFeedback {
    courseCode
    createdAt
    courseName
    createdBy {
      id
      name
      roll
      role
    }
    id
    profName
    rating
    review
  }
}
""";
}
