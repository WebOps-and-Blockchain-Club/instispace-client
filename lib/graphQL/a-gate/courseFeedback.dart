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
  query FindAllFeedback(\$search: String!) {
  findAllFeedback(search: \$search) {
    courseCode
    createdAt
    courseName
    createdBy {
      name
      id
    }
    id
    profName
    rating
    review
  }
}
""";
}
