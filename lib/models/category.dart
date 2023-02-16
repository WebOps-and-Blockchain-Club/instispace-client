import 'package:flutter/material.dart';
import '../../../utils/custom_icons.dart';

class PostCategoryModel {
  final String name;
  final IconData icon;

  PostCategoryModel({
    required this.name,
    required this.icon,
  });
}

List<PostCategoryModel> feedCategories = [
  PostCategoryModel(name: "Events", icon: CustomIcons.events),
  PostCategoryModel(name: "Competition", icon: CustomIcons.competition),
  PostCategoryModel(name: "Announcements", icon: CustomIcons.announcement),
  PostCategoryModel(name: "Recruitment", icon: CustomIcons.recruitment),
];
List<PostCategoryModel> forumCategories = [
  PostCategoryModel(name: "Opportunities", icon: CustomIcons.opportunities),
  PostCategoryModel(name: "Connect", icon: CustomIcons.connect),
  PostCategoryModel(name: "Queries", icon: CustomIcons.queries),
  PostCategoryModel(name: "Help", icon: CustomIcons.help),
  PostCategoryModel(name: "Random Thoughts", icon: CustomIcons.thoughts),
];
