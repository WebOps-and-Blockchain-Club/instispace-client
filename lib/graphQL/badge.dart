class BadgeGQL {
  String markAttendance = """mutation MarkEventAttendance(\$postId: String!) {
  markEventAttendance(postId: \$postId) {
    id
    pointsValue
  }
}
""";
  String createClub = """mutation(\$createClubInput: CreateClubInput!) {
  createClub(createClubInput: \$createClubInput){
    clubId
    clubName
  }
}
""";

  String updateClub = """mutation(\$updateClubInput: UpdateClubInput!) {
  updateClub(updateClubInput: \$updateClubInput) {
    clubId
    clubName
  }
}
""";
  String toggleIsQRActive =
      """mutation ToggleIsQRActive(\$postId: String!, \$points: Float!) {
  toggleIsQRActive(postId: \$postId, points: \$points) {
    id
  }
}""";
  String createBadges = """
mutation CreateBadges(\$createBadgesInput: CreateBadgesInput!){
  createBadges(createBadgesInput : \$createBadgesInput){
    
  }
}
""";
  String getMyClub = """query GetMyClub {
  getMyClub {
    badges {
      imageURL
      threshold
      tier
    }
    logo
    clubId
    clubName
  }
}""";
}
