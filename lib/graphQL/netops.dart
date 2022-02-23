class netopsQuery{
  String getNetops ="""query( \$take: Float!,\$orderByLikes: Boolean,\$filteringCondition: fileringConditions,\$lastId: String!){
  getNetops(take: \$take, OrderByLikes: \$orderByLikes, FileringCondition: \$filteringCondition,LastNetopId: \$lastId) {
    netopList {
      id,
      content,
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
      linkName
      linkToAction
      title
      isHidden
      endTime
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
  },
}""";
  String createComment = """
  mutation(\$content: String!, \$netopId: String!){
  createCommentNetop(content: \$content, NetopId: \$netopId)
}
""";
  String createNetop ="""
  mutation(\$newEventData: createNetopsInput!, \$image: Upload, \$attachments: [Upload!]){
  createNetop(NewEventData: \$newEventData, Image: \$image, Attachments: \$attachments)
}
""";
  String toggleLike ="""
  mutation(\$netopId: String!){
  toggleLikeNetop(NetopId: \$netopId)
}
  """;
  String getNetop="""
  query(\$getNetopNetopId: String!){
  getNetop(NetopId: \$getNetopNetopId){
    likeCount
    isStared
    isLiked
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
  String toggleStar="""
  mutation(\$toggleStarNetopId: String!){
  toggleStar(NetopId: \$toggleStarNetopId)
}
  """;
  String getMe="""
  query{
  getMe {
    id
  }
}
  """;
  String deleteNetop="""
  mutation(\$deleteNetopNetopId: String!){
  deleteNetop(NetopId: \$deleteNetopNetopId)
}
  """;
  String editNetop="""
  mutation(\$editNetopNetopId: String!, \$editNetopsData: editNetopsInput!, \$editNetopAttachments: [Upload!], \$editNetopImage: Upload){
  editNetop(NetopId: \$editNetopNetopId, EditNetopsData: \$editNetopsData, Attachments: \$editNetopAttachments, Image: \$editNetopImage)
}
  """;
  String reportNetop="""
  mutation(\$description: String!, \$reportNetopNetopId: String!){
  reportNetop(description: \$description, NetopId: \$reportNetopNetopId)
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