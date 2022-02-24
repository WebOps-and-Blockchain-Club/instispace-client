class homeQuery{
  String getMeHome = """
query{
  getMe {
    getHome {
      netops {
        title
        id
        content
        isStared
        tags {
          title
          category
          id
        }
      }
      events {
        title
        id
        isStared
        isLiked
        tags {
          title
          category
          id
        }
        location
        time
      }
      announcements {
        title
        images
        description
        id
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
      }
      contacts {
        type
        name
        contact
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
  String searchUser="""
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
  String getUser="""
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
      title
      content
      isStared
      id
      tags {
        id
        title
        category
      }
    }
    events {
      id
      title
      content
      isStared
      time
      location
      tags {
        id
        title
        category
      }
    }
  }
}
""";
}