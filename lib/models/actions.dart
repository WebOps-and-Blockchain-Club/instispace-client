import 'package:flutter/widgets.dart';

class CTAModel {
  final String name;
  final String link;

  CTAModel({required this.name, required this.link});
}

class LikePostModel {
  final int count;
  final bool isLikedByUser;

  LikePostModel({required this.count, required this.isLikedByUser});
}

class CommentPostModel {
  final String fkPostId;
  final int count;
  final Widget navigateTo;

  CommentPostModel(
      {required this.fkPostId, required this.count, required this.navigateTo});
}

class StarPostModel {
  final bool isStarredByUser;

  StarPostModel({required this.isStarredByUser});
}
