import 'post.dart';
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
  String photo;
  String? program;
  String? department;
  bool isNewUser;
  String? mobile;
  List<TagModel>? interets;
  String? hostelName;
  String? hostelId;
  // List<AnnouncementModel>? announcements;
  // List<EventModel>? events;
  // List<NetopModel>? netops;
  List<String?> permissions;
  List<PostModel>? posts;

  UserModel(
      {this.id,
      this.name,
      this.ldapName,
      this.roll,
      required this.role,
      required this.photo,
      required this.isNewUser,
      this.program,
      this.department,
      this.mobile,
      this.interets,
      this.hostelName,
      this.posts,
      required this.permissions});

  UserModel.fromJson(Map<String, dynamic> data)
      : id = data["id"],
        name = data["name"],
        ldapName = data["ldapName"] ?? "",
        roll = data["roll"],
        role = data["role"],
        photo = data["photo"],
        isNewUser = data["isNewUser"],
        // program = data["program"],
        // department = data["department"],
        mobile = data["mobile"],
        interets = TagsModel.fromJson(data["interests"] ?? []).tags,
        hostelName = data["hostel"] != null ? data["hostel"]["name"] : null,
        hostelId = data["hostel"] != null ? data["hostel"]["id"] : null,
        posts = data["post"] ??
            [
              PostModel(
                  id: "id",
                  title: "title",
                  description: "description",
                  permissions: ["USER", "ADMIN"])
            ],
        // announcements =
        //     data["getHome"] != null && data["getHome"]["announcements"] != null
        //         ? AnnouncementsModel.fromJson(data["getHome"]["announcements"])
        //             .announcements
        //         : null,
        // events = data["getHome"] != null && data["getHome"]["events"] != null
        //     ? EventsModel.fromJson(data["getHome"]["events"]).events
        //     : null,
        // netops = data["getHome"] != null && data["getHome"]["netops"] != null
        //     ? NetopsModel.fromJson(data["getHome"]["netops"]).netops
        //     : null,
        permissions = data["permission"]["account"] != null
            ? data["permission"]["account"].cast<String>()
            : [];

  List<HomeModel> toHomeModel() {
    List<HomeModel> home = [];
    if (posts != null && posts!.isNotEmpty) {
      home.add(HomeModel(
          title: "Networking & Opportunities",
          posts: posts ??
              [
                PostModel(
                    id: "id",
                    title: "title",
                    description: "description",
                    permissions: ["USER", "ADMIN"]),
              ]));
    }
    return home;
  }
}

class HomeModel {
  final String title;
  final List<PostModel> posts;

  HomeModel({required this.title, required this.posts});
}

class CreatedByModel {
  final String id;
  final String name;
  final String? roll;
  final String? role;

  CreatedByModel({required this.id, required this.name, this.roll, this.role});

  CreatedByModel.fromJson(Map<String, dynamic> data)
      : id = data["id"],
        name = data["name"],
        roll = data["roll"],
        role = data["role"];

  Map<String, dynamic> toJson() {
    return {
      "__typename": "User",
      "id": id,
      "name": name,
      "roll": roll,
      "role": role,
    };
  }
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
