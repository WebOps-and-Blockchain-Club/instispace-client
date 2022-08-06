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
