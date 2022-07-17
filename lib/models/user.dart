import 'package:client/models/post.dart';

import 'announcement.dart';
import 'event.dart';
import 'netop.dart';
import 'tag.dart';

class UserModel {
  String? id;
  String? name;
  String? ldapName;
  String? roll;
  String? role;
  bool isNewUser;
  String? mobile;
  List<TagModel>? interets;
  String? hostelName;
  String? hostelId;
  List<AnnouncementModel>? announcements;
  List<EventModel>? events;
  List<NetopModel>? netops;
  List<String> permissions;

  UserModel(
      {this.id,
      this.name,
      this.ldapName,
      this.roll,
      required this.role,
      required this.isNewUser,
      this.mobile,
      this.interets,
      this.hostelName,
      this.hostelId,
      this.announcements,
      this.events,
      this.netops,
      required this.permissions});

  UserModel.fromJson(Map<String, dynamic> data)
      : id = data["id"],
        name = data["name"],
        ldapName = data["ldapName"] ?? "",
        roll = data["roll"],
        role = data["role"],
        isNewUser = data["isNewUser"],
        mobile = data["mobile"],
        interets = TagsModel.fromJson(data["interest"] ?? []).tags,
        hostelName = data["hostel"] != null ? data["hostel"]["name"] : null,
        hostelId = data["hostel"] != null ? data["hostel"]["id"] : null,
        announcements =
            data["getHome"] != null && data["getHome"]["announcements"] != null
                ? AnnouncementsModel.fromJson(data["getHome"]["announcements"])
                    .announcements
                : null,
        events = data["getHome"] != null && data["getHome"]["events"] != null
            ? EventsModel.fromJson(data["getHome"]["events"]).events
            : null,
        netops = data["getHome"] != null && data["getHome"]["netops"] != null
            ? NetopsModel.fromJson(data["getHome"]["netops"]).netops
            : null,
        permissions = [
          "CREATE_ACCOUNT",
          "UPDATE_ROLE",
          "CREATE_TAG",
          "CREATE_HOSTEL",
          "VIEW_FEEDBACK",
          "GET_REPORTS"
        ];
  // permissions = data["permissions"];

  List<HomeModel> toHomeModel() {
    List<HomeModel> home = [];
    if (announcements != null && announcements!.isNotEmpty) {
      home.add(HomeModel(
          title: "Announcements",
          posts: announcements!.map((e) => e.toPostModel()).toList()));
    }
    if (events != null && events!.isNotEmpty) {
      home.add(HomeModel(
          title: "Events",
          posts: events!.map((e) => e.toPostModel()).toList()));
    }
    if (netops != null && netops!.isNotEmpty) {
      home.add(HomeModel(
          title: "Networking & Opportunities",
          posts: netops!.map((e) => e.toPostModel()).toList()));
    }
    return home;
  }
}

class HomeModel {
  final String title;
  final List<PostModel> posts;

  HomeModel({required this.title, required this.posts});
}

class User {
  String id;
  String name;
  String roll;
  String role;
  String hostelName;

  User(
      {required this.id,
      required this.name,
      required this.hostelName,
      required this.role,
      required this.roll});
}

// enum UserModelKeyEnum {
//   id,
//   name,
//   ldap,
//   roll,
//   role,
//   isNewUser,
//   mobile,
//   interets,
//   hostel
// }
