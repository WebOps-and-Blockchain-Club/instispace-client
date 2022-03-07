import 'package:flutter/material.dart';

Widget errorMessages(String errMessage) {
  if (errMessage != "") {
    return Container(
      margin: const EdgeInsets.only(left: 20, top:2),
      alignment: Alignment.topLeft,
      child: Text(
        errMessage,
        style: TextStyle(fontSize: 12, color: Colors.red[800]),
      ),
    );
  } else {
    return Container();
  }
}
