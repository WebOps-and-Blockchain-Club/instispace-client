class homeQuery{
  String getMe = """
query {
  getMe {
    id
    roll
    role
    name
    isNewUser
    hostel {
      id
      name
      __typename
    }
    interest {
      id
      title
      __typename
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
}