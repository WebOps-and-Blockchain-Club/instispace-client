import 'comment.dart';
import 'user.dart';
import 'post.dart';
import 'tag.dart';
import 'actions.dart';

class NetopsModel {
  final List<NetopModel> netops;

  NetopsModel({required this.netops});

  NetopsModel.fromJson(List<dynamic> data)
      : netops = data.map((e) => NetopModel.fromJson(e)).toList();

  List<PostModel> toPostsModel() {
    return netops.map((e) => e.toPostModel()).toList();
  }
}

class NetopModel {
  final String id;
  final String title;
  final String description;
  final List<String>? images;
  final String endTime;
  final TagsModel tags;
  final LikePostModel like;
  final StarPostModel star;
  final CTAModel? cta;
  final List<String> permissions;
  final CommentsModel comments;
  final String createdAt;
  final CreatedByModel createdBy;

  NetopModel(
      {required this.id,
      required this.title,
      required this.description,
      this.images,
      required this.endTime,
      required this.tags,
      required this.like,
      required this.star,
      this.cta,
      required this.comments,
      required this.createdAt,
      required this.createdBy,
      required this.permissions});

  NetopModel.fromJson(Map<String, dynamic> data)
      : id = data["id"],
        title = data["title"],
        description = data["content"],
        images = mergeAttachments(data["photo"], data["attachments"]),
        endTime = data["endTime"],
        tags = TagsModel.fromJson(data["tags"]),
        like = LikePostModel(
            count: data["likeCount"], isLikedByUser: data["isLiked"]),
        star = StarPostModel(isStarredByUser: data["isStared"]),
        cta = data["linkToAction"] != null && data["linkToAction"] != ""
            ? CTAModel(
                name: data["linkName"] ?? "Click me",
                link: data["linkToAction"])
            : null,
        comments = CommentsModel.fromJson(
            data["comments"] ?? [], data["commentCount"]),
        permissions = data["permissions"].cast<String>(),
        createdBy = CreatedByModel.fromJson(data["createdBy"]),
        createdAt = data["createdAt"];

  Map<String, dynamic> toJson() {
    return {
      "__typename": "Netop",
      "id": id,
      "title": title,
      "content": description,
      "photo": images,
      "endTime": endTime,
      "tags": tags.toJson(),
      "likeCount": like.count,
      "isLiked": like.isLikedByUser,
      "isStared": star.isStarredByUser,
      "linkName": cta?.name,
      "linkToAction": cta?.link,
      "createdAt": createdAt,
      "createdBy": createdBy.toJson()
    };
  }

  PostModel toPostModel() {
    return PostModel(
        id: id,
        title: title,
        description: description,
        imageUrls: images,
        like: like,
        star: star,
        cta: cta,
        endTime: endTime,
        tags: tags,
        comments: comments,
        createdBy: createdBy,
        createdAt: createdAt,
        permissions: permissions + ["SET_REMINDER", "SHARE", "LIKE", "STAR"]);
  }
}

class EditNetopModel {
  final String id;
  final String title;
  final String description;
  final List<String>? imageUrls;
  final String endTime;
  final TagsModel tags;
  final CTAModel? cta;

  EditNetopModel(
      {required this.id,
      required this.title,
      required this.description,
      this.imageUrls,
      required this.endTime,
      required this.tags,
      this.cta});
}

List<String>? mergeAttachments(String? image, String? attachement) {
  List<String>? images = image?.split(" AND ");
  List<String>? attachements = attachement?.split(" AND ");
  if (attachements != null && attachements.isNotEmpty) {
    images?.addAll(attachements);
  }
  return images;
}
