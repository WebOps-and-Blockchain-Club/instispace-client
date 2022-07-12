import 'package:client/models/tag.dart';
import 'package:flutter/material.dart';

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
            backgroundColor: Colors.white,
            padding: const EdgeInsets.all(4),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            deleteIcon:
                const Icon(Icons.close, size: 20, color: Color(0xFF2f247b)),
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
