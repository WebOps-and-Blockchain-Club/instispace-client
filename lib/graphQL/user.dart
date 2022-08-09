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
            permissions
            comments {
              content
              id
              createdBy {
                id
                name
              }
              createdAt
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
            permissions
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
            permissions
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
        permissions
        hostel {
          name
          id
        }
        department
        program
      }
    }
  """;

  String searchUser = """
    query(\$search: String!) {
      searchLDAPUser(search: \$search) {
        roll
        name
        department
      }
    }
  """;

  String getUser = """
    query(\$getUserInput: GetUserInput!) {
      getUser(GetUserInput: \$getUserInput) {
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
