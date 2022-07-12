import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final TextEditingController? controller;
  final String? labelText;
  final String? Function(String?)? validator;
  final int? minLines;
  final int? maxLines;
  final IconData? prefixIcon;
  final void Function()? onTap;
  final bool readOnly;
  const CustomTextFormField(
      {Key? key,
      this.padding = const EdgeInsets.only(top: 10),
      this.controller,
      this.labelText,
      this.validator,
      this.minLines,
      this.maxLines,
      this.prefixIcon,
      this.onTap,
      this.readOnly = false})
      : super(key: key);

  final InputBorder border = const OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF2f247b)),
      borderRadius: BorderRadius.all(Radius.circular(10)));
  final InputBorder errorBorder = const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
      borderRadius: BorderRadius.all(Radius.circular(10)));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextFormField(
        controller: controller,
        minLines: minLines,
        maxLines: maxLines,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            prefixIcon: prefixIcon != null
                ? Icon(
                    prefixIcon,
                    size: 20,
                    color: Colors.purple[200],
                  )
                : null,
            prefixIconConstraints: const BoxConstraints(
                maxWidth: 50, maxHeight: 25, minHeight: 25, minWidth: 35),
            contentPadding: const EdgeInsets.all(10),
            isDense: true,
            labelText: labelText,
            labelStyle: const TextStyle(color: Color(0xFF2f247b)),
            enabledBorder: border,
            focusedBorder: border,
            errorBorder: errorBorder,
            focusedErrorBorder: errorBorder,
            errorStyle: const TextStyle(color: Colors.red)),
        validator: validator,
        readOnly: readOnly,
        onTap: onTap,
      ),
    );
  }
}
