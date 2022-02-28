import 'package:flutter/material.dart';

Widget PageTitle(String text, BuildContext context) {
  return Container(
    decoration: const BoxDecoration(
      borderRadius:
      BorderRadius.vertical(bottom: Radius.circular(0)),
      // color: Color(0xFF5451FD),
      color: Color(0xFF2B2E35),
    ),
    width: MediaQuery.of(context).size.width * 1,
    height: 55,
    child: Center(
      child: Text(
        text,
        style: TextStyle(
          // color: Colors.white,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    ),
  );
}
