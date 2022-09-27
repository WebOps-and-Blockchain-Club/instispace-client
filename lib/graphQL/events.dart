class EventGQL {
  String create = """
    mutation(\$newData: createEventInput!){
      createEvent(NewEventData: \$newData) {
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
    mutation(\$editData: editEventInput!, \$id: String!){
      editEvent(EditEventData: \$editData, EventId: \$id) {
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
    query(\$take: Float!, \$lastId: String!, \$sort: OrderInput, \$filters: FilteringConditions){
      getEvents(take: \$take, lastEventId: \$lastId, Sort: \$sort, Filters: \$filters) {
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
