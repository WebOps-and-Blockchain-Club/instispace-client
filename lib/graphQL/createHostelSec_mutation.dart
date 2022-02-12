class createHostelSec {
  String  createSec = """
  mutation(\$hostelId: String!, \$createSecInput: CreateSecInput!){
  createSec(HostelId: \$hostelId, CreateSecInput: \$createSecInput)
}
  """;
}