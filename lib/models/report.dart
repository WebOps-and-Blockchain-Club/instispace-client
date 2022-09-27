import 'post.dart';
import 'query.dart';
import 'user.dart';
import 'netop.dart';

class ReportsModel {
  final List<PostModel>? queries;
  final List<PostModel>? netops;

  ReportsModel({required this.queries, required this.netops});

  ReportsModel.fromJson(Map<String, dynamic> data)
      : queries = data["queries"] != null
            ? QueriesModel.fromJson(data["queries"]).toPostsModel()
            : null,
        netops = data["netops"] != null
            ? NetopsModel.fromJson(data["netops"]).toPostsModel()
            : null;
}

class ReportModel {
  final String id;
  final String description;
  final CreatedByModel createdBy;
  final String createdAt;

  ReportModel({
    required this.id,
    required this.description,
    required this.createdBy,
    required this.createdAt,
  });

  ReportModel.fromJson(Map<String, dynamic> data)
      : id = data["id"],
        description = data["description"],
        createdBy = CreatedByModel.fromJson(data["createdBy"]),
        createdAt = data["createdAt"];

  Map<String, dynamic> toJson() {
    return {
      "__typename": "Report",
      "id": id,
      "description": description,
      "createdAt": createdAt,
      "createdBy": createdBy.toJson()
    };
  }
}
