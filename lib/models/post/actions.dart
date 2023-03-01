import 'package:flutter/material.dart';

import '../../utils/custom_icons.dart';

class LinkModel {
  final String name;
  final String link;

  LinkModel({required this.name, required this.link});
}

class LikeModel {
  final int count;
  final bool isLikedByUser;

  LikeModel({required this.count, required this.isLikedByUser});
}

class DisLikeModel {
  final int count;
  final bool isDislikedByUser;

  DisLikeModel({required this.count, required this.isDislikedByUser});
}

class CommentsModel {
  final List<CommentModel> comments;
  final int count;

  CommentsModel({required this.comments, required this.count});

  CommentsModel.fromJson(List<dynamic> commentsList, this.count)
      : comments = commentsList.map((e) => CommentModel.fromJson(e)).toList();

  List<CommentModel> sort(
    String? on,
    int? count,
  ) {
    if (on == "LIKE_COUNT") {
      comments.sort((a, b) => a.likeCount.compareTo(b.likeCount));
    } else if (on == "CREATED_AT") {
      comments.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    }
    return comments.sublist(0, count ?? 2);
  }
}

class CommentModel {
  final String id;
  final String content;
  final int likeCount;
  final List<String>? images;
  final String createdAt;
  final CreatedByModel createdBy;

  CommentModel(
      {required this.id,
      required this.content,
      required this.createdAt,
      this.images,
      required this.likeCount,
      required this.createdBy});

  CommentModel.fromJson(Map<String, dynamic> data)
      : id = data["id"],
        content = data["content"],
        likeCount = data["likeCount"],
        images = [''],
        createdBy = CreatedByModel.fromJson(data["createdBy"]),
        createdAt = data["createdAt"];
}

class SavePostModel {
  final bool isSavedByUser;

  SavePostModel({required this.isSavedByUser});
}

class CreatedByModel {
  final String id;
  final String name;
  final String? roll;
  final String? role;
  final String photo;

  CreatedByModel(
      {required this.id,
      required this.name,
      this.roll,
      this.role,
      required this.photo});

  CreatedByModel.fromJson(Map<String, dynamic> data)
      : id = data["id"],
        name = data["name"],
        roll = data["roll"],
        role = data["role"],
        photo = data["photo"] != ""
            ? data['photo']
            : data['roll'] == 'cfi@smail.iitm.ac.in'
                ? "https://media.licdn.com/dms/image/C4D0BAQGEK-WB5mNx4g/company-logo_200_200/0/1519911884159?e=2147483647&v=beta&t=4Tsb5Gx2LoQXmCk_wN1jqdCGX5qAY8ejRpFMgcTpSHE"
                : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ835BghQCqBsROIiDKH37nh68eOOCCsiq1WGGrYG8Cfw&s';
}

class PostCategoryModel {
  final String name;
  final IconData icon;

  PostCategoryModel({
    required this.name,
    required this.icon,
  });

  PostCategoryModel.fromJson(String data)
      : name = data,
        icon = getIcon[data] == null ? Icons.local_activity : getIcon[data]!;

  static Map<String, IconData> getIcon = {
    "Event": CustomIcons.events,
    "Competition": CustomIcons.competition,
    "Announcement": CustomIcons.announcement,
    "Recruitment": CustomIcons.recruitment,
    "Opportunity": CustomIcons.opportunities,
    "Connect": CustomIcons.connect,
    "Query": CustomIcons.queries,
    "Help": CustomIcons.help,
    "Review": CustomIcons.help,
    "Random Thought": CustomIcons.thoughts,
    "Lost": CustomIcons.lost,
    "Found": CustomIcons.found
  };
}

List<PostCategoryModel> feedCategories = [
  PostCategoryModel(name: "Event", icon: CustomIcons.events),
  PostCategoryModel(name: "Competition", icon: CustomIcons.competition),
  PostCategoryModel(name: "Announcement", icon: CustomIcons.announcement),
  PostCategoryModel(name: "Recruitment", icon: CustomIcons.recruitment),
];
List<PostCategoryModel> forumCategories = [
  PostCategoryModel(name: "Opportunity", icon: CustomIcons.opportunities),
  PostCategoryModel(name: "Query", icon: CustomIcons.queries),
  PostCategoryModel(name: "Connect", icon: CustomIcons.connect),
  PostCategoryModel(name: "Help", icon: CustomIcons.help),
  PostCategoryModel(name: "Review", icon: CustomIcons.help),
  PostCategoryModel(name: "Random Thought", icon: CustomIcons.thoughts),
];
List<PostCategoryModel> lnfCategories = [
  PostCategoryModel(name: "Lost", icon: CustomIcons.lost),
  PostCategoryModel(name: "Found", icon: CustomIcons.found),
];
