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
String getUserBadges = """query GetMyBadges(\$userId: String!) {
  getMyBadges(userId: \$userId) {
    list {
      id
      imageURL
      threshold
      tier
    }
    total
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
String updateBadge = """
mutation UpdateBadge(\$badgeId: String!, \$updateBadgeInput: UpdateBadgeInput!) {
  updateBadge(badgeId: \$badgeId, updateBadgeInput: \$updateBadgeInput) {
    id
    threshold
  }
}""";
String updatePoints = """mutation UpdatePoints(\$postId: String!, \$points: Float!) {
  updatePoints(postId: \$postId, points: \$points) {
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
      id
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
