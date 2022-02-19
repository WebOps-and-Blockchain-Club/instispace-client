import 'package:flutter/material.dart';

Widget PageTitle(String text) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 4),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 22,
          color: Color(0xFF5050ED),
        ),
      ),
    ),
  );
}
