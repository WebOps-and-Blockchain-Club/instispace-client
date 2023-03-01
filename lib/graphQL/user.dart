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
          approvePosts
          createTag
          handleReports
          account
        }
      }
    }
  """;

  String searchUser = """
    query(\$search: String!) {
      searchLDAPUser(search: \$search) {
        roll
        name
        department
        photo
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
  String getUser = """
    query(\$getUserInput: GetUserInput!) {
      getUser(GetUserInput: \$getUserInput) {
        interest {
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
