import 'package:graphql_flutter/graphql_flutter.dart';

import 'post.dart';
import 'tag.dart';
import 'actions.dart';
import 'date_time_format.dart';

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
  final String createdByUserName;

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
      required this.createdByUserName,
      required this.permissions});

  NetopModel.fromJson(Map<String, dynamic> data)
      : id = data["id"],
        title = data["title"],
        description = data["content"],
        imageUrl = mergeAttachments(data["photo"], data["attachments"])?.first,
        endTime = data["time"],
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
        createdByUserName = data["createdBy"]["name"],
        createdAt = data["createdAt"];

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
        footer: "Posted by " +
            createdByUserName +
            ", " +
            DateTimeFormatModel.fromString(createdAt).toDiffString() +
            " ago");
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
