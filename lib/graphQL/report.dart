class ReportGQL {
  String get = """
    query {
      getReports {
        netops {
          id
          content
          commentCount
          comments {
            content
            id
            images
            createdBy {
              name
              id
              roll
            }
            createdAt
          }
          createdBy {
            id
            name
            roll
          }
          linkName
          linkToAction
          title
          isLiked
          isStared
          isHidden
          endTime
          createdAt
          permissions
          tags {
            category
            title
            id
          }
          likeCount
          photo
          attachments
          status
          reports {
            description
            id
            createdBy {
              name
              id
              roll
            }
            createdAt
          }
        }
        queries {
          id
          createdAt
          title
          content
          photo
          attachments
          likeCount
          isHidden
          permissions
          isLiked
          commentCount
          status
          createdBy {
            id
            roll
            name
          }
          comments {
            id
            content
            images
            createdAt
            createdBy {
              id
              roll
              name
            }
          }
          reports {
            description
            id
            createdBy {
              name
              id
              roll
            }
            createdAt
          }
        }
      }
    }
  """;

  static const resolveNetopReport = """
    mutation ResolveNetopReport(\$status: String!, \$id: String!){
      resolveNetopReport(status: \$status, id: \$id)
    }
  """;

  static const resolveMyQueryReport = """
    mutation ResolveMyQueryReport(\$status: String!, \$id: String!){
      resolveMyQueryReport(status: \$status, id: \$id)
    }
  """;

  String updateStatusFragment = """
    fragment reportStatusField on Report {
      id
      status
    }
  """;

  static const getReportReasons = """
    query GetReportReasons {
      getReportReasons {
        reason
      }
    }
  """;
}
