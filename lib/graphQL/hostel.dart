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

  String getContact = """
query(\$hostelId: String!){
  getContact(HostelId: \$hostelId) {
    type
    name
    id
    contact
    hostel {
      name
      id
    }
  }
}
  """;

  String getAmenities = """
query(\$hostelId: String!){
  getAmenities(HostelId: \$hostelId) {
    id
    name
    description
    hostel {
      name
      id
    }
  }
}
  """;

  String deleteContact = """
mutation(\$contactId: String!){
  deleteHostelContact(ContactId: \$contactId)
}
  """;

  String updateContact = """
  mutation(\$updateContactInput: EditContactInput!, \$contactId: String!){
  updateHostelContact(UpdateContactInput: \$updateContactInput, ContactId: \$contactId)
}
  """;
}