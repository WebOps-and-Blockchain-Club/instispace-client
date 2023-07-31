import 'package:flutter/material.dart';

import '../../themes.dart';

class CustomDropdownButton extends StatelessWidget {
  final String? value;
  final List<String>? items;
  final void Function(String?)? onChanged;
  final EdgeInsets padding;
  bool? isError;
  CustomDropdownButton({
    Key? key,
    this.isError,
    this.value,
    this.items,
    this.onChanged,
    this.padding = const EdgeInsets.only(top: 10),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color theme = isError != null && isError!
        ? ColorPalette.palette(context).error
        : ColorPalette.palette(context).primary;
    return Padding(
      padding: padding,
      child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1, color: theme),
            ),
          ),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DropdownButton(
                value: value,
                items: items?.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(items),
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
                icon: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: theme,
                    )),
                iconEnabledColor: ColorPalette.palette(context).primary,
                underline: Container(),
                isExpanded: true,
              ))),
    );
  }
}
