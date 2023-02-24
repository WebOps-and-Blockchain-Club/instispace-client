import 'package:client/models/post/create_post.dart';
import 'package:client/screens/home/new_post/chooseImages.dart';
import 'package:client/widgets/section/main.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../graphQL/feed.dart';
import '../../../models/post/actions.dart';
import 'newPost.dart';

Map<String, CreatePostModel> getCreatePostFields = {
  "Events": CreatePostModel(
    imagePrimary: FieldModel(required: false, maxImgs: 8),
    title: FieldModel(),
    description: FieldModel(),
    link: FieldModel(required: false),
    tag: FieldModel(),
    location: FieldModel(required: false),
    postTime: FieldModel(required: false),
    endTime: FieldModel(),
  ),
  "Competition": CreatePostModel(
    imagePrimary: FieldModel(required: false, maxImgs: 8),
    title: FieldModel(),
    description: FieldModel(),
    link: FieldModel(required: false),
    tag: FieldModel(),
    postTime: FieldModel(required: false),
    endTime: FieldModel(),
  ),
  "Recruitment": CreatePostModel(
    imagePrimary: FieldModel(required: false, maxImgs: 8),
    title: FieldModel(),
    description: FieldModel(),
    link: FieldModel(required: false),
    tag: FieldModel(),
    postTime: FieldModel(required: false),
    endTime: FieldModel(),
  ),
  "Announcements": CreatePostModel(
    title: FieldModel(),
    description: FieldModel(),
    link: FieldModel(required: false),
    imageSecondary: FieldModel(required: false, maxImgs: 8),
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
  "Lost": CreatePostModel(
    title: FieldModel(),
    description: FieldModel(),
    postTime: FieldModel(required: false),
    imageSecondary: FieldModel(required: false),
    endTime: FieldModel(enableEdit: false),
  ),
  "Found": CreatePostModel(
    title: FieldModel(),
    description: FieldModel(),
    postTime: FieldModel(required: false),
    imageSecondary: FieldModel(required: false),
    endTime: FieldModel(enableEdit: false),
  ),
};

class NewPostWrapper extends StatelessWidget {
  final PostCategoryModel category;
  final options;
  const NewPostWrapper({Key? key, required this.category, this.options})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fieldConfiguration =
        getCreatePostFields[category.name] ?? getCreatePostFields["Events"]!;
    if (fieldConfiguration.imagePrimary != null) {
      return SelectImageScreen(
        category: category,
        fieldConfiguration: fieldConfiguration,
        options: options,
      );
    }
    return NewPostScreen(
      category: category,
      fieldConfiguration: fieldConfiguration,
      options: options,
    );
  }
}
