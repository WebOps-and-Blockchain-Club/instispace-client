import 'package:flutter/material.dart';

Widget Heading (String heading) {
  return Text(
    heading,
    style: const TextStyle(
        color: Color(0xFF5050ED),
        fontWeight: FontWeight.w600,
        fontSize: 22
    ),
  );
}