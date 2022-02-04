class netopsQuery{
  String getNetops ="""query(\$skip: Float!, \$take: Float!,\$orderByLikes: Boolean, ){
  getNetops(skip: \$skip, take: \$take,OrderByLikes: \$orderByLikes) {
    netopList {
      id,
      content,
      comments {
        content
        id
        createdBy {
        name
       }
      },
      createdBy {
        id
      }
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
  String createComment = """mutation(\$content: String!, \$netopId: String!){
  createComment(content: \$content, NetopId: \$netopId)
}""";
  String createNetop ="""
  mutation(\$newEventData: createNetopsInput!, \$image: Upload, \$attachments: [Upload!]){
  createNetop(NewEventData: \$newEventData, Image: \$image, Attachments: \$attachments)
}
""";
  String toggleLike ="""
  mutation(\$toggleLikeNetopNetopId2: String!){
  toggleLikeNetop(NetopId: \$toggleLikeNetopNetopId)
}
}
  """;
  String isLiked="""
  query(\$isLikedNetopId2: String!){
  isLiked(NetopId: \$isLikedNetopId2)
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
  mutation(\$editNetopNetopId: String!, \$editNetopsData: editNetopsInput!, \$editNetopAttachments: [Upload!], \$editNetopImage: Upload, \$tags: [String!]){
  editNetop(NetopId: \$editNetopNetopId, EditNetopsData: \$editNetopsData, Attachments: \$editNetopAttachments, Image: \$editNetopImage, Tags: \$tags)
}
  """;
  String reportNetop="""
  mutation(\$description: String!, \$reportNetopNetopId: String!){
  reportNetop(description: \$description, NetopId: \$reportNetopNetopId)
}
  """;
}