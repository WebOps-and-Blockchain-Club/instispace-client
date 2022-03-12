class UpdateRoles{
  String updateRole = """
  mutation(\$moderatorInput: ModeratorInput!){
  updateRole(ModeratorInput: \$moderatorInput)
}
  """;
}