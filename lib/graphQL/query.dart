class QueryGQL {
  static const getAll = """
    query(
      \$lastId: String!
      \$take: Float!
      \$search: String
      \$orderByLikes: Boolean
    ) {
      getMyQuerys(
        lastEventId: \$lastId
        take: \$take
        search: \$search
        OrderByLikes: \$orderByLikes
      ) {
        queryList {
          id
          createdAt
          title
          content
          photo
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
    mutation(\$createQuerysInput: createQuerysInput!, \$attachments: [Upload!]) {
      createMyQuery(
        createQuerysInput: \$createQuerysInput
        Attachments: \$attachments
      ) {
        id
        createdAt
        title
        content
        photo
        attachments
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
      \$attachments: [Upload!]
    ) {
      editMyQuery(
        MyQueryId: \$id
        EditMyQuerysData: \$editMyQuerysData
        Attachments: \$attachments
      ) {
        id
        createdAt
        title
        content
        photo
        attachments
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
    mutation(\$description: String!, \$id: String!){
      reportMyQuery(description: \$description, MyQueryId: \$id)
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
}

class Queries {
  String getMyQueries = """
  query GetMyQuerys(\$lastEventId: String!, \$take: Float!, \$search: String, \$orderByLikes: Boolean) {
  getMyQuerys(lastEventId: \$lastEventId, take: \$take, search: \$search, OrderByLikes: \$orderByLikes) {
    queryList {
      id
      title
      photo
      content
      isLiked
      likeCount
      createdAt
      commentCount
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
  String getMyQuery = """
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
  String createQuery = """
  mutation(\$createQuerysInput: createQuerysInput!, \$images: [Upload!], \$attachments: [Upload!]){
  createMyQuery(createQuerysInput: \$createQuerysInput, Images: \$images, Attachments: \$attachments)
}
  """;
  String toggleLike = """
  mutation(\$id: String!){
  toggleLikeQuery(MyQueryId: \$id)
}
  """;
  String getComments = """
  query(\$id: String!){
  getMyQuery(MyQueryId: \$id) {
    comments{
    images
      createdBy {
        name
      }
      content
      id
    }
  }
}
  """;
  String createComment = """
  mutation(\$content: String!, \$id: String!, \$images: [Upload!]){
  createCommentQuery(content: \$content, MyQueryId: \$id, Images: \$images)
}
  """;
  String searchQuery = """
  query SearchQueries(\$lastEventId: String!, \$take: Float!, \$search: String!, \$orderByLikes: Boolean) {
  searchQueries(lastEventId: \$lastEventId, take: \$take, search: \$search, OrderByLikes: \$orderByLikes) {
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
mutation(\$id: String!, \$editMyQuerysData: editQuerysInput!, \$image: [Upload!], \$attachments: [Upload!]){
  editMyQuery(MyQueryId: \$id, EditMyQuerysData: \$editMyQuerysData, Image: \$image, Attachments: \$attachments)
}
  """;

  String deleteQuery = """
 mutation(\$myQueryId: String!){
  deleteMyQuery(MyQueryId: \$myQueryId)
}
  """;

  String reportMyQuery = """
  mutation(\$description: String!, \$id: String!){
  reportMyQuery(description: \$description, MyQueryId: \$id)
}
  """;
}
