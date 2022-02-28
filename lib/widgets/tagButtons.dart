import 'package:client/screens/home/Announcements/edit_announcements.dart';
import 'package:flutter/material.dart';

import '../models/tag.dart';
import '../screens/tagPage.dart';

Widget TagButtons (Tag tag,BuildContext context) {
  return ElevatedButton(
    onPressed: () => {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => TagPage(tagId: tag.id,tagName: tag.Tag_name,)))
    },
    child: Padding(
      padding: EdgeInsets.fromLTRB(8,2,8,2),
      child: Text(
      tag.Tag_name,
      style: const TextStyle(
        color: Color(0xFF2B2E35),
        fontSize: 12.5,
        fontWeight: FontWeight.bold,
      ),
    ),
    ),
    style: ElevatedButton.styleFrom(
      primary: const Color(0xFFDFDFDF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
      ),
      // side: BorderSide(color: Color(0xFF2B2E35)),
      padding: const EdgeInsets.symmetric(
          vertical: 2,
          horizontal: 6),
      minimumSize: Size(35, 30)
    ),
  );
}