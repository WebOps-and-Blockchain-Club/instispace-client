class AuthGQL {
  String login = """
    mutation(\$loginInputs: LoginInput! , \$fcmToken: String!){
      login(loginInput: \$loginInputs, fcmToken: \$fcmToken) {
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

  String forgotPassword = """
  mutation ForgotPassword(\$forgotPasswordInput: ForgotPasswordInput!) {
    forgotPassword(forgotPasswordInput: \$forgotPasswordInput)
  }
  """;
}
