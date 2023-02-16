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
      shape: CircleBorder(),
      color: Colors.transparent,
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.all(0),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          width: size * 10,
          padding: EdgeInsets.all(size * 1.75),
          child: Icon(icon, size: size * 6.5),
        ),
      ),
    );
  }
}
