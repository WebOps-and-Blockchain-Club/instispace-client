import 'package:flutter/material.dart';

Widget Heading (String heading) {
  return Text(
    heading,
    style: const TextStyle(
        color: Color(0xFF222222),
        fontWeight: FontWeight.bold,
        fontSize: 22
    ),
  );
}