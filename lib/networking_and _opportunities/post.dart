import 'package:client/networking_and _opportunities/tag.dart';
import 'package:client/networking_and _opportunities/commentclass.dart';
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
