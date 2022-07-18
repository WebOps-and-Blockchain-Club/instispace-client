import 'post.dart';
import 'user.dart';
import 'actions.dart';

class QueriesModel {
  final List<QueryModel> queries;

  QueriesModel({required this.queries});

  QueriesModel.fromJson(List<Map<String, dynamic>> data)
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
  final CreatedByModel createdBy;
  final String createdAt;

  QueryModel(
      {required this.id,
      required this.title,
      required this.description,
      this.attachements,
      required this.like,
      required this.createdBy,
      required this.createdAt});

  QueryModel.fromJson(Map<String, dynamic> data)
      : id = data["id"],
        title = data["title"],
        description = data["content"],
        attachements = data["photo"]?.split(" AND ").toList(),
        like = LikePostModel(
            fkPostId: data["id"],
            count: data["likeCount"],
            isLikedByUser: data["isLiked"],
            // TODO: Add the like mutation document here
            mutationDocument: ""),
        createdBy = CreatedByModel.fromJson(data["createdBy"]),
        createdAt = data["createdAt"];

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
        shareAllowed: false,
        setReminderAllowed: false,
        like: like,
        createdBy: createdBy,
        createdAt: createdAt);
  }
}

class queryClass {
  String id;
  String title;
  List<String> imgUrl;
  String content;
  int likeCount;
  String createdByName;
  String createdByRoll;
  bool isLiked;
  String createdById;
  DateTime createdAt;
  int commentCount;

  queryClass(
      {required this.id,
      required this.title,
      required this.likeCount,
      required this.content,
      required this.createdByName,
      required this.createdByRoll,
      required this.imgUrl,
      required this.isLiked,
      required this.createdById,
      required this.createdAt,
      required this.commentCount});
}
