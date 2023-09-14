import 'user.dart';

class CommentsModel {
  final List<CommentModel> comments;
  final int count;

  CommentsModel({required this.comments, required this.count});

  CommentsModel.fromJson(List<dynamic> commentsList, this.count)
      : comments = commentsList.map((e) => CommentModel.fromJson(e)).toList();
}

class CommentModel {
  final String id;
  final String content;
  final int likeCount;
  final List<String>? images;
  final String createdAt;
  final CreatedByModel createdBy;

  CommentModel(
      {required this.id,
      required this.content,
      required this.createdAt,
      this.images,
      required this.likeCount,
      required this.createdBy});

  CommentModel.fromJson(Map<String, dynamic> data)
      : id = data["id"],
        content = data["content"],
        likeCount = data["likeCount"],
        images = [''],
        createdBy = CreatedByModel.fromJson(data["createdBy"]),
        createdAt = data["createdAt"];
}
