class PostGQl {
  String createPost = """
    mutation(\$postInput: CreatePostInput!) {
      createPost(postInput: \$postInput) {
        id
      }
    }
""";

  static const editFragment = """
    fragment postUpdateField on Post {
      id
      createdAt
      title
      content
      photoList
      location
      postTime
      endTime
      likeCount
      isStared
      link
      permissions
      tags {
        title
        id
        category
      }
      isLiked
      createdAt
      createdBy {
        id
        name
      }
    }
  """;
}
