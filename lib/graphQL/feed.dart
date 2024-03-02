class FeedGQL {
  String findPosts({List<String>? relations}) => """
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
        dislikeCount
        photo
        isHidden
      }
      isQRActive
      pointsValue
      photo
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
      onBehalf
      tags {
        id
        title
        category
      }
      ${relations != null && relations.contains("REPORT") ? """postReports {
        createdBy {
          id
          name
          role
          roll
          photo
        }
        description
        id
        createdAt
      }""" : ""}
      permissions
      actions
    }
    total
  }
}
""";
  String findOnePost = """query FindOnePost(\$Postid: String!) {
  findOnePost(Postid: \$Postid) {
    id
    title
    pointsValue
    isQRActive
    
  }
}""";
  String toggleLikePost = """mutation Mutation(\$postId: String!) {
  toggleLikePost(postId: \$postId) {
    title
    likeCount
    isLiked
  }
}""";

  String toggleLikeComment = """mutation Mutation(\$commentId: String!) {
  toggleLikeComment(commentId: \$commentId) {
    likeCount
    isLiked
  }
}""";

  String toggleDisLikePost = """mutation ToggleDislikePost(\$postId: String!) {
  toggleDislikePost(postId: \$postId) {
    title
    isDisliked
    dislikeCount
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

  String updateStatus =
      """mutation ChangePostsStatus(\$id: String!, \$status: PostStatusInput!) {
  changePostsStatus(id: \$id, status: \$status) {
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
        dislikeCount
        photo
        isHidden
      }
      photo
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
""";
}
