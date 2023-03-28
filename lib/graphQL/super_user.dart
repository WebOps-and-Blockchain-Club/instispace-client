class SuperUserGQL {
  String createAccount = """
    mutation CreateUser(\$user: CreateUserInput!, \$permission: PermissionInput!) {
      createUser(user: \$user, permission: \$permission) {
        id
        isNewUser
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
