class AnnouncementQM {
  String getAnnouncements = """
   query GetAnnouncements(\$hostelId: String!, \$take: Float!, \$lastAnnouncementId: String!, \$search: String) {
  getAnnouncements(HostelId: \$hostelId, take: \$take, LastAnnouncementId: \$lastAnnouncementId, search: \$search) {
    announcementsList {
      title
        description
        endTime
        id
        images
        user {
          id
          role
        }
        hostels {
          name
          id
        }
    }
    total
  }
}

  """;

  String getAllAnnouncements = """
query GetAllAnnouncements(\$take: Float!, \$lastAnnouncementId: String!, \$search: String) {
  getAllAnnouncements(take: \$take, LastAnnouncementId: \$lastAnnouncementId, search: \$search) {
    total
    announcementsList {
    title
        description
        endTime
        id
        user {
          id
          role
        }
        images
        createdAt
        hostels {
          name
          id
        }
    }
  }
}
 """;

  String createAnnouncements = """
  mutation(\$announcementInput: CreateAnnouncementInput!,\$images: [Upload!]){
    createAnnouncement(AnnouncementInput: \$announcementInput, Images: \$images)
  }
  """;

  String editAnnouncements = """
   mutation(\$updateAnnouncementInput: EditAnnouncementInput!, \$announcementId: String!){
  editAnnouncement(UpdateAnnouncementInput: \$updateAnnouncementInput, AnnouncementId: \$announcementId)
}
  """;

  String deleteAnnouncement = """
   mutation(\$announcementId: String!){
  resolveAnnouncement(AnnouncementId: \$announcementId)
}
  """;
}