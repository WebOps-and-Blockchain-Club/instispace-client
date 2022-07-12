import 'package:flutter/widgets.dart';

class CTAModel {
  final String name;
  final String link;

  CTAModel({required this.name, required this.link});
}

class LikePostModel {
  final String fkPostId;
  final int count;
  final bool isLikedByUser;
  final String mutationDocument;

  LikePostModel(
      {required this.fkPostId,
      required this.count,
      required this.isLikedByUser,
      required this.mutationDocument});
}

class CommentPostModel {
  final String fkPostId;
  final int count;
  final Widget navigateTo;

  CommentPostModel(
      {required this.fkPostId, required this.count, required this.navigateTo});
}

class StarPostModel {
  final String fkPostId;
  final bool isStarredByUser;
  final String mutationDocument;

  StarPostModel(
      {required this.fkPostId,
      required this.isStarredByUser,
      required this.mutationDocument});
}

class DeletePostModel {
  final String fkPostId;
  final String mutationDocument;

  DeletePostModel({required this.fkPostId, required this.mutationDocument});
}

class ReportPostModel {
  final String fkPostId;
  final String mutationDocument;

  ReportPostModel({required this.fkPostId, required this.mutationDocument});
}
