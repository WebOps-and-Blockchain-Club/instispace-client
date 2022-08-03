class NetopGQL {
  static const create = """
    mutation(\$newData: createNetopsInput!, \$attachments: [Upload!], \$image: [Upload!]){
      createNetop(NewNetopData: \$newData, Attachments: \$attachments, Image: \$image) {
        id,
        content,
        commentCount
        comments {
          content
          id
          images
          createdBy {
            name
            id
            roll
          }
        }
        createdBy {
          id
          name
          roll
        }
        linkName
        linkToAction
        title
        isLiked
        isStared
        isHidden
        endTime
        createdAt
        tags {
          category
          title
          id
        }
        likeCount
        photo
        attachments
        permissions
      }
    }
  """;

  static const edit = """
    mutation(\$editData: editNetopsInput!, \$id: String!){
      editNetop(EditNetopsData: \$editData, NetopId: \$id)
    }
  """;

  static const delete = """
    mutation(\$id: String!){
      deleteNetop(NetopId: \$id)
    }
  """;

  static const getAll = """
    query(
      \$take: Float!
      \$lastId: String!
      \$filteringCondition: fileringConditions
      \$orderByLikes: Boolean
      \$search: String
    ) {
      getNetops(
        take: \$take
        LastNetopId: \$lastId
        FileringCondition: \$filteringCondition
        OrderByLikes: \$orderByLikes
        search: \$search
      ) {
        netopList {
          id
          content
          commentCount
          comments {
            content
            id
            images
            createdBy {
              name
              id
              roll
            }
            createdAt
          }
          createdBy {
            id
            name
            roll
          }
          linkName
          linkToAction
          title
          isLiked
          isStared
          isHidden
          endTime
          createdAt
          permissions
          tags {
            category
            title
            id
          }
          likeCount
          photo
          attachments
        }
        total
      }
    }
  """;

  static const like = """
    mutation(\$id: String!){
      toggleLikeNetop(NetopId: \$id)
    }
  """;

  static const star = """
    mutation(\$id: String!){
      toggleStar(NetopId: \$id)
    }
  """;

  static const report = """
    mutation(\$description: String!, \$id: String!){
      reportNetop(description: \$description, NetopId: \$id)
    }
  """;

  static const createComment = """
    mutation(\$content: String!, \$id: String!, \$images: [Upload!]){
      createCommentNetop(content: \$content, NetopId: \$id, Images: \$images){
        id
        content
        images
        createdAt
        createdBy {
          id
          name
          roll
        }
      }
    }
  """;
}

class netopsQuery {
  String getNetops = """
  query(\$take: Float!, \$lastNetopId: String!, \$filteringCondition: fileringConditions, \$orderByLikes: Boolean, \$search: String){
  getNetops(take: \$take, LastNetopId: \$lastNetopId, FileringCondition: \$filteringCondition, OrderByLikes: \$orderByLikes, search:\$search) {
    netopList {
      id,
      content,
      commentCount
      comments {
        content
        id
        createdBy {
         name
         id
        }
      }
      createdBy {
        id
        name
      }
      linkName
      linkToAction
      title
      isLiked
      isStared
      isHidden
      endTime
      createdAt
      tags {
        category,
        title,
        id
      }
      likeCount
      photo
      attachments
    }
    total
  }
}
""";
  String createComment = """
  mutation(\$content: String!, \$netopId: String!, \$images: [Upload!]){
  createCommentNetop(content: \$content, NetopId: \$netopId, Images: \$images)
}
""";
  String createNetop = """
  mutation(\$newNetopData: createNetopsInput!, \$attachments: [Upload!], \$image: [Upload!]){
  createNetop(NewNetopData: \$newNetopData, Attachments: \$attachments, Image: \$image)
}
""";
  String toggleLike = """
mutation(\$netopId: String!){
  toggleLikeNetop(NetopId: \$netopId)
}
  """;
  String getNetop = """
  query(\$getNetopNetopId: String!){
  getNetop(NetopId: \$getNetopNetopId){
    likeCount
    isStared
    isLiked
    createdAt
    comments {
      images
      content
      id
      createdBy {
        name
      }
    }
    createdBy {
      id
    }
  },
}
  """;
  String getComments = """
  query(\$getNetopNetopId: String!){
  getNetop(NetopId: \$getNetopNetopId){
    comments {
      images
      content
      id
      createdBy {
        name
      }
    }
  },
}
  """;

  String toggleStar = """
  mutation(\$netopId: String!){
  toggleStar(NetopId: \$netopId)
}
  """;

  String deleteNetop = """
  mutation(\$netopId: String!){
  deleteNetop(NetopId: \$netopId)
}
  """;
  String editNetop = """
 mutation(\$editNetopsData: editNetopsInput!, \$netopId: String!){
  editNetop(EditNetopsData: \$editNetopsData, NetopId: \$netopId)
}
""";
  String reportNetop = """
 mutation(\$description: String!, \$id: String!){
  reportNetop(description: \$description, NetopId: \$id)
}
  """;
  String netopSubscription = """
  subscription{
  createNetop2 {
    id
    title
    content
  }
}
  """;
}
