class SuperUserGQL {
  String createAccount = """
    mutation CreateUser(\$user: CreateUserInput!, \$permission: PermissionInput!, \$hostelId: String) {
      createUser(user: \$user, permission: \$permission, hostelId: \$hostelId) {
        id
        isNewUser
        permission {
          approvePosts
          createTag
          handleReports
          account
          livePosts
        }
      }
    }
  """;

  String createHostel = """
    mutation CreateHostel(\$name: String!) {
      createHostel(name: \$name) {
        id
        name
      }
    }
  """;

  String getCategories = """
    query{
      getCategories
    }
  """;

  String createTag = """
    mutation(\$createTagInput: CreateTagInput!) {
    createTag(CreateTagInput: \$createTagInput) {
      id
      title
      category
    }
}
  """;

  String updateRole = """
    mutation(\$moderatorInput: ModeratorInput!){
      updateRole(ModeratorInput: \$moderatorInput)
    }
  """;
}
