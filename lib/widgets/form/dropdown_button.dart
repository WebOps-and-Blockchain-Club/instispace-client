import 'package:flutter/material.dart';

import '../../themes.dart';

class CustomDropdownButton extends StatelessWidget {
  final String? value;
  final List<String>? items;
  final void Function(String?)? onChanged;
  final EdgeInsets padding;
  const CustomDropdownButton({
    Key? key,
    this.value,
    this.items,
    this.onChanged,
    this.padding = const EdgeInsets.only(top: 10),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: ColorPalette.palette(context).primary),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DropdownButton(
                value: value,
                items: items?.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                onChanged: onChanged,
                icon: const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Icon(Icons.keyboard_arrow_down)),
                iconEnabledColor: ColorPalette.palette(context).primary,
                underline: Container(),
                isExpanded: true,
              ))),
    );
  }
}
