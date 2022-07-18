class ReportGQL {
  String get = """
    query {
      getReports {
        netop {
          id
          createdAt
          title
          content
          photo
          attachments
          endTime
          likeCount
          isLiked
          attachments
          isStared
          createdBy {
            id
            name
            roll
          }
          tags {
            id
            title
            category
          }
          linkName
          linkToAction
        }
        query {
          id
          createdAt
          title
          content
          photo
          attachments
          likeCount
          isLiked
          createdBy {
            name
            roll
            id
          }
        }
        description
        id
        status
        createdBy {
          name
          id
          roll
        }
        createdAt
      }
    }
  """;

  String resolveReport = """
    mutation(\$status: String!, \$resolveReportId: String!){
      resolveReport(status: \$status, id: \$resolveReportId)
    }
  """;

  String updateStatusFragment = """
    fragment fields on Report {
      id
      status
    }
  """;
}

class Report {
  String getReports = """
  query{
  getReports {
    netop{
      id
      createdAt
      title
      content
      photo
      attachments
      endTime
      createdBy {
        name
        roll
      }
      tags {
        id
        title
        category
      }
      linkName
      linkToAction
    }
    query {
      id
      createdAt
      title
      content
      photo
      attachments
      createdBy {
        name
        roll
        id
      }
    }
    description
    id
    createdBy{
    name
    id
    roll
    }
  }
}
  """;

  String resolveReportMyQuery = """
  mutation(\$queryId: String!){
 resolveReportMyQuery(MyQueryId: \$queryId)
}
  """;

  String resolveReportNetop = """
  mutation(\$netopId: String!){
  resolveReportNetop(NetopId: \$netopId)
}
  """;
}
