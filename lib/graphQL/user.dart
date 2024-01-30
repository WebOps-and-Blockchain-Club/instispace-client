class UserGQL {
  String getMe = """
    query {
      getMe {
        id
        roll
        ldapName
        name
        role
        photo
        isNewUser
        mobile
        interests {
          id
          title
          category
        }
        hostel {
          id
          name
        }
        permission {
          createNotification
          approvePosts
          createTag
          handleReports
          account
          livePosts
        }
        notifConfig {
          fcmToken
        }
      }
    }
  """;

  String searchUser = """
query GetLdapStudents(
  \$take: Float!
  \$filteringconditions: LdapFilteringConditions!
  \$lastUserId: String!
) {
  getLdapStudents(
    take: \$take
    filteringconditions: \$filteringconditions
    lastUserId: \$lastUserId
  ) {
    total
    list {
      id
      roll
      ldapName
      program
      department
    }
  }
}
  """;
  String getSuperUsers = """
  query(\$take: Float!, \$lastUserId: String!, \$rolesFilter: [UserRole!]!){
  getSuperUsers(take: \$take, LastUserId: \$lastUserId, RolesFilter: \$rolesFilter) {
    usersList {
      roll,
      name,
      role,
      id,
      isNewUser,
      photo,
      department,
    }
    total
  }
}

""";
  String getSuperUser = """
query GetSuperUser {
  getSuperUser {
    name
    id
  }
}
""";
  String getUser = """
    query(\$userId: String, \$roll: String) {
      getUser(userId: \$userId, roll: \$roll) {
        interests {
          title
          id
          category
        }
        name
        photo
        ldapName
        roll
        role
        isNewUser
        id
        mobile
        hostel {
          name
          id
        }
      }
    }
  """;
}
