import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'actions.dart';
import 'comment.dart';
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
  final StarPostModel? star;
  final CTAModel? cta;
  final CommentsModel? comments;
  final CreatedByModel? createdBy;
  final String? createdAt;
  final List<String> permissions;

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
      this.star,
      this.cta,
      this.comments,
      this.createdBy,
      this.createdAt,
      required this.permissions});
}

class PostActions {
  final NavigateAction? edit;
  final PostAction? delete;
  final PostAction? like;
  final PostAction? star;
  final PostAction? report;
  final NavigateAction? comment;

  PostActions(
      {this.edit,
      this.delete,
      this.like,
      this.star,
      this.report,
      this.comment});
}

class PostAction {
  final String id;
  final String document;
  final FutureOr<void> Function(GraphQLDataProxy, QueryResult<Object?>)
      updateCache;

  PostAction({
    required this.id,
    required this.document,
    required this.updateCache,
  });
}

class NavigateAction {
  final Widget to;

  NavigateAction({required this.to});
}