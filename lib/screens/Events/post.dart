import 'package:client/models/tag.dart';

class Post {
  String title;
  String location;
  String description;
  List<String> imgUrl;
  String? linkToAction;
  String linkName;
  String id;
  String createdById;
  String time;
  int likeCount;
  List<Tag> tags;
  bool isStarred;
  bool isLiked;

  Post(
      {required this.title,
      required this.location,
      required this.description,
      required this.imgUrl,
      required this.linkToAction,
      required this.id,
      required this.time,
      required this.tags,
      required this.likeCount,
      required this.createdById,
      required this.isStarred,
      required this.isLiked,
      required this.linkName});
}
