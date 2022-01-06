import 'package:client/screens/Events/addpost.dart';
import 'package:client/screens/Events/post.dart';
import 'package:client/screens/Events/singlepost.dart';
import 'package:client/screens/Login/createSuperUsers.dart';
import 'package:client/screens/Login/createhostel.dart';
import 'package:flutter/material.dart';

import 'screens/home/main.dart';
import 'screens/Events/home.dart';
import 'screens/Login/signUp.dart';
import 'screens/Login/createSuperUsers.dart';
import 'screens/home/userpage.dart';
import 'screens/Login/updatepass.dart';
import 'screens/Events/post.dart';
import 'package:flutter/material.dart';

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
      home: const HomePage(),
      routes: {
        HomePage.routeName: (_) => const HomePage(),
        '/events': (context) => EventsHome(),
        '/addpost': (context) => AddPost(),
        '/signUp': (context) => SignUp(),
        '/createSuperUser': (context) => CreateSuperUsers(),
        '/userpage': (context) => UserPage(),
        '/updatepassword': (context) => UpdatePassword(),
        '/createhostel': (context) => CreateHostel(),
      },
    );
  }
}
