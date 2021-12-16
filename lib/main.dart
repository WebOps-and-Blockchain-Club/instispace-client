import 'package:flutter/material.dart';

import 'screens/home/main.dart';
import 'package:client/networking_and _opportunities/post.dart';
import 'networking_and _opportunities/post_listing.dart';
import 'package:client/networking_and _opportunities/addpost.dart';
import 'package:client/networking_and _opportunities/singlepost.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Hostel App',
      theme: ThemeData(
        // This is the theme of application.

        primarySwatch: Colors.green,
      ),
      home: HomePage(),
      routes: {
        HomePage.routeName: (_) => const HomePage(),
        '/addpost_networking': (context)=>AddPost(),
        '/networking_postlisting':(context)=>Post_Listing(),
      },
    );
  }
}
