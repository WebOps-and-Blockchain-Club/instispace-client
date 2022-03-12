import 'package:flutter/material.dart';

///Widget for Texts in forms above TextFormFields
Widget FormText (String formText) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(15, 5, 7, 0),
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