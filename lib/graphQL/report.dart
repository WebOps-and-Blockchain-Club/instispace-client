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