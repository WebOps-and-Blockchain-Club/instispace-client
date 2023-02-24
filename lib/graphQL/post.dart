class PostGQl {
  String createPost = """
    mutation(\$postInput: CreatePostInput!) {
      createPost(postInput: \$postInput) {
         updatedAt
      title
      postComments {
        id
        createdAt
        createdBy {
          id
          roll
          role
          name
          photo
        }
        content
        isLiked
        isDisliked
        likeCount
        isHidden
      }
      photo
      location
      linkName
      likeCount
      isLiked
      isDisliked
      isHidden
      id
      isSaved
      endTime
      dislikeCount
      createdBy{
        id
        roll
        role
        name
        photo
      }
      createdAt
      content
      category
      Link
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
