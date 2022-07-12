import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final int size;
  final void Function()? onPressed;
  const CustomIconButton(
      {Key? key, required this.icon, this.size = 4, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          width: size * 10,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          padding: EdgeInsets.all(size * 1.75),
          child: Icon(
            icon,
            color: const Color(0xFF2f247b),
            size: size * 6.5,
          ),
        ),
      ),
    );
  }
}
