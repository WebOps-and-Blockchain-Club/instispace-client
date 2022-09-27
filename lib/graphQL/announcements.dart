class AnnouncementGQL {
  static const getAll = """
    query GetAnnouncements(
      \$take: Float!
      \$lastId: String!
      \$hostelId: String
      \$filters: FilteringConditions
    ) {
      getAnnouncements(
        take: \$take
        LastAnnouncementId: \$lastId
        HostelId: \$hostelId
        Filters: \$filters
      ) {
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
    mutation(\$announcementInput: CreateAnnouncementInput!) {
      createAnnouncement(AnnouncementInput: \$announcementInput) {
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
    ) {
      editAnnouncement(
        UpdateAnnouncementInput: \$updateAnnouncementInput
        AnnouncementId: \$id
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
