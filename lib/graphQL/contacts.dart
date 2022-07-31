class ContactsGQL {
  static const getAll = """
    query(\$hostelId: String!) {
      getContact(HostelId: \$hostelId) {
        id
        name
        type
        contact
        hostel {
          id
          name
        }
        permissions
      }
    }
  """;

  static const create = """
    mutation(\$hostelId: String!, \$createContactInput: CreateContactInput!) {
      createHostelContact(
        HostelId: \$hostelId
        CreateContactInput: \$createContactInput
      ) {
        id
        name
        type
        contact
        hostel {
          id
          name
        }
        permissions
      }
    }
  """;

  static const edit = """
    mutation(\$updateContactInput: EditContactInput!, \$id: String!) {
      updateHostelContact(
        UpdateContactInput: \$updateContactInput
        ContactId: \$id
      ) {
        id
        name
        type
        contact
        permissions
        hostel {
          id
          name
        }
      }
    }
  """;

  static const delete = """
    mutation(\$id: String!) {
      deleteHostelContact(ContactId: \$id)
    }
  """;
}
