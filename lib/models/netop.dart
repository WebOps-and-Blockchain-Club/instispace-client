import 'package:graphql_flutter/graphql_flutter.dart';

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
  final String? imageUrl;
  final String endTime;
  final TagsModel tags;
  final LikePostModel like;
  final StarPostModel star;
  final CTAModel? cta;
  final List<String> permissions;
  final List<String>? attachements;
  final String createdAt;
  final CreatedByModel createdBy;

  NetopModel(
      {required this.id,
      required this.title,
      required this.description,
      this.imageUrl,
      required this.endTime,
      required this.tags,
      required this.like,
      required this.star,
      required this.cta,
      this.attachements,
      required this.createdAt,
      required this.createdBy,
      required this.permissions});

  NetopModel.fromJson(Map<String, dynamic> data)
      : id = data["id"],
        title = data["title"],
        description = data["content"],
        imageUrl = mergeAttachments(data["photo"], data["attachments"])?.first,
        endTime = data["endTime"],
        tags = TagsModel.fromJson(data["tags"]),
        like = LikePostModel(
            fkPostId: data["id"],
            count: data["likeCount"],
            isLikedByUser: data["isLiked"],
            mutationDocument: ""),
        star = StarPostModel(
            fkPostId: data["id"],
            isStarredByUser: data["isStared"],
            mutationDocument: ""),
        cta = data["linkToAction"] != null && data["linkToAction"] != ""
            ? CTAModel(
                name: data["linkName"] ?? "Click me",
                link: data["linkToAction"])
            : null,
        attachements = mergeAttachments(data["photo"], data["attachments"])
            ?.skip(1)
            .toList(),
        // permissions =
        //     data["permissions"] != null && data["permissions"].isNotEmpty
        //         ? data["permissions"]
        //         : [],
        permissions = ["EDIT", "DELETE"],
        createdBy = CreatedByModel.fromJson(data["createdBy"]),
        createdAt = data["createdAt"];

  Map<String, dynamic> toJson() {
    return {
      "__typename": "Netop",
      "id": id,
      "title": title,
      "content": description,
      "photo": imageUrl,
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
        attachements: attachements,
        shareAllowed: false,
        setReminderAllowed: false,
        edit: permissions.contains("EDIT")
            ? (Future<QueryResult<Object?>?> Function()? refetch) => null
            : null,
        delete: permissions.contains("DELETE")
            ? DeletePostModel(fkPostId: id, mutationDocument: "")
            : null,
        createdBy: createdBy,
        createdAt: createdAt);
  }
}

List<String>? mergeAttachments(String? image, String? attachement) {
  List<String>? images = image?.split(" AND ");
  List<String>? attachements = attachement?.split(" AND ");
  if (attachements != null && attachements.isNotEmpty) {
    images?.addAll(attachements);
  }
  return images;
}
