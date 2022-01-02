
import 'package:flutter/material.dart';
import 'package:client/screens/login/login.dart';
import 'package:client/screens/home/networking_and _opportunities/post_listing.dart';
import 'package:client/screens/home/networking_and _opportunities/addpost.dart';
import 'package:client/screens/wrapper.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My Hostel App',
        theme: ThemeData(
          // This is the theme of application.

          primarySwatch: Colors.green,
        ),
        home: Wrapper(),
        routes: {
          '/addpost_networking': (context)=>AddPost(),
          '/networking_postlisting':(context)=>Post_Listing(),
          '/login':(context)=>LogIn(),
        },
      );
  }
}
