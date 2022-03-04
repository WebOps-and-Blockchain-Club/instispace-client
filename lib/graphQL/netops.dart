class netopsQuery {
  String getNetops = """
  query(\$take: Float!, \$lastNetopId: String!, \$filteringCondition: fileringConditions, \$orderByLikes: Boolean, \$search: String){
  getNetops(take: \$take, LastNetopId: \$lastNetopId, FileringCondition: \$filteringCondition, OrderByLikes: \$orderByLikes, search:\$search) {
    netopList {
      id,
      content,
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
  getMe {
    id
    name
  }
}
""";
  String createComment = """
  mutation(\$content: String!, \$netopId: String!){
  createCommentNetop(content: \$content, NetopId: \$netopId)
}
""";
  String createNetop = """
  mutation(\$newNetopData: createNetopsInput!, \$image: Upload, \$attachments: [Upload!]){
  createNetop(NewNetopData: \$newNetopData, Image: \$image, Attachments: \$attachments)
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
  getMe {
    id
  }
}
  """;
  String toggleStar = """
  mutation(\$netopId: String!){
  toggleStar(NetopId: \$netopId)
}
  """;
  String getMe = """
  query{
  getMe {
    id
  }
}
  """;
  String deleteNetop = """
  mutation(\$netopId: String!){
  deleteNetop(NetopId: \$netopId)
}
  """;
  String editNetop = """
  mutation EditNetop(\$editNetopsData: editNetopsInput!, \$netopId: String!, \$attachments: [Upload!], \$image: Upload) {
  editNetop(EditNetopsData: \$editNetopsData, NetopId: \$netopId, Attachments: \$attachments, Image: \$image)
}
""";
  String reportNetop = """
 mutation(\$description: String!, \$netopId: String!){
  reportNetop(description: \$description, NetopId: \$netopId)
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
