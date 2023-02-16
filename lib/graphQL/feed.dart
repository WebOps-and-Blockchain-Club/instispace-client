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
  String createComment =
      """mutation CreateComment(\$createCommentInput: CreateCommentInput!) {
  createComment(createCommentInput: \$createCommentInput) {
    id
    content
    createdAt
    createdBy {
      id
      name
      roll
    }
  }
}""";
  String toggleSavePost = """mutation ToggleSavePost(\$postId: String!) {
  toggleSavePost(postId: \$postId) {
    id
    title
  }
}""";
}
