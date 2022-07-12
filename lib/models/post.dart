import 'package:client/models/actions.dart';
import 'package:client/models/tag.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class PostModel {
  final String id;
  final String title;
  final String? subTitle;
  final String description;
  final List<String>? imageUrls;
  final String? location;
  final String? time;
  final TagsModel? tags;
  final LikePostModel? like;
  final CommentPostModel? comment;
  final StarPostModel? star;
  bool shareAllowed = false;
  bool setReminderAllowed = false;
  final CTAModel? cta;
  final ReportPostModel? report;
  final Function(Future<QueryResult<Object?>?> Function()?)? edit;
  final DeletePostModel? delete;
  final String? footer;

  PostModel(
      {required this.id,
      required this.title,
      this.subTitle,
      required this.description,
      this.imageUrls,
      this.location,
      this.time,
      this.tags,
      this.like,
      this.comment,
      this.star,
      required this.shareAllowed,
      required this.setReminderAllowed,
      this.cta,
      this.report,
      this.edit,
      this.delete,
      this.footer});
}
