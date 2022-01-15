import 'package:client/models/tag.dart';
import 'package:client/models/commentclass.dart';
class Post {
  String title;
  String description;
  String imgUrl;
  String linktoaction;
  int like_counter;
  List<Tag> tags;
  List<Comment> comments;

  Post({required this.title,
  required this.description,
  required this.imgUrl,
  required this.like_counter,
  required this.linktoaction,
  required this.tags,
    required this.comments,
  });
}
