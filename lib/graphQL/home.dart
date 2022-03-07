class homeQuery {
  String getMeHome = """
query{
  getMe {
    getHome {
      netops {
        id
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

  String getMe = """
  query{
  getMe {
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
      amenities {
        name
        description
        id
        hostel{
        id
        name
        }
      }
      contacts {
        type
        name
        contact
        id
      }
    }
  }
}
  """;
  String createHostel = """
  mutation(\$createHostelInput: CreateHostelInput!) {
    createHostel(CreateHostelInput: \$createHostelInput)
  }
  """;

  String createAmenity = """
  mutation(\$hostelId: String!, \$createAmenityInput: CreateAmenityInput!){
  createAmenity(HostelId: \$hostelId, CreateAmenityInput: \$createAmenityInput)
}
  """;

  String createHostelContact = """
  mutation(\$hostelId: String!, \$createContactInput: CreateContactInput!){
  createHostelContact(HostelId: \$hostelId, CreateContactInput: \$createContactInput)
}
  """;

  String createTag = """
  mutation(\$tagInput: TagInput!){
    createTag(TagInput: \$tagInput)
  }
  """;
  String createSuperUser = """
  mutation(\$createAccountInput: CreateAccountInput!) {
    createAccount(CreateAccountInput: \$createAccountInput)
  }
  """;
  String toggelStarEvent = """
  mutation(\$eventId: String!){
  toggleStarEvent(EventId: \$eventId)
  }
  """;
  String searchUser = """
query(\$take: Float!, \$lastUserId: String!, \$search: String){
  searchUser(take: \$take, LastUserId: \$lastUserId, search: \$search) {
    usersList {
      id
      name
      roll
      role
      hostel {
        name
      }
    }
    total
  }
}
  """;
  String getUser = """
  query(\$getUserInput: GetUserInput!){
  getUser(GetUserInput: \$getUserInput) {
    interest {
      title
      id
      category
    }
  }
}
  """;

  String getTag = """
query GetTag(\$tag: String!) {
  getTag(Tag: \$tag) {
    title
    category
    netops {
      id
      createdAt
      title
      content
      photo
      attachments
      endTime
      likeCount
      isStared
      linkName
      linkToAction
      comments {
        id
        content
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
        name
      }
    }
  }
}
""";
}
