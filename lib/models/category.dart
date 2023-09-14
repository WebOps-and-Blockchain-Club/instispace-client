import 'package:flutter/material.dart';
import '../../../utils/custom_icons.dart';

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
    "Events": CustomIcons.events,
    "Competition": CustomIcons.competition,
    "Announcements": CustomIcons.announcement,
    "Recruitment": CustomIcons.recruitment,
    "Opportunities": CustomIcons.opportunities,
    "Connect": CustomIcons.connect,
    "Queries": CustomIcons.queries,
    "Help": CustomIcons.help,
    "Random Thoughts": CustomIcons.thoughts,
  };
}

List<PostCategoryModel> feedCategories = [
  PostCategoryModel(name: "Events", icon: CustomIcons.events),
  PostCategoryModel(name: "Competition", icon: CustomIcons.competition),
  PostCategoryModel(name: "Announcements", icon: CustomIcons.announcement),
  PostCategoryModel(name: "Recruitment", icon: CustomIcons.recruitment),
];
List<PostCategoryModel> forumCategories = [
  PostCategoryModel(name: "Opportunities", icon: CustomIcons.opportunities),
  PostCategoryModel(name: "Queries", icon: CustomIcons.queries),
  PostCategoryModel(name: "Connect", icon: CustomIcons.connect),
  PostCategoryModel(name: "Help", icon: CustomIcons.help),
  PostCategoryModel(name: "Random Thoughts", icon: CustomIcons.thoughts),
];
List<PostCategoryModel> lnfCategories = [
  PostCategoryModel(name: "Lost", icon: CustomIcons.lost),
  PostCategoryModel(name: "Found", icon: CustomIcons.found),
];
