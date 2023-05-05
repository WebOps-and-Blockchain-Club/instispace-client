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
        dislikeCount
        photo
        likeCount
        isHidden
      }
      isQRActive
      pointsValue
      photo
      attachment
      postTime
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
    mutation UpdatePost(\$postInput: UpdatePostInput!, \$updatePostId: String!) {
  updatePost(updatePostInput: \$postInput, id: \$updatePostId) {
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
        dislikeCount
        photo
        likeCount
        isHidden
      }
      photo
      attachment
      postTime
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
  static const getOne = """
query FindOnePost(\$postid: String!) {
  findOnePost(Postid: \$postid) {
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
        dislikeCount
        photo
        isHidden
      }
      photo
      attachment
      postTime
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
}""";
}
