import 'package:graphql_flutter/graphql_flutter.dart';

import 'post.dart';
import 'actions.dart';
import 'tag.dart';
import 'user.dart';
import '../graphQL/events.dart';
import '../screens/home/events/new_event.dart';

class EventsModel {
  final List<EventModel> events;
  static String deleteMutationDocument = EventGQL().delete;

  EventsModel({required this.events});

  EventsModel.fromJson(List<dynamic> data)
      : events = data.map((e) => EventModel.fromJson(e)).toList();

  List<PostModel> toPostsModel() {
    return events.map((e) => e.toPostModel()).toList();
  }
}

class EventModel {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String location;
  final String time;
  final TagsModel tags;
  final LikePostModel like;
  final StarPostModel star;
  final CTAModel? cta;
  final List<String> permissions;
  final CreatedByModel createdBy;
  final String createdAt;

  EventModel(
      {required this.id,
      required this.title,
      required this.description,
      this.imageUrl,
      required this.location,
      required this.time,
      required this.tags,
      required this.like,
      required this.star,
      this.cta,
      required this.permissions,
      required this.createdBy,
      required this.createdAt});

  EventModel.fromJson(Map<String, dynamic> data)
      : id = data["id"],
        title = data["title"],
        description = data["content"],
        imageUrl = data["photo"]?.split(" AND ").first,
        location = data["location"],
        time = data["time"],
        tags = TagsModel.fromJson(data["tags"]),
        like = LikePostModel(
            fkPostId: data["id"],
            count: data["likeCount"],
            isLikedByUser: data["isLiked"],
            mutationDocument: EventGQL().toggleLike),
        star = StarPostModel(
            fkPostId: data["id"],
            isStarredByUser: data["isStared"],
            mutationDocument: EventGQL().toggleStar),
        cta = data["linkToAction"] != null && data["linkToAction"] != ""
            ? CTAModel(
                name: data["linkName"] ?? "Click me",
                link: data["linkToAction"])
            : null,
        // permissions =
        //     data["permissions"] != null && data["permissions"].isNotEmpty
        //         ? data["permissions"]
        //         : [],
        permissions = ["EDIT", "DELETE"],
        createdBy = CreatedByModel.fromJson(data["createdBy"]),
        createdAt = data["createdAt"];

  PostModel toPostModel() {
    return PostModel(
        id: id,
        title: title,
        description: description,
        imageUrls: imageUrl != null ? [imageUrl!].toList() : null,
        location: location,
        time: time,
        tags: tags,
        like: like,
        star: star,
        shareAllowed: true,
        setReminderAllowed: true,
        cta: cta,
        edit: permissions.contains("EDIT")
            ? (Future<QueryResult<Object?>?> Function()? refetch) => NewEvent(
                  refetch: refetch,
                  event: EditEventModel(
                      id: id,
                      title: title,
                      description: description,
                      location: location,
                      time: time,
                      tags: tags),
                )
            : null,
        delete: permissions.contains("DELETE")
            ? DeletePostModel(fkPostId: id, mutationDocument: EventGQL().delete)
            : null,
        createdBy: createdBy,
        createdAt: createdAt);
  }
}

class EditEventModel {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String location;
  final String time;
  final TagsModel tags;
  final CTAModel? cta;

  EditEventModel(
      {required this.id,
      required this.title,
      required this.description,
      this.imageUrl,
      required this.location,
      required this.time,
      required this.tags,
      this.cta});
}
