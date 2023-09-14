import 'package:client/models/category.dart';

import '../tag.dart';
import './actions.dart';

class PostsModel {
  final List<PostModel> posts;

  PostsModel({required this.posts});

  PostsModel.fromJson(List<dynamic> data)
      : posts = data.map((e) => PostModel.fromJson(e)).toList();
}

class PostModel {
  final String id;
  final String? title;
  final String? content;
  final PostCategoryModel category;
  final String? location;
  final String? eventTime;
  final String? endTime;
  final CommentsModel? comments;
  final List<String>? photo;
  final TagsModel? tags;
  final LikeModel? like;
  final DisLikeModel? dislike;
  final SavePostModel? saved;
  final String? status;
  final LinkModel? link;
  final String updatedAt;
  final String createdAt;
  final CreatedByModel createdBy;

  PostModel({
    this.title,
    required this.id,
    this.content,
    required this.category,
    this.like,
    this.comments,
    this.tags,
    this.location,
    this.eventTime,
    this.endTime,
    this.photo,
    this.status,
    this.link,
    this.dislike,
    this.saved,
    required this.updatedAt,
    required this.createdAt,
    required this.createdBy,
  });

  PostModel.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        title = data['title'],
        content = data['content'],
        location = data['location'],
        eventTime = data['postTime'],
        endTime = data['endTime'],
        category = PostCategoryModel.fromJson(data['category']),
        like =
            LikeModel(count: data['likeCount'], isLikedByUser: data['isLiked']),
        dislike = DisLikeModel(
            count: data['dislikeCount'], isDislikedByUser: data['isDisliked']),
        saved = SavePostModel(isSavedByUser: data['isSaved']),
        tags = data['tags'] != null ? TagsModel.fromJson(data['tags']) : null,
        comments = CommentsModel.fromJson(
            data['postComments'], data['postComments'].length),
        photo = data['photo'] != '' && data['photo'] != null
            ? data['photo'].split(' AND ')
            : null,
        updatedAt = data['updatedAt'],
        status = data['status'],
        link = LinkModel(name: "data['linkName']", link: "data['link']"),
        createdAt = data['createdAt'],
        createdBy = CreatedByModel.fromJson(data['createdBy']);
}
