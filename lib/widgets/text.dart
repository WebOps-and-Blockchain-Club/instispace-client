import 'package:flutter/material.dart';

Widget PageTitle(String text, BuildContext context) {
  return Container(
    decoration: const BoxDecoration(
      color: Color(0xFF2B2E35),
      borderRadius:
      BorderRadius.vertical(bottom: Radius.circular(7)),
      // color: Color(0xFF5451FD),
      // color: Color(0xFFF7F7F7)
    ),
    width: MediaQuery.of(context).size.width * 1,
    height: 55,
    child: Center(
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          // color: Color(0xFF2C6671),
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    ),
  );
}
