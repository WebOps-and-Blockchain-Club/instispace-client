class FeedbackGQL {
  String add = """
    mutation(\$addFeedback: AddFeedbackInput!){
      addFeedback(AddFeedback: \$addFeedback)
    }
  """;

  String get = """
    query{
      getSheetLink
    }
  """;
}

class FeedBackMutation {
  String addFeedback = """
  mutation(\$addFeedback: AddFeedbackInput!){
  addFeedback(AddFeedback: \$addFeedback)
}
  """;

  String feedbackSheetLink = """
  query{
    getSheetLink
  }
  """;
}