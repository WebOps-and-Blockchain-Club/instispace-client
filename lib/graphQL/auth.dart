class AuthGQL {
  String login = """
    mutation(\$loginInputs: LoginInput!){
      login(loginInput: \$loginInputs) {
        token
      }
    }
  """;

  String logout = """
    mutation(\$fcmToken: String!){
      logout(fcmToken: \$fcmToken)
    }
  """;

  static const updateFCMToken = """
    mutation(\$fcmToken: String!){
      updateFCMToken(fcmToken: \$fcmToken)
    }
  """;

  String updateUser = """
    mutation UpdateUser(\$userInput: UpdateUserInput!) {
      updateUser(userInput: \$userInput)
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
