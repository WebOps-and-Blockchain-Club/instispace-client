import 'package:client/widgets/main.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  static const routeName = "/home";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
              children: [
                ElevatedButton(onPressed: () {
                  Navigator.pushNamed(context, '/events');
                },
                  child: Text("Events"),),
                ElevatedButton(onPressed: () {
                  Navigator.pushNamed(context, '/signUp');
                },
                  child: Text("SignUp"),),
                ElevatedButton(onPressed: () {
                  Navigator.pushNamed(context, '/createSuperUser');
                },
                  child: Text("Create Super User"),),
                ElevatedButton(onPressed: () {
                  Navigator.pushNamed(context, '/userpage');
                },
                  child: Text("User Profile"),),
                ElevatedButton(onPressed: () {
                  Navigator.pushNamed(context, '/updatepassword');
                },
                  child: Text("Update Password"),),
                ElevatedButton(onPressed: () {
                  Navigator.pushNamed(context, '/createhostel');
                },
                  child: Text("Create Hostel"),),
              ],
            )
        )
    );
  }
}
