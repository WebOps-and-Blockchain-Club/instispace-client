import 'package:flutter/material.dart';

class LostAndFound extends StatefulWidget {
  const LostAndFound({Key? key}) : super(key: key);

  @override
  _LostAndFoundState createState() => _LostAndFoundState();
}

class _LostAndFoundState extends State<LostAndFound> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Lost and Found Cases"
        ),
      ),
    );
  }
}
