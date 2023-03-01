import 'hostel.dart';
import 'post.dart';
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
  HostelModel? hostel;
  List<String?> permissions;
  PermissionModel? permission;

  UserModel({
    this.id,
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
    this.hostel,
    required this.permissions,
    this.permission,
  });

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
        hostel = data["hostel"] != null
            ? HostelModel.fromJson(data["hostel"])
            : null,
        permissions =
            data["permission"] != null && data["permission"]["account"] != null
                ? data["permission"]["account"].cast<String>()
                : [],
        permission = data["permission"] != null
            ? PermissionModel.fromJson(data["permission"])
            : null;
}

class PermissionModel {
  final bool createNotification;
  final bool createTag;
  final bool createHostel;
  final bool moderateReport;
  final bool approvePost;
  final bool viewFeeback;
  final CreateAccountPermissionModel createAccount;
  final CreatePostPermissionModel? createPost;

  PermissionModel(
      {required this.createNotification,
      required this.createTag,
      required this.createHostel,
      required this.moderateReport,
      required this.approvePost,
      required this.viewFeeback,
      required this.createAccount,
      required this.createPost});

  PermissionModel.fromJson(Map<String, dynamic> data)
      : createNotification = true,
        createTag = true,
        createHostel = true,
        moderateReport = true,
        approvePost = true,
        viewFeeback = true,
        createAccount = CreateAccountPermissionModel.fromJson(data['account']),
        createPost = null;
}

class CreateAccountPermissionModel {
  final bool hasPermission;
  final List<String>? allowedRoles;

  CreateAccountPermissionModel(
      {required this.hasPermission, this.allowedRoles});

  CreateAccountPermissionModel.fromJson(dynamic data)
      : hasPermission = true,
        // : hasPermission = data != null && data.cast<String>().length,
        allowedRoles = data != null ? data.cast<String>() : [];
}

class CreatePostPermissionModel {
  final bool hasPermission;
  final List<String>? allowedCategory;

  CreatePostPermissionModel(
      {required this.hasPermission, this.allowedCategory});
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
