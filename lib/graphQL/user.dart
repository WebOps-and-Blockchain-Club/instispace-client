class UserGQL {
  String getMe = """
    query{
      getMe {
        getHome {
          netops {
            id
            commentCount
            title
            content
            photo
            attachments
            likeCount
            isStared
            linkName
            endTime
            createdAt
            linkToAction
            comments {
              content
              id
              createdBy {
                id
                name
              }
            }
            tags {
              id
              title
              category
            }
            isLiked
            isStared
            createdBy {
              id
              name
            }
          }
          events {
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
          }
          announcements {
            id
            title
            description
            images
            createdAt
            endTime
            isHidden
            user {
              id
              name
            }
            hostels {
              id
              name
            }
          }
        }
        interest {
          title
          id
          category
        }
        name
        roll
        role
        isNewUser
        id
        mobile
        hostel {
          name
          id
        }
      }
    }
  """;
}
