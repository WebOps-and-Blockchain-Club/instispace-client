import 'package:client/widgets/main.dart';
import 'package:flutter/material.dart';
import 'package:client/services/Auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const routeName = "/home";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final auth=AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            IconButton(onPressed: ()=>{
              Navigator.pushNamed(context, '/networking_postlisting'),
            }, icon: Icon(Icons.article)),
            ElevatedButton(onPressed: (){
              auth.clearAuth();
            }, child: Text('clear Auth'))
          ],
        ),
      )
    );
  }
}
