import 'package:client/models/post/create_post.dart';
import 'package:client/screens/home/chooseImages.dart';
import 'package:flutter/material.dart';

import '../../../models/post/actions.dart';
import '../newPost.dart';

Map<String, CreatePostModel> getCreatePostFields = {
  "Events": CreatePostModel(
    imagePrimary: FieldModel(required: false),
    title: FieldModel(),
    description: FieldModel(),
    link: FieldModel(required: false),
    tag: FieldModel(),
    location: FieldModel(required: false),
    postTime: FieldModel(required: false),
    endTime: FieldModel(),
  ),
  "Competition": CreatePostModel(
    imagePrimary: FieldModel(required: false),
    title: FieldModel(),
    description: FieldModel(),
    link: FieldModel(required: false),
    tag: FieldModel(),
    endTime: FieldModel(),
  ),
  "Recruitment": CreatePostModel(
    imagePrimary: FieldModel(required: false),
    title: FieldModel(),
    description: FieldModel(),
    link: FieldModel(required: false),
    tag: FieldModel(),
    endTime: FieldModel(),
  ),
  "Announcements": CreatePostModel(
    title: FieldModel(),
    description: FieldModel(),
    link: FieldModel(required: false),
    imageSecondary: FieldModel(required: false),
    tag: FieldModel(),
    endTime: FieldModel(),
  ),
  "Opportunities": CreatePostModel(
    title: FieldModel(),
    description: FieldModel(),
    link: FieldModel(required: false),
    imageSecondary: FieldModel(required: false),
    tag: FieldModel(),
    endTime: FieldModel(),
  ),
  "Connect": CreatePostModel(
    title: FieldModel(),
    description: FieldModel(),
    imageSecondary: FieldModel(required: false),
    tag: FieldModel(),
    endTime: FieldModel(),
  ),
  "Queries": CreatePostModel(
    title: FieldModel(),
    description: FieldModel(),
    imageSecondary: FieldModel(required: false),
    tag: FieldModel(),
    endTime: FieldModel(),
  ),
  "Help": CreatePostModel(
    title: FieldModel(),
    description: FieldModel(),
    imageSecondary: FieldModel(required: false),
    endTime: FieldModel(),
  ),
  "Review": CreatePostModel(
    title: FieldModel(),
    description: FieldModel(),
    imageSecondary: FieldModel(required: false),
    tag: FieldModel(),
    link: FieldModel(required: false),
    endTime: FieldModel(),
  ),
  "Random Thoughts": CreatePostModel(
    title: FieldModel(),
    description: FieldModel(),
    imageSecondary: FieldModel(required: false),
    tag: FieldModel(),
    endTime: FieldModel(),
  ),
};

class NewPostWrapper extends StatelessWidget {
  final PostCategoryModel category;
  const NewPostWrapper({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fieldConfiguration =
        getCreatePostFields[category.name] ?? getCreatePostFields["Events"]!;
    if (fieldConfiguration.imagePrimary != null) {
      return SelectImageScreen(
          category: category, fieldConfiguration: fieldConfiguration);
    }
    return NewPostScreen(
        category: category, fieldConfiguration: fieldConfiguration);
  }
}
