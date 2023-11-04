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
    "Event": CustomIcons.events,
    "Competition": CustomIcons.competition,
    "Announcement": CustomIcons.announcement,
    "Recruitment": CustomIcons.recruitment,
    "Opportunity": CustomIcons.opportunities,
    "Connect": CustomIcons.connect,
    "Query": CustomIcons.queries,
    "Help": CustomIcons.help,
    "Survey": CustomIcons.survey,
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
  PostCategoryModel(name: "Survey", icon: CustomIcons.survey),
  PostCategoryModel(name: "Random Thought", icon: CustomIcons.thoughts),
  // PostCategoryModel(name: "Academics", icon: CustomIcons.opportunities),
  // PostCategoryModel(name: "Study Resources", icon: CustomIcons.opportunities),
];
List<PostCategoryModel> mentalHealthCategories = [
  PostCategoryModel(name: "Help", icon: CustomIcons.thoughts),
];
List<PostCategoryModel> lnfCategories = [
  PostCategoryModel(name: "Lost", icon: CustomIcons.lost),
  PostCategoryModel(name: "Found", icon: CustomIcons.found),
];
