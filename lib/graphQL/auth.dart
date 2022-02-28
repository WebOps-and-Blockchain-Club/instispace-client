class authQuery{
  String login = """mutation(\$loginInputs: LoginInput!,\$fcmToken: String!){
  login( LoginInputs: \$loginInputs fcmToken: \$fcmToken)
   {
    role
    token
    isNewUser
  }
}""";
String getHostels ="""query{
  getHostels {
    name
    id
  }
}""";
String getTags ="""
query{
  getTags {
    id
    title
    category
  }
}""";
String updateUser ="""mutation(\$userInput: UserInput!){
  updateUser(UserInput: \$userInput)
}""";
String updatePassword ="""mutation(\$newPass: NewPass!){
  updatePassword(NewPass: \$newPass)
}""";
}
