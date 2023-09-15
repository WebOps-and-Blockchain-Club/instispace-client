class TeasureHuntGQL {
  static String createGroup = """
    mutation(\$groupData: CreateGroupInput!) {
      createGroup(GroupData: \$groupData) {
        id
        name
        code
      }
    }
  """;

  static String joinGroup = """
    mutation AddUserToGroup(\$maxMembers: Float!, \$numberOfGroup: Float!) {
      addUserToGroup(maxMembers: \$maxMembers, numberOfGroup: \$numberOfGroup) {
        group {
          id
        }
      }
    }
  """;

  static String leaveGroup = """
    mutation {
      leaveGroup
    }
  """;

  static String fetchGroup = """
    query {
      getGroup {
        group {
          id
          name
          code
          users {
            ldapName
            roll
            role
            photo
            programme
            department
            mobile
            isNewUser
            isFreshie
          }
        }
        questions {
          id
          description
          images
          submission {
            id
            description
            images
            createdAt
            submittedBy {
              id
              roll
              name
              role
            }
          }
        }
        startTime
        endTime
        minMembers
        maxMembers
      }
    }
  """;

  static String addSubmission = """
    mutation(\$questionId: String!, \$submissionData: CreateSubmissionInput!) {
      addSubmissions(QuestionId: \$questionId, SubmissionData: \$submissionData) {
        id
        description
        createdAt
        images
        submittedBy {
          id
          roll
          name
          role
        }
      }
    }
  """;

  static String editGroupName = """
    mutation NameGroup(\$groupName: String!) {
      nameGroup(groupName: \$groupName) {
        name
      }
    }
    """;

  static String removeSubmisison = """
      mutation RemoveSubmission(\$questionId: String!) {
        removeSubmission(QuestionId: \$questionId)
      }
    """;
}
