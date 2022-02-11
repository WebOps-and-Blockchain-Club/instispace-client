class Queries{
  String getMyQueries = """
  query(\$skip: Float!, \$take: Float!, \$orderByLikes: Boolean){
  getMyQuerys(skip: \$skip, take: \$take, OrderByLikes: \$orderByLikes) {
    queryList {
      id
      title
      photo
      content
      isLiked
      likeCount
      createdBy {
        roll
        name
        id
      }
    }
    total
  }
}
  """;
  String getMyQuery="""
  query(\$id: String!){
  getMyQuery(MyQueryId: \$id) {
    attachments
    likeCount
    isLiked
  }
  getMe {
    id
  }
}
  """;
  String createQuery="""
  mutation(\$createQuerysInput: createQuerysInput!, \$image: Upload, \$attachments: [Upload!]){
  createMyQuery(createQuerysInput: \$createQuerysInput, Image: \$image, Attachments: \$attachments)
}
  """;
  String toggleLike="""
  mutation(\$id: String!){
  toggleLikeQuery(MyQueryId: \$id)
}
  """;
  String getComments = """
  query(\$id: String!){
  getMyQuery(MyQueryId: \$id) {
    comments{
      createdBy {
        name
      }
      content
      id
    }
  }
}
  """;
  String createComment ="""
  mutation(\$content: String!, \$id: String!){
  createCommentQuery(content: \$content, MyQueryId: \$id)
}
  """;
  String searchQuery ="""
  query(\$skip: Float!, \$take: Float!, \$search: String!){
  searchQueries(skip: \$skip, take: \$take, search: \$search) {
    queryList {
      id
      title
      photo
      content
      isLiked
      likeCount
      createdBy {
        roll
        name
        id
      }
    }
    total
  }
 
}
  """;
  String editQuery = """
  mutation(\$id: String!, \$editMyQuerysData: editQuerysInput!, \$attachments: [Upload!], \$image: Upload){
  editMyQuery(MyQueryId: \$id, EditMyQuerysData: \$editMyQuerysData, Attachments: \$attachments, Image: \$image)
}
  """;
}