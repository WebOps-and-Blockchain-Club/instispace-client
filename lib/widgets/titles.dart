import 'package:flutter/material.dart';

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