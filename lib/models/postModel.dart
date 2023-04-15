import 'package:client/models/actions.dart';
import 'package:client/models/comment.dart';
import 'package:client/models/event_points.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'user.dart';
import 'tag.dart';
import 'user.dart';

class PostModel {
  final String? title;
  final String id;
  final String? content;
  final String category;
  final String? location;
  final CommentsModel? comments;
  final List<String>? photo;
  final List<String>? tags;
  final LikePostModel? like;
  final EventPointsModel? eventPoints;
  final bool? isDisliked;
  final bool? isSaved;
  final bool? isHidden;
  final String? updatedAt;
  final String? status;
  final String? linkName;
  final String? link;
  final String createdAt;
  final CreatedByModel createdBy;

  PostModel({
    this.title,
    required this.id,
    this.content,
    required this.category,
    this.like,
    this.eventPoints,
    this.comments,
    this.tags,
    this.location,
    this.photo,
    this.updatedAt,
    this.status,
    this.linkName,
    this.link,
    this.isDisliked,
    this.isHidden,
    this.isSaved,
    required this.createdAt,
    required this.createdBy,
  });

  PostModel.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        title = data['title'],
        content = data['content'],
        category = data['category'],
        location = data['location'],
        like = LikePostModel(
            count: data['likeCount'], isLikedByUser: data['isLiked']),
        eventPoints = (data['isQRActive']!=null)? EventPointsModel(isQRActive: data['isQRActive'], pointsValue: data['pointsValue']): null,
        isDisliked = data['isDisliked'],
        isHidden = data['isHidden'],
        isSaved = data['isSaved'],
        tags = data['tags'],
        comments = CommentsModel.fromJson(
            data['postComments'], data['postComments'].length),
        photo = data['photo'] != '' && data['photo'] != null
            ? data['photo'].split(' AND ')
            : null,
        updatedAt = data['updatedAt'],
        status = data['status'],
        link = data['link'],
        linkName = data['linkName'],
        createdAt = data['createdAt'],
        createdBy = CreatedByModel.fromJson(data['createdBy']);
}

class PostActions {
  final NavigateAction? edit;
  final PostAction? delete;
  final PostAction? like;
  final PostAction? star;
  final PostAction? report;
  final PostAction? resolve;
  final NavigateAction? comment;

  PostActions(
      {this.edit,
      this.delete,
      this.like,
      this.star,
      this.report,
      this.resolve,
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
