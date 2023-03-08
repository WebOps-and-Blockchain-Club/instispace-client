import 'package:flutter/material.dart';

SliverAppBar secondaryAppBar({required String title}) {
  return SliverAppBar(
    centerTitle: true,
    title: Text(
      title,
      style: const TextStyle(
          letterSpacing: 2.64,
          color: Color(0xFF3C3C3C),
          fontSize: 24,
          fontWeight: FontWeight.w700),
    ),
  );
}
