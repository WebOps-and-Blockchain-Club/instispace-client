import 'package:flutter/material.dart';

import '../../themes.dart';

class CustomElevatedButton extends StatelessWidget {
  final MaterialColor? color;
  final ButtonType type;
  final void Function()? onPressed;
  final String text;
  final bool isLoading;
  final double? textSize;
  final List<double>? padding;
  const CustomElevatedButton(
      {Key? key,
      this.color,
      this.type = ButtonType.solid,
      required this.onPressed,
      required this.text,
      this.isLoading = false,
      this.textSize,
      this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MaterialColor primaryColor =
        color ?? ColorPalette.palette(context).secondary;
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            elevation: 3,
            backgroundColor:
                type == ButtonType.outlined ? primaryColor[50] : primaryColor,
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
                  ? EdgeInsets.fromLTRB(
                      padding![0], padding![1], padding![2], padding![3])
                  : EdgeInsets.fromLTRB(5, 2, 5, 2),
              child: Text(
                text,
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: type == ButtonType.outlined ? color : Colors.white,
                    fontSize: textSize ?? 17,
                    fontWeight: FontWeight.normal),
              ),
            ),
          ],
        ));
  }
}

enum ButtonType { solid, outlined }
