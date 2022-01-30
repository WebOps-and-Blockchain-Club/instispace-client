class homeQuery{
  String getMe = """
query {
  getMe {
    id
    roll
    role
    name
    isNewUser
    hostel {
      id
      name
      __typename
    }
    interest {
      id
      title
      __typename
    }
    }
  }
""";

  String getAnnouncements = """
   query(\$hostelId: String!) {
    getAnnouncements(HostelId: \$hostelId) {
      title
      description
      endTime
      id
      images
      hostels {
        name
        id
      }
    }
  }
  """;

 String getAllAnnouncements = """
   query {
    getAllAnnouncements {
      title
      description
      endTime
      id
      images
      hostels {
        name
        id
      }
    }
  }
 """;


  String createHostel = """
  mutation(\$createHostelInput: CreateHostelInput!) {
    createHostel(CreateHostelInput: \$createHostelInput)
  }
  """;
  String createTag = """
  mutation(\$tagInput: TagInput!){
    createTag(TagInput: \$tagInput)
  }
  """;
  String createSuperUser = """
  mutation(\$createAccountInput: CreateAccountInput!) {
    createAccount(CreateAccountInput: \$createAccountInput)
  }
  """;
  String createAnnouncements = """
  mutation(\$announcementInput: CreateAnnouncementInput!,\$images: [Upload!]){
    createAnnouncement(AnnouncementInput: \$announcementInput, Images: \$images)
  }
  """;

  String editAnnouncements = """
   mutation(\$announcementId: String!) {
    editAnnouncement(AnnouncementId: \$announcementId)
  }
  """;

  String deleteAnnouncement = """
   mutation(\$deleteAnnouncementAnnouncementId2: String!){
    deleteAnnouncement(AnnouncementId: \$deleteAnnouncementAnnouncementId2)
  }
  """;
}