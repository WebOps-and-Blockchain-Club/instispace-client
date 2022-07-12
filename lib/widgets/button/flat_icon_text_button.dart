import 'package:flutter/material.dart';

class CustomFlatIconTextButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final void Function()? onPressed;
  const CustomFlatIconTextButton(
      {Key? key, required this.icon, required this.text, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF2f247b),
              size: 21,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: const TextStyle(color: Color(0xFF2f247b)),
            )
          ],
        ),
      ),
    );
  }
}
