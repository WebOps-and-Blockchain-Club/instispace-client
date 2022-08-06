class AuthGQL {
  String login = """
    mutation(\$fcmToken: String!, \$loginInputs: LoginInput!){
      login(fcmToken: \$fcmToken, LoginInputs: \$loginInputs) {
        token
        role
        isNewUser
      }
    }
  """;

  String logout = """
    mutation(\$fcmToken: String!){
      logout(fcmToken: \$fcmToken)
    }
  """;

  String updateUser = """
    mutation(\$userInput: UserInput!){
      updateUser(UserInput: \$userInput)
    }
  """;

  String updatePassword = """
    mutation(\$updateSuperUserInput: UpdateSuperUserInput!){
      updateSuperUser(UpdateSuperUserInput: \$updateSuperUserInput)
    }
  """;

  String getHostel = """
    query{
      getHostels {
        id
        name
      }
    }
  """;
}
