class EventGQL {
  String create = """
    mutation(\$newData: createEventInput!, \$image: [Upload!]){
      createEvent(NewEventData: \$newData, Image: \$image) {
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
        permissions
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
    }
  """;
  String edit = """
    mutation(\$editData: editEventInput!, \$id: String!, \$image: [Upload!]){
      editEvent(EditEventData: \$editData, EventId: \$id, Image: \$image) {
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
        permissions
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
    }
  """;
  String getAll = """
    query(\$take: Float!, \$lastId: String!, \$orderByLikes: Boolean, \$filteringCondition: fileringConditions,\$search: String){
      getEvents(take: \$take, lastEventId: \$lastId, OrderByLikes: \$orderByLikes, FileringCondition: \$filteringCondition, search: \$search) {
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
          permissions
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
  String get = """
    query(\$id: String!){
      getEvent(EventId: \$id) {
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
  String delete = """
    mutation(\$id: String!){
      deleteEvent(EventId: \$id)
    }
  """;
  String toggleLike = """
    mutation(\$id: String!){
      toggleLikeEvent(EventId: \$id)
    }
  """;
  String toggleStar = """
    mutation(\$id: String!){
      toggleStarEvent(EventId: \$id)
    }
  """;

  static const editFragment = """
    fragment eventUpdateField on Event {
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
      permissions
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
  """;
}
