class QueryGQL {
  String get = """
query(\$myQueryId: String!){
  getMyQuery(MyQueryId: \$myQueryId) {
    id
    createdAt
    title
    content
    photo
    attachments
    createdBy {
      id
      name
    }
    isHidden
    likeCount
    commentCount
    comments {
      id
      content
      images
      createdAt
      createdBy {
        id
        roll
        name
      }
    }
  }
}


""";
  static const getAll = """
    query(
      \$lastId: String!
      \$take: Float!
      \$sort: OrderInput
      \$filters: FilteringConditions
    ) {
      getMyQuerys(
        lastEventId: \$lastId
        take: \$take
        Sort: \$sort
        Filters: \$filters
      ) {
        queryList {
          id
          createdAt
          title
          content
          photo
          status
          attachments
          likeCount
          isHidden
          permissions
          isLiked
          commentCount
          createdBy {
            id
            roll
            name
          }
          comments {
            id
            content
            images
            createdAt
            createdBy {
              id
              roll
              name
            }
          }
        }
        total
      }
    }
  """;

  static const create = """
    mutation(\$createQuerysInput: createQuerysInput!) {
      createMyQuery(createQuerysInput: \$createQuerysInput) {
        id
        createdAt
        title
        content
        photo
        attachments
        status
        isHidden
        likeCount
        permissions
        comments {
          content
          id
          images
          createdAt
          createdBy {
            name
            id
            roll
          }
        }
        isLiked
        createdBy {
          id
          roll
          name
        }
        commentCount
      }
    }
  """;

  static const edit = """
    mutation(
      \$id: String!
      \$editMyQuerysData: editQuerysInput!
    ) {
      editMyQuery(
        MyQueryId: \$id
        EditMyQuerysData: \$editMyQuerysData
      ) {
        id
        createdAt
        title
        content
        photo
        attachments
        isHidden
        likeCount
        status
        permissions
        comments {
          content
          id
          images
          createdAt
          createdBy {
            name
            id
            roll
          }
        }
        isLiked
        createdBy {
          id
          roll
          name
        }
        commentCount
      }
    }
  """;

  static const delete = """
    mutation(\$id: String!) {
      deleteMyQuery(MyQueryId: \$id)
    }
  """;

  static const like = """
    mutation(\$id: String!){
      toggleLikeQuery(MyQueryId: \$id)
    }
  """;

  static const report = """
    mutation(\$reportPostInput: ReportPostInput!, \$id: String!){
      reportMyQuery(ReportMyQueryInput: \$reportPostInput, MyQueryId: \$id)
    }
  """;

  static const createComment = """
    mutation(\$content: String!, \$id: String!, \$images: [Upload!]) {
      createCommentQuery(
        content: \$content
        MyQueryId: \$id
        Images: \$images
      ) {
        id
        content
        createdAt
        createdBy {
          id
          roll
          name
        }
        images
      }
    }
  """;

  static const editFragment = """
    fragment queryUpdateField on MyQuery {
      id
      createdAt
      title
      content
      photo
      attachments
      status
      isHidden
      likeCount
      permissions
      comments {
        content
        id
        images
        createdAt
        createdBy {
          name
          id
          roll
        }
      }
      isLiked
      createdBy {
        id
        roll
        name
      }
      commentCount
    }
  """;
}
