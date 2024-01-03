import 'package:flutter/material.dart';

SliverAppBar secondaryAppBar({required String title, required BuildContext context}) {
  return SliverAppBar(
    centerTitle: true,
    title: Text(
      title,
      style: TextStyle(
          letterSpacing: 1,
          color:  Theme.of(context).brightness == Brightness.dark  ? Colors.white : Color(0xFF3C3C3C),
          fontSize: 20,
          fontWeight: FontWeight.w700),
    ),
  );
}
