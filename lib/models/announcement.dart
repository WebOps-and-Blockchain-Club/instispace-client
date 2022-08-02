import 'user.dart';
import 'post.dart';
import 'hostel.dart';

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
  final String endTime;
  final CreatedByModel createdBy;
  final List<HostelModel> hostels;
  final List<String> permissions;

  AnnouncementModel(
      {required this.id,
      required this.title,
      required this.description,
      this.attachements,
      required this.createdAt,
      required this.endTime,
      required this.createdBy,
      required this.hostels,
      required this.permissions});

  AnnouncementModel.fromJson(Map<String, dynamic> data)
      : id = data["id"],
        title = data["title"],
        description = data["description"],
        attachements = data["images"]?.split(" AND "),
        createdAt = data["createdAt"],
        endTime = data["endTime"],
        createdBy = CreatedByModel.fromJson(data["user"]),
        hostels = HostelsModel.fromJson(data["hostels"]).hostels,
        permissions = data["permissions"].cast<String>();

  PostModel toPostModel() {
    return PostModel(
        id: id,
        title: title,
        description: description,
        attachements: attachements,
        createdBy: createdBy,
        endTime: endTime,
        createdAt: createdAt,
        hostels: hostels,
        permissions: permissions);
  }
}
