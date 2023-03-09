import 'package:client/models/category.dart';

import '../tag.dart';
import './actions.dart';

class PostsModel {
  final List<PostModel> posts;
  final int total;

  PostsModel({required this.posts, required this.total});

  PostsModel.fromJson(dynamic data)
      : posts = (data["findPosts"]["list"] as List<dynamic>)
            .map((e) => PostModel.fromJson(e))
            .toList(),
        total = data["findPosts"]['total'];
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
  final List<String>? attachement;
  final TagsModel? tags;
  final LikeModel? like;
  final DisLikeModel? dislike;
  final SavePostModel? saved;
  final String? status;
  final LinkModel? link;
  final List<ReportModel>? reports;
  final String updatedAt;
  final String createdAt;
  final CreatedByModel createdBy;
  final List<String> permissions;

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
    this.attachement,
    this.status,
    this.link,
    this.reports,
    this.dislike,
    this.saved,
    required this.updatedAt,
    required this.createdAt,
    required this.createdBy,
    required this.permissions,
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
        comments = data['postComments'] != null
            ? CommentsModel.fromJson(
                data['postComments'], data['postComments'].length)
            : CommentsModel(comments: [], count: 0),
        photo = data['photo'] != '' && data['photo'] != null
            ? data['photo'].split(' AND ')
            : null,
        attachement = data['attachment'] != '' && data['attachment'] != null
            ? data['attachment'].split(' AND ')
            : null,
        reports = data['postReports']
            ?.map((e) => ReportModel.fromJson(e))
            .toList()
            .cast<ReportModel>(),
        updatedAt = data['updatedAt'],
        status = data['status'],
        link = data['Link'] != null && data['Link'] != ""
            ? LinkModel(
                name: data['linkName'] ?? 'Click Here!',
                link: (data['Link'] as String).trim())
            : null,
        createdAt = data['createdAt'],
        createdBy = CreatedByModel.fromJson(
          data['createdBy'],
        ),
        permissions =
            data['permissions'].cast<String>() + data['actions'].cast<String>();
}

class ReportModel {
  final String id;
  final String description;
  final CreatedByModel createdBy;
  final String createdAt;

  ReportModel({
    required this.id,
    required this.description,
    required this.createdBy,
    required this.createdAt,
  });

  ReportModel.fromJson(Map<String, dynamic> data)
      : id = data["id"],
        description = data["description"],
        createdBy = CreatedByModel.fromJson(data["createdBy"]),
        createdAt = data["createdAt"];
}
