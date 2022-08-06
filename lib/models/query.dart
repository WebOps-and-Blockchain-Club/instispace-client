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
  final List<String>? attachements;
  final LikePostModel like;
  final CommentsModel comments;
  final CreatedByModel createdBy;
  final String createdAt;
  final List<String> permissions;

  QueryModel(
      {required this.id,
      required this.title,
      required this.description,
      this.attachements,
      required this.like,
      required this.comments,
      required this.createdBy,
      required this.createdAt,
      required this.permissions});

  QueryModel.fromJson(Map<String, dynamic> data)
      : id = data["id"],
        title = data["title"],
        description = data["content"],
        like = LikePostModel(
          count: data["likeCount"],
          isLikedByUser: data["isLiked"],
        ),
        attachements = mergeAttachments(data["photo"], data["attachments"]),
        comments = CommentsModel.fromJson(
            data["comments"] ?? [], data["commentCount"]),
        createdBy = CreatedByModel.fromJson(data["createdBy"]),
        createdAt = data["createdAt"],
        permissions = data["permissions"].cast<String>() + ["LIKE"];

  Map<String, dynamic> toJson() {
    return {
      "__typename": "MyQuery",
      "id": id,
      "title": title,
      "content": description,
      "photo": attachements?.join(" AND "),
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
        attachements: attachements,
        like: like,
        comments: comments,
        createdBy: createdBy,
        createdAt: createdAt,
        permissions: permissions);
  }
}

class EditQueryModel {
  final String id;
  final String title;
  final String description;

  EditQueryModel(
      {required this.id, required this.title, required this.description});
}
