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
    mutation(\$groupCode: String!){
      joinGroup(GroupCode: \$groupCode)
    }
  """;

  static String leaveGroup = """
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
            program
            department
            mobile
            isNewUser
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
      }
    }
  """;

  static String addSubmission = """
    mutation(\$questionId: String!, \$submissionData: CreateSubmissionInput!) {
      addSubmission(QuestionId: \$questionId, SubmissionData: \$submissionData) {
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
}
