import 'package:client/models/tag.dart';

class eventsClass {
  String title;
  List<Tag> tags;
  String id;
  // String location;
  bool isStared;

  eventsClass({required this.title,
    required this.tags,
    required this.id,
    required this.isStared,
  });
}