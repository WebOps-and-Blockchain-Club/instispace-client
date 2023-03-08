import 'package:client/models/category.dart';
import 'package:client/models/post/create_post.dart';
import 'package:client/screens/home/new_post/chooseImages.dart';
import 'package:client/widgets/section/main.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../graphQL/feed.dart';

import '../../../widgets/form/warning_popup.dart';
import 'newPost.dart';

Map<String, CreatePostModel> getCreatePostFields = {
  "Event": CreatePostModel(
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
  "Announcement": CreatePostModel(
    title: FieldModel(),
    description: FieldModel(),
    link: FieldModel(required: false),
    imageSecondary: FieldModel(required: false, maxImgs: 8),
    tag: FieldModel(),
    endTime: FieldModel(),
  ),
  "Opportunity": CreatePostModel(
    title: FieldModel(),
    description: FieldModel(),
    link: FieldModel(required: false),
    imageSecondary: FieldModel(required: false),
    tag: FieldModel(),
    endTime: FieldModel(time: const Duration(days: 5)),
  ),
  "Connect": CreatePostModel(
    title: FieldModel(),
    description: FieldModel(),
    imageSecondary: FieldModel(required: false),
    tag: FieldModel(),
    endTime: FieldModel(time: const Duration(days: 5)),
  ),
  "Query": CreatePostModel(
    title: FieldModel(),
    description: FieldModel(),
    imageSecondary: FieldModel(required: false),
    tag: FieldModel(),
  ),
  "Help": CreatePostModel(
    title: FieldModel(),
    description: FieldModel(),
    imageSecondary: FieldModel(required: false),
    endTime: FieldModel(time: const Duration(days: 5)),
  ),
  "Review": CreatePostModel(
    title: FieldModel(),
    description: FieldModel(),
    imageSecondary: FieldModel(required: false),
    tag: FieldModel(),
    link: FieldModel(required: false),
    endTime: FieldModel(time: const Duration(days: 5)),
  ),
  "Random Thought": CreatePostModel(
    title: FieldModel(),
    description: FieldModel(),
    imageSecondary: FieldModel(required: false),
    tag: FieldModel(),
    endTime: FieldModel(time: const Duration(days: 5)),
  ),
  "Lost": CreatePostModel(
    title: FieldModel(),
    description: FieldModel(),
    postTime: FieldModel(required: false),
    imageSecondary: FieldModel(required: false),
    endTime: FieldModel(enableEdit: false, time: const Duration(days: 30)),
  ),
  "Found": CreatePostModel(
    title: FieldModel(),
    description: FieldModel(),
    postTime: FieldModel(required: false),
    imageSecondary: FieldModel(required: false),
    endTime: FieldModel(enableEdit: false, time: const Duration(days: 30)),
  ),
};

class NewPostWrapper extends StatefulWidget {
  final PostCategoryModel category;
  final QueryOptions options;
  const NewPostWrapper(
      {Key? key, required this.category, required this.options})
      : super(key: key);

  @override
  State<NewPostWrapper> createState() => _NewPostWrapperState();
}

class _NewPostWrapperState extends State<NewPostWrapper> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () => showWarningAlert(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final fieldConfiguration = getCreatePostFields[widget.category.name] ??
        getCreatePostFields["Event"]!;
    if (fieldConfiguration.imagePrimary != null) {
      return SelectImageScreen(
        category: widget.category,
        fieldConfiguration: fieldConfiguration,
        options: widget.options,
      );
    }
    return NewPostScreen(
      category: widget.category,
      fieldConfiguration: fieldConfiguration,
      options: widget.options,
    );
  }
}
