class netopsQuery{
  String getNetops ="""query(\$skip: Float!, \$take: Float!,\$orderByLikes: Boolean, ){
  getNetops(skip: \$skip, take: \$take,OrderByLikes: \$orderByLikes) {
    netopList {
      id,
      content,
      comments {
        content
        id
      },
      title
      isHidden
      endTime
      tags {
        category,
        title,
        id
      }
      likeCount
    }
    total
  }
}""";
  String createComment = """mutation(\$content: String!, \$netopId: String!){
  createComment(content: \$content, NetopId: \$netopId)
}""";
  String createNetop ="""mutation(\$newEventData: createNetopsInput!){
  createNetop(NewEventData: \$newEventData)
}""";
}