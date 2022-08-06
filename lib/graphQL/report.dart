class ReportGQL {
  String get = """
    query {
      getReports {
        description
        id
        status
        createdBy {
          name
          id
          roll
        }
        createdAt
        netop {
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
        }
        query {
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
        }
      }
    }
  """;

  String resolveReport = """
    mutation(\$status: String!, \$resolveReportId: String!){
      resolveReport(status: \$status, id: \$resolveReportId)
    }
  """;

  String updateStatusFragment = """
    fragment reportStatusField on Report {
      id
      status
    }
  """;
}
