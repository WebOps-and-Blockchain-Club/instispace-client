import 'package:flutter/material.dart';

Widget errorMessages(String errMessage) {
  if (errMessage != "") {
    return Container(
      margin: EdgeInsets.only(left: 20, top: 7),
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
