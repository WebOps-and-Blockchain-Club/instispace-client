import 'package:flutter/material.dart';

import '../../themes.dart';

class CustomElevatedButton extends StatelessWidget {
  final MaterialColor? color;
  final ButtonType type;
  final void Function()? onPressed;
  final String text;
  final bool isLoading;
  const CustomElevatedButton(
      {Key? key,
      this.color,
      this.type = ButtonType.solid,
      required this.onPressed,
      required this.text,
      this.isLoading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MaterialColor primaryColor =
        color ?? ColorPalette.palette(context).success;
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            elevation: 5,
            primary:
                type == ButtonType.outlined ? primaryColor[50] : primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
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
            Text(
              text,
              style: TextStyle(
                  color: type == ButtonType.outlined ? color : Colors.white),
            ),
          ],
        ));
  }
}

enum ButtonType { solid, outlined }
