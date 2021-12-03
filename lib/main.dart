import 'package:flutter/material.dart';

import 'screens/home/main.dart';

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
      },
    );
  }
}
