class AnnouncementGQL {
  static const getAll = """
    query GetAnnouncements(\$hostelId: String!, \$take: Float!, \$lastId: String!, \$search: String) {
      getAnnouncements(HostelId: \$hostelId, take: \$take, LastAnnouncementId: \$lastId, search: \$search) {
        announcementsList {
          title
          description
          endTime
          id
          images
          permissions
          user {
            id
            roll
            role
            name
          }
          hostels {
            name
            id
          }
          createdAt
        }
        total
      }
    }
  """;

  static const create = """
    mutation(\$announcementInput: CreateAnnouncementInput!, \$images: [Upload!]) {
      createAnnouncement(AnnouncementInput: \$announcementInput, Images: \$images) {
        id
        title
        images
        description
        createdAt
        endTime
        user {
          id
          roll
          name
          role
        }
        hostels {
          id
          name
        }
        permissions
      }
    }
  """;

  static const edit = """
    mutation(
      \$updateAnnouncementInput: EditAnnouncementInput!
      \$id: String!
      \$images: [Upload!]
    ) {
      editAnnouncement(
        UpdateAnnouncementInput: \$updateAnnouncementInput
        AnnouncementId: \$id
        Images: \$images
      ) {
        id
        title
        images
        description
        createdAt
        endTime
        user {
          id
          roll
          name
          role
        }
        hostels {
          id
          name
        }
        permissions
      }
    }
  """;

  static const delete = """
    mutation(\$id: String!){
      deleteAnnouncement(AnnouncementId: \$id)
    }
  """;

  static const editFragment = """
    fragment editAnnouncement on Announcement {
      id
      title
      description
      images
      createdAt
      permissions
      hostels {
        id
        name
      }
    }
  """;
}
