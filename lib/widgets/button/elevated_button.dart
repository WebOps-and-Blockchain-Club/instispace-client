import 'package:flutter/material.dart';

import '../../themes.dart';

class CustomElevatedButton extends StatelessWidget {
  final Color? color;
  final ButtonType type;
  final void Function()? onPressed;
  final String text;
  final bool isLoading;
  final double? textSize;
  final Color? textColor;
  final List<double>? padding;
  const CustomElevatedButton(
      {Key? key,
      this.color,
      this.type = ButtonType.solid,
      required this.onPressed,
      required this.text,
      this.isLoading = false,
      this.textSize,
      this.padding,
      this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = color ?? ColorPalette.palette(context).secondary;
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            elevation: 3,
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(36),
                side: BorderSide(color: primaryColor))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
                  : const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              child: Text(
                text,
                style: TextStyle(
                    fontFamily: 'Proxima Nova',
                    color: type == ButtonType.outlined
                        ? color
                        : textColor ?? Colors.white,
                    fontSize: textSize ?? 17,
                    fontWeight: FontWeight.normal),
              ),
            ),
          ],
        ));
  }
}

enum ButtonType { solid, outlined }
