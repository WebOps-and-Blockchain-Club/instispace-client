import 'package:flutter/material.dart';

class CustomIconTextButton extends StatelessWidget {
  final IconData? leading;
  final IconData? trailing;
  final Color? iconColor;
  final Color? textColor;
  final String text;
  final void Function()? onPressed;
  const CustomIconTextButton(
      {Key? key,
      this.leading,
      this.trailing,
      required this.text,
      this.onPressed,
      this.iconColor,
      this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = iconColor ?? Theme.of(context).primaryColor;
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
        child: Row(
          children: [
            Icon(
              leading,
              size: 21,
              color: color,
            ),
            const SizedBox(width: 10),
            Text(
              text,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Icon(trailing, size: 21, color: color),
          ],
        ),
      ),
    );
  }
}
