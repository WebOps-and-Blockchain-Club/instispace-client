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
      status
      tags {
        id
        title
        category
      }
      permissions
      actions
    }
    }
""";

  String editPost = """
    mutation UpdatePost(\$updatePostInput: UpdatePostInput!, \$updatePostId: String!) {
  updatePost(updatePostInput: \$updatePostInput, id: \$updatePostId) {
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
}
