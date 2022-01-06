import 'package:flutter/material.dart';
import 'addpost.dart';
import 'home.dart';

void main() {
  runApp(MaterialApp(
    routes: {
      '/': (context) => EventsHome(),
      '/addpost': (context) => AddPostEvents(),
    },
  ));
}
