import 'package:client/models/tag.dart';
import 'package:client/models/commentclass.dart';
import 'package:email_validator/email_validator.dart';
class Post {
  String title;
  String description;
  String imgUrl;
  String linktoaction;
  int like_counter;
  List<Tag> tags;
  List<Comment> comments;
  String endTime;
  String id;

  Post({required this.title,
  required this.description,
  required this.imgUrl,
  required this.like_counter,
  required this.linktoaction,
  required this.tags,
    required this.comments,
    required this.endTime,
    required this.id,
  });
}
