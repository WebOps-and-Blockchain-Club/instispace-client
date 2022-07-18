class SuperUserGQL {
  String createAccount = """
    mutation(\$createAccountInput: CreateAccountInput!, \$hostelId: String){
      createAccount(CreateAccountInput: \$createAccountInput, HostelId: \$hostelId)
    }
  """;

  String createHostel = """
    mutation(\$createHostelInput: CreateHostelInput!) {
      createHostel(CreateHostelInput: \$createHostelInput)
    }
  """;

  String getCategories = """
    query{
      getCategories
    }
  """;

  String createTag = """
    mutation(\$tagInput: TagInput!){
      createTag(TagInput: \$tagInput)
    }
  """;

  String updateRole = """
    mutation(\$moderatorInput: ModeratorInput!){
      updateRole(ModeratorInput: \$moderatorInput)
    }
  """;
}
