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