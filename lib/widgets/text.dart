import 'package:flutter/material.dart';

Widget PageTitle(String text, BuildContext context) {
  return Container(
    decoration: const BoxDecoration(
      borderRadius:
      BorderRadius.vertical(bottom: Radius.circular(7)),
      // color: Color(0xFF5451FD),
      color: Colors.white
    ),
    width: MediaQuery.of(context).size.width * 1,
    height: 45,
    child: Center(
      child: Text(
        text,
        style: TextStyle(
          // color: Colors.white,
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    ),
  );
}
