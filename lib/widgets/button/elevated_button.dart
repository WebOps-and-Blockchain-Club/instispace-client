import 'package:flutter/material.dart';

import '../../themes.dart';

class CustomElevatedButton extends StatelessWidget {
  final Color? color;
  final IconData? leading;
  final IconData? trailing;
  final ButtonType type;
  final void Function()? onPressed;
  final String text;
  final bool isLoading;
  final double? textSize;
  final Color? textColor;
  final List<double>? padding;
  const CustomElevatedButton({
    Key? key,
    this.color,
    this.type = ButtonType.solid,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.textSize,
    this.padding,
    this.textColor,
    this.leading,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = color ?? ColorPalette.palette(context).secondary;
    final textColor = this.textColor ?? Colors.white;

    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            elevation: 3,
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(36),
                side: BorderSide(color: primaryColor))),
        child: Row(
          mainAxisAlignment: leading == null && trailing == null
              ? MainAxisAlignment.center
              : MainAxisAlignment.spaceBetween,
          children: [
            if (isLoading)
              const Padding(
                padding: EdgeInsets.only(right: 10),
                child: SizedBox(
                    width: 15,
                    height: 15,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2)),
              ),
            Padding(
              padding: padding != null
                  ? EdgeInsets.symmetric(
                      horizontal: padding![0], vertical: padding![1])
                  : const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
              child: Row(
                children: [
                  if (leading != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Icon(
                        leading,
                        size: 21,
                        color: textColor,
                      ),
                    ),
                  Text(
                    text,
                    style: TextStyle(
                        fontFamily: 'Proxima Nova',
                        color: type == ButtonType.outlined ? color : textColor,
                        fontSize: textSize ?? 17,
                        fontWeight: FontWeight.normal),
                  ),
                  if (trailing != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Icon(
                        trailing,
                        size: 21,
                        color: textColor,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ));
  }
}

enum ButtonType { solid, outlined }
