import '../../../models/hostel.dart';
import 'package:flutter/material.dart';

class HostelsDisplay extends StatelessWidget {
  final HostelsModel hostelsModel;
  final Function onDelete;
  final EdgeInsetsGeometry padding;
  const HostelsDisplay(
      {Key? key,
      required this.hostelsModel,
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
        children: List.generate(hostelsModel.hostels.length, (index) {
          return Chip(
            label: Text(hostelsModel.hostels[index].name),
            padding: const EdgeInsets.all(4),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            deleteIcon: const Icon(Icons.close, size: 20),
            onDeleted: () {
              hostelsModel.remove(hostelsModel.hostels[index]);
              onDelete(hostelsModel);
            },
          );
        }),
      ),
    );
  }
}
