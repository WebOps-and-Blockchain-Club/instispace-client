class AnnouncementQueries {
  String getAnnouncements = """
   query(\$hostelId: String!, \$skip: Float!, \$take: Float!) {
    getAnnouncements(HostelId: \$hostelId, skip: \$skip, take: \$take) {
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
   query (\$skip: Float!, \$take: Float!) {
    getAllAnnouncements(skip: \$skip, take: \$take) {
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
      total
    }
  }
 """;
}