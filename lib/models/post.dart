import 'package:client/models/tag.dart';
import 'package:client/models/commentclass.dart';

class NetOpPost {
  String title;
  String description;
  String? imgUrl;
  String linktoaction;
  int like_counter;
  List<Tag> tags;
  List<Comment> comments;
  String endTime;
  String id;
  // String attachment;

  NetOpPost({required this.title,
  required this.description,
  required this.imgUrl,
  required this.like_counter,
  required this.linktoaction,
  required this.tags,
    required this.comments,
    required this.endTime,
    required this.id,
    // required this.attachment,
  });
}
