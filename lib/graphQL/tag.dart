class TagGQL {
  String get = """
    query{
      getTags {
        id
        title
        category
      }
    }
  """;
}
