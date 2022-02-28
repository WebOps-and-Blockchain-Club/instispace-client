class AnnouncementMutations {
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