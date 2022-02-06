class homeQuery{
  String getMeHome = """
query{
  getMe {
    getHome {
      netops {
        title
        id
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
        tags {
          title
          category
          id
        }
        location
        time
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
  String createHostel = """
  mutation(\$createHostelInput: CreateHostelInput!) {
    createHostel(CreateHostelInput: \$createHostelInput)
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
}