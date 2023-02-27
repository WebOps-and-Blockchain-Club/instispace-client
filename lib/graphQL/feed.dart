class FeedGQL {
  String findPosts = """
  query FindPosts(\$lastEventId: String!, \$take: Float!, \$filteringCondition: FilteringConditions!, \$orderInput: OrderInput!) {
  findPosts(lastEventId: \$lastEventId, take: \$take, filteringCondition: \$filteringCondition, orderInput: \$orderInput) {
    list {
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
    total
  }
}
""";
  String toggleLikePost = """mutation Mutation(\$postId: String!) {
  toggleLikePost(postId: \$postId) {
    title
    likeCount
    isLiked
  }
}""";
// TODO:
  String toggleDisLikePost = """mutation Mutation(\$postId: String!) {
  toggleLikePost(postId: \$postId) {
    title
    likeCount
    isLiked
  }
}""";
  String createComment =
      """mutation CreateComment(\$createCommentInput: CreateCommentInput!, \$postId: String!) {
  createComment(createCommentInput: \$createCommentInput, postId: \$postId) {
    id
    content
    isLiked
    isDisliked
    likeCount
    isHidden
    createdAt
    createdBy {
      id
      name
      roll
      photo
      role
    }
  }
}""";
  String toggleSavePost = """mutation ToggleSavePost(\$postId: String!) {
  toggleSavePost(postId: \$postId) {
    id
    title
  }
}""";

  String report =
      """mutation CreateReport(\$createReportInput: CreateReportInput!, \$postId: String!) {
  createReport(createReportInput: \$createReportInput, postId: \$postId) {
    id
  }
}""";

  String editFragment = """
    fragment postUpdateField on Post{
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
""";
}
