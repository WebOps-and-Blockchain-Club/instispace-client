import 'post.dart';
import 'query.dart';
import 'user.dart';
import 'netop.dart';

class ReportsModel {
  final List<ReportModel> report;

  ReportsModel({required this.report});

  ReportsModel.fromJson(List<dynamic> data)
      : report = data.map((e) => ReportModel.fromJson(e)).toList();
}

class ReportModel {
  final String id;
  final String description;
  final String status;
  final CreatedByModel createdBy;
  final String createdAt;
  final PostModel? netop;
  final PostModel? query;

  ReportModel(
      {required this.id,
      required this.description,
      required this.status,
      required this.createdBy,
      required this.createdAt,
      this.netop,
      this.query});

  ReportModel.fromJson(Map<String, dynamic> data)
      : id = data["id"],
        description = data["description"],
        status = data["status"] ?? "",
        createdBy = CreatedByModel.fromJson(data["createdBy"]),
        createdAt = data["createdAt"],
        netop = data["netop"] != null
            ? NetopModel.fromJson(data["netop"]).toPostModel()
            : null,
        query = data["query"] != null
            ? QueryModel.fromJson(data["query"]).toPostModel()
            : null;

  Map<String, dynamic> toJson() {
    return {
      "__typename": "Report",
      "id": id,
      "description": description,
      "status": status,
      "createdAt": createdAt,
      "createdBy": createdBy.toJson()
    };
  }
}
