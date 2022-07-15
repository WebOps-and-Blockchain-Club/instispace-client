import 'package:flutter/material.dart';

import '../../../models/tag.dart';

class TagsDisplay extends StatelessWidget {
  final TagsModel tagsModel;
  final Function onDelete;
  final EdgeInsetsGeometry padding;
  const TagsDisplay(
      {Key? key,
      required this.tagsModel,
      required this.onDelete,
      this.padding = const EdgeInsets.only(top: 10)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Wrap(
        spacing: 5,
        runSpacing: 5,
        children: List.generate(tagsModel.tags.length, (index) {
          return Chip(
            label: Text(tagsModel.tags[index].title),
            padding: const EdgeInsets.all(4),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            deleteIcon: const Icon(Icons.close, size: 20),
            onDeleted: () {
              tagsModel.remove(tagsModel.tags[index]);
              onDelete(tagsModel);
            },
          );
        }),
      ),
    );
  }
}
