import 'package:client/screens/Login/createTag.dart';
import 'package:client/screens/home/Announcements/home.dart';
import 'package:client/screens/home/Events/home.dart';
import 'package:client/screens/home/userpage.dart';
import 'package:client/screens/login/createSuperUsers.dart';
import 'package:client/screens/login/createhostel.dart';
import 'package:client/screens/userInit/updatepass.dart';
import 'package:flutter/material.dart';
import 'package:client/services/Auth.dart';
import 'package:provider/provider.dart';

import 'networking_and _opportunities/post_listing.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const routeName = "/home";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AuthService _auth;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _auth = Provider.of<AuthService>(context, listen: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
        child: Column(
        children: [
          IconButton(
              onPressed: () => {
                Navigator.of(context).push(
                MaterialPageRoute(
                builder: (BuildContext context)=> Post_Listing())),
                },
              icon: Icon(Icons.article)),
          ElevatedButton(
              onPressed: () {
                _auth.clearAuth();
              },
              child: Text('clear Auth')),
          ElevatedButton(
            onPressed: () {
          Navigator.of(context).push(
          MaterialPageRoute(
              builder: (BuildContext context)=> EventsHome()));
            },
            child: Text("Events"),
          ),
          ElevatedButton(
            onPressed: () {
          Navigator.of(context).push(
          MaterialPageRoute(
              builder: (BuildContext context)=> CreateSuperUsers()));
          },
            child: Text("Create Super User"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
              MaterialPageRoute(
              builder: (BuildContext context)=> UserPage()));
          },
            child: Text("User Profile"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(
              builder: (BuildContext context)=> setPassword()));
          },
            child: Text("Update Password"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (BuildContext context)=> CreateHostel()));
              },
            child: Text("Create Hostel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (BuildContext context)=> CreateTag()));
            },
            child: Text("Create Tag"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (BuildContext context)=> Announcements()));
            },
            child: Text("Announcements"),
          ),
        ],
      ),
    ));
  }
}
