import 'package:flutter/material.dart';

class HomeTitle extends StatelessWidget {
  const HomeTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Text(
        "Let's begin the project",
        style: TextStyle(fontSize: 32),
      )),
    );
  }
}
