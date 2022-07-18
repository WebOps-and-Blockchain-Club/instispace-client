import 'package:graphql_flutter/graphql_flutter.dart';

import 'actions.dart';
import 'hostel.dart';
import 'tag.dart';
import 'user.dart';

class PostModel {
  final String id;
  final String title;
  final String? subTitle;
  final String description;
  final List<String>? imageUrls;
  final List<String>? attachements;
  final String? location;
  final String? time;
  final String? endTime;
  final TagsModel? tags;
  final HostelsModel? hostels;
  final LikePostModel? like;
  final CommentPostModel? comment;
  final StarPostModel? star;
  bool shareAllowed = false;
  bool setReminderAllowed = false;
  final CTAModel? cta;
  final ReportPostModel? report;
  final Function(Future<QueryResult<Object?>?> Function()?)? edit;
  final DeletePostModel? delete;
  final CreatedByModel createdBy;
  final String createdAt;

  PostModel(
      {required this.id,
      required this.title,
      this.subTitle,
      required this.description,
      this.imageUrls,
      this.attachements,
      this.location,
      this.time,
      this.endTime,
      this.tags,
      this.hostels,
      this.like,
      this.comment,
      this.star,
      required this.shareAllowed,
      required this.setReminderAllowed,
      this.cta,
      this.report,
      this.edit,
      this.delete,
      required this.createdBy,
      required this.createdAt});
}
