import 'package:graphql_flutter/graphql_flutter.dart';

import 'post.dart';
import 'hostel.dart';
import 'actions.dart';
import 'date_time_format.dart';

class AnnouncementsModel {
  final List<AnnouncementModel> announcements;

  AnnouncementsModel({required this.announcements});

  AnnouncementsModel.fromJson(List<dynamic> data)
      : announcements = data.map((e) => AnnouncementModel.fromJson(e)).toList();

  List<PostModel> toPostsModel() {
    return announcements.map((e) => e.toPostModel()).toList();
  }
}

class AnnouncementModel {
  final String id;
  final String title;
  final String description;
  final List<String>? attachements;
  final String createdAt;
  final String createdByUserName;
  final List<HostelModel> hostels;
  final List<String> permissions;

  AnnouncementModel(
      {required this.id,
      required this.title,
      required this.description,
      this.attachements,
      required this.createdAt,
      required this.createdByUserName,
      required this.hostels,
      required this.permissions});

  AnnouncementModel.fromJson(Map<String, dynamic> data)
      : id = data["id"],
        title = data["title"],
        description = data["description"],
        attachements = data["images"]?.split(" AND "),
        createdAt = data["createdAt"],
        createdByUserName = data["user"]["name"],
        hostels = HostelsModel.fromJson(data["hostels"]).hostels,
        permissions = ["EDIT", "DELETE"];
  // permissions = data["permissions"];

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
