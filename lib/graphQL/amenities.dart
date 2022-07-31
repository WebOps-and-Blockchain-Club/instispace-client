class AmenitiesGQL {
  static const getAll = """
    query(\$hostelId: String!) {
      getAmenities(HostelId: \$hostelId) {
        id
        name
        description
        images
        hostel {
          id
          name
        }
        permissions
      }
    }
  """;

  static const create = """
    mutation(\$hostelId: String!, \$createAmenityInput: CreateAmenityInput!) {
      createAmenity(HostelId: \$hostelId, CreateAmenityInput: \$createAmenityInput) {
        id
        name
        description
        images
        hostel {
          id
          name
        }
        permissions
      }
    }
  """;

  static const edit = """
    mutation(\$updateAmenityInput: EditAmenityInput!, \$id: String!) {
      updateAmenity(
        UpdateAmenityInput: \$updateAmenityInput
        AmenityId: \$id
      ) {
        id
        name
        description
        images
        hostel {
          id
          name
        }
        permissions
      }
    }
  """;

  static const delete = """
    mutation(\$id: String!) {
      deleteAmenity(AmenityId: \$id)
    }
  """;
}
