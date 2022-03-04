class authQuery{
  String login = """mutation(\$loginInputs: LoginInput!){
  login( LoginInputs: \$loginInputs)
   {
    role
    token
    isNewUser
  }
}""";
String getHostels ="""
query{
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
