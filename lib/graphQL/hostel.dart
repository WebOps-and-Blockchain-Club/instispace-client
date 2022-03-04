class hostelQM{
  String updateAmenity = """
  mutation(\$updateAmenityInput: EditAmenityInput!, \$amenityId: String!){
  updateAmenity(UpdateAmenityInput: \$updateAmenityInput, AmenityId: \$amenityId)
}
  """;

  String deleteAmenity = """
  mutation(\$amenityId: String!){
  deleteAmenity(AmenityId: \$amenityId)
}
""";
}