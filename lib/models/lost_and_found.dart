import '../utils/string_extension.dart';
import 'date_time_format.dart';
import 'post.dart';
import 'user.dart';

class LostAndFoundItemsModel {
  final List<LostAndFoundItemModel> items;

  LostAndFoundItemsModel({required this.items});

  LostAndFoundItemsModel.fromJson(List<dynamic> data)
      : items = data.map((e) => LostAndFoundItemModel.fromJson(e)).toList();

  List<PostModel> toPostsModel() {
    return items.map((e) => e.toPostModel()).toList();
  }
}

class LostAndFoundItemModel {
  final String id;
  final String name;
  final String category;
  final String location;
  final String time;
  final List<String>? images;
  final String? contact;
  final String createdAt;
  final CreatedByModel createdBy;
  final List<String> permissions;

  LostAndFoundItemModel(
      {required this.id,
      required this.name,
      required this.category,
      required this.location,
      required this.time,
      this.images,
      this.contact,
      required this.createdAt,
      required this.createdBy,
      required this.permissions});

  LostAndFoundItemModel.fromJson(Map<String, dynamic> data)
      : id = data["id"],
        name = data["name"],
        category = data["category"],
        location = data["location"],
        time = data["time"],
        images = data["images"]?.split(" AND "),
        contact = data["contact"],
        permissions = data["permissions"].cast<String>(),
        createdBy = CreatedByModel.fromJson(data["user"]),
        createdAt = data["createdAt"];

  PostModel toPostModel() {
    return PostModel(
        id: id,
        title: name,
        subTitle: category.toLowerCase().capitalize(),
        description: LnFDecription(
                location: location,
                time: time,
                contact: contact,
                category: category,
                email:
                    "${createdBy.roll!}${(createdBy.role == "USER" || createdBy.role == "MODERATOR") ? "@smail.iitm.ac.in" : ""}")
            .toDescriptionString(),
        lnFDescription: LnFDecription(
            location: location,
            time: time,
            contact: contact,
            category: category,
            email:
                "${createdBy.roll!}${(createdBy.role == "USER" || createdBy.role == "MODERATOR") ? "@smail.iitm.ac.in" : ""}"),
        imageUrls: images,
        permissions: permissions);
  }
}

class LnFEditModel {
  final String id;
  final String name;
  final String category;
  final String location;
  final String time;
  final List<String>? images;
  final String? contact;

  LnFEditModel(
      {required this.id,
      required this.name,
      required this.category,
      required this.location,
      required this.time,
      this.images,
      this.contact});
}

class LnFDecription {
  final String location;
  final String time;
  final String? contact;
  final String category;
  final String email;

  LnFDecription(
      {required this.location,
      required this.time,
      this.contact,
      required this.category,
      required this.email});

  String toDescriptionString() {
    return "At $location on ${DateTimeFormatModel.fromString(time).toFormat("E, MMM dd, yyyy, h:mm a")}. \nPlease contact me at ${contact ?? email} ${category == "LOST" ? "if you find" : "to claim"} the item.";
  }
}
