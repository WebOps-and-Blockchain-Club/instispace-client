class eventsQuery {
  String getEvents = """
  query(\$getEventsTake: Float!, \$lastEventId: String!, \$orderByLikes: Boolean, \$filteringCondition: fileringConditions,\$search: String){
  getEvents(take: \$getEventsTake, lastEventId: \$lastEventId, OrderByLikes: \$orderByLikes, FileringCondition: \$filteringCondition, search: \$search) {
  list {
      id
        createdAt
        title
        content
        photo
        location
        time
        likeCount
        isStared
        linkName
        linkToAction
        tags {
          title
          id
          category
        }
        isLiked
        createdAt
        createdBy {
          id
          name
        }
    }
    total
  }
}
""";
  String toggleLike = """
  mutation(\$eventId: String!){
  toggleLikeEvent(EventId: \$eventId)
}
  """;
  String toggleStar = """
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
        createdAt
        title
        content
        photo
        location
        time
        likeCount
        isStared
        linkName
        linkToAction
        tags {
          title
          id
          category
        }
        isLiked
        createdBy {
          id
          name
        }
},
}
  """;
  String createEvent = """
  mutation(\$newEventData: createEventInput!, \$image: [Upload!]){
  createEvent(NewEventData: \$newEventData, Image: \$image)
}
  """;
  String editEvent = """
  mutation(\$editEventData: editEventInput!, \$eventId: String!, \$image: [Upload!]){
  editEvent(EditEventData: \$editEventData, EventId: \$eventId, Image: \$image)
}
  """;
}
