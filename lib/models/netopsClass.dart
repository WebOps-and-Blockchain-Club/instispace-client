import 'package:client/models/tag.dart';
import 'package:client/models/commentclass.dart';

class NetOpPost {
  String title;
  String description;
  String? imgUrl;
  String? linkToAction;
  int likeCount;
  List<Tag> tags;
  List<Comment> comments;
  String endTime;
  String id;
  String? attachment;
  String createdByName;
  String? linkName;
  bool isStarred;
  bool isLiked;
  DateTime createdAt;
  String createdById;

  NetOpPost({required this.title,
  required this.description,
  required this.imgUrl,
  required this.likeCount,
  required this.linkToAction,
  required this.tags,
    required this.comments,
    required this.endTime,
    required this.createdByName,
    required this.id,
    required this.attachment,
    required this.linkName,
    required this.isStarred,
    required this.isLiked,
    required this.createdAt,
    required this.createdById
  });
}
