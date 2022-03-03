import 'package:flutter/material.dart';

///Called in cards as titles
Widget SubHeading (String title) {
  return Text(
    title,
    style: const TextStyle(
      fontSize: 18,
      color: Colors.black,
      fontWeight: FontWeight.w600,
    ),
  );
}