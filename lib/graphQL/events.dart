class eventsQuery{
  String getEvents="""
query(\$skip: Float!, \$take: Float!, \$orderByLikes: Boolean, \$filteringCondition: fileringConditions){
  getEvents(skip: \$skip, take: \$take, OrderByLikes: \$orderByLikes, FileringCondition: \$filteringCondition) {
    list {
      id
      createdAt
      title
      content
      photo
      isHidden
      time
      location
      likeCount
      isStared
      linkName
      linkToAction
      tags {
        id
        title
        category
      }
      isLiked
      createdBy {
        id
      }
    }
    total
  }
  getMe {
    id
    role
  }
}
""";
  String toggleLike = """
  mutation(\$eventId: String!){
  toggleLikeEvent(EventId: \$eventId)
}
  """;
  String toggleStar="""
  mutation(\$eventId: String!){
  toggleStarEvent(EventId: \$eventId)
}
  """;
  String deleteEvent = """
  mutation(\$eventId: String!){
  deleteEvent(EventId: \$eventId)
}
  """;
  String getEvent = """
  query(\$eventId: String!){
getEvent(EventId: \$eventId) {
  id
  isStared
  isLiked
  createdBy {
    id
  }
  likeCount
},
getMe {
    id
  }
}
  """;
  String createEvent = """
  mutation(\$newEventData: createEventInput!, \$image: [Upload!]){
  createEvent(NewEventData: \$newEventData, Image: \$image)
}
  """;
  String editEvent="""
  mutation(\$editEventData: editEventInput!, \$eventId: String!, \$editEventImage: [Upload!]){
  editEvent(EditEventData: \$editEventData, EventId: \$eventId, Image: \$editEventImage)
}
  """;
}