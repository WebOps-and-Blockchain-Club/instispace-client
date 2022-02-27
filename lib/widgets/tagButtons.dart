import 'package:flutter/material.dart';

import '../models/tag.dart';
import '../screens/tagPage.dart';

Widget TagButtons (Tag tag,BuildContext context) {
  return ElevatedButton(
    onPressed: () => {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => TagPage(tagId: tag.id)))
    },
    child: Text(
      tag.Tag_name,
      style: const TextStyle(
        color: Color(0xFF222222),
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    ),
    style: ElevatedButton.styleFrom(
      primary: const Color(0xFFFFFFFF),
      padding: const EdgeInsets.symmetric(
          vertical: 2,
          horizontal: 6),
      minimumSize: Size(35, 30)
    ),
  );
}