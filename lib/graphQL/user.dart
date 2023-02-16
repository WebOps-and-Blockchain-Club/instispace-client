class UserGQL {
  String getMe = """
    query {
  getMe {
    photo
    accountsCreated {
      id
    }
    comment {
      id
    }
    createdBy {
      id
    }
    id
    interests {
      id
      category
    }
    isNewUser
    mobile
    name
    permission {
      account
      id
    }
    role
    roll
    savedPost {
      id
    }
    likedComment {
      id
    }
    likedPost {
      id
    }
    post {
      id
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
