import 'package:client/models/tag.dart';

class NetOpPost {
  String title;
  String description;
  List<String> imgUrl;
  String? linkToAction;
  int likeCount;
  List<Tag> tags;
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
