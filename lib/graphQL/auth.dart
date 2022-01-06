class authQuery{
  String login = """mutation(\$loginInputs: LoginInput!){
  login( LoginInputs: \$loginInputs)
   {
    role
    token
    isNewUser
  }
}""";
String getHostels ="""query{
  getHostels {
    name
  }
}""";
String getTags ="""
query{
  getTags {
    id
    title
  }
}""";
}
