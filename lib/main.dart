import 'package:client/screens/Events/addpost.dart';
import 'package:flutter/material.dart';

import 'screens/home/main.dart';
import 'screens/Events/home.dart';
import 'screens/Login/signUp.dart';

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
        '/events': (context) => Home(),
        '/signUp': (context) => SignUp(),
      },
    );
  }
}
