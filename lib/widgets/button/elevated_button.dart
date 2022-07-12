import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final void Function()? onPressed;
  final String text;
  final bool isLoading;
  const CustomElevatedButton(
      {Key? key,
      this.backgroundColor = Colors.green,
      this.borderColor = Colors.green,
      this.textColor = Colors.white,
      required this.onPressed,
      required this.text,
      this.isLoading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            elevation: 5,
            primary: backgroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: borderColor))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: SizedBox(
                    width: 15,
                    height: 15,
                    child: CircularProgressIndicator(
                        color: textColor, strokeWidth: 2)),
              ),
            Text(
              text,
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }
}
