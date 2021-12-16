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
            IconButton(onPressed: ()=>{
              Navigator.pushNamed(context, '/networking_postlisting'),
            }, icon: Icon(Icons.article))
          ],
        ),
      )
    );
  }
}
