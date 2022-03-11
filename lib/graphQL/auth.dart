class authQuery {
  String login = """mutation(\$fcmToken: String!, \$loginInputs: LoginInput!){
  login(fcmToken: \$fcmToken, LoginInputs: \$loginInputs) {
    token
    role
    isNewUser
  }
}""";
  String logOut = """
  mutation(\$fcmToken: String!){
  logout(fcmToken: \$fcmToken)
}
  """;
  String getHostels = """query{
  getHostels {
    id
    name
    contacts {
      id
      name
      type
      contact
      hostel {
        name
        id
      }
    }
    amenities {
      id
      name
      description
      hostel {
        id
        name
      }
    }
  }
}
""";
  String getTags = """
query{
  getTags {
    id
    title
    category
  }
}""";
  String updateUser = """mutation(\$userInput: UserInput!){
  updateUser(UserInput: \$userInput)
}""";
  String updatePassword = """
  mutation(\$updateSuperUserInput: UpdateSuperUserInput!){
  updateSuperUser(UpdateSuperUserInput: \$updateSuperUserInput)
}
""";
}
