import 'report.dart';
import 'comment.dart';
import 'netop.dart';
import 'post.dart';
import 'user.dart';
import 'actions.dart';

class QueriesModel {
  final List<QueryModel> queries;

  QueriesModel({required this.queries});

  QueriesModel.fromJson(List<dynamic> data)
      : queries = data.map((e) => QueryModel.fromJson(e)).toList();

  List<PostModel> toPostsModel() {
    return queries.map((e) => e.toPostModel()).toList();
  }
}

class QueryModel {
  final String id;
  final String title;
  final String description;
  final List<String>? images;
  final String status;
  final LikePostModel like;
  final CommentsModel comments;
  final CreatedByModel createdBy;
  final String createdAt;
  final List<String> permissions;
  final List<ReportModel>? reports;

  QueryModel(
      {required this.id,
      required this.title,
      required this.description,
      this.images,
      required this.status,
      required this.like,
      required this.comments,
      required this.createdBy,
      required this.createdAt,
      required this.permissions,
      this.reports});

  QueryModel.fromJson(Map<String, dynamic> data)
      : id = data["id"],
        title = data["title"],
        description = data["content"],
        like = LikePostModel(
          count: data["likeCount"],
          isLikedByUser: data["isLiked"],
        ),
        images = mergeAttachments(data["photo"], data["attachments"]),
        status = data["status"],
        comments = CommentsModel.fromJson(
            data["comments"] ?? [], data["commentCount"]),
        createdBy = CreatedByModel.fromJson(data["createdBy"]),
        createdAt = data["createdAt"],
        permissions = data["permissions"].cast<String>() + ["LIKE", "SHARE"],
        // ignore: prefer_null_aware_operators
        reports = data["reports"] != null
            ? data["reports"]
                .map((e) => ReportModel.fromJson(e))
                .toList()
                .cast<ReportModel>()
            : null;

  Map<String, dynamic> toJson() {
    return {
      "__typename": "MyQuery",
      "id": id,
      "title": title,
      "content": description,
      "photo": images?.join(" AND "),
      "likeCount": like.count,
      "isLiked": like.isLikedByUser,
      "createdAt": createdAt,
      "createdBy": createdBy.toJson()
    };
  }

  PostModel toPostModel() {
    return PostModel(
        id: id,
        title: title,
        description: description,
        imageUrls: images,
        status: status,
        like: like,
        comments: comments,
        createdBy: createdBy,
        createdAt: createdAt,
        permissions: permissions,
        reports: reports);
  }
}

class EditQueryModel {
  final String id;
  final String title;
  final String description;
  final List<String>? images;

  EditQueryModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.images});
}
