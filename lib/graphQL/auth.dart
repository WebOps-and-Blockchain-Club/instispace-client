class authQuery{
  String login = """mutation(\$loginInputs: LoginInput!){
  login( LoginInputs: \$loginInputs)
   {
    role
    token
    isNewUser
  }
}""";
}
