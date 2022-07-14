import 'package:client/models/tag.dart';

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
      this.hostelId});

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
        hostelId = data["hostel"] != null ? data["hostel"]["id"] : null;

  void update(UserModelKeyEnum key, dynamic value) {
    key = value;
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

enum UserModelKeyEnum {
  id,
  name,
  ldap,
  roll,
  role,
  isNewUser,
  mobile,
  interets,
  hostel
}
