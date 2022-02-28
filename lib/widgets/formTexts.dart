import 'package:flutter/material.dart';

Widget FormText (String formText) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
    child: Row(
      children: [
        Text(formText,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ],
    ),
  );
}