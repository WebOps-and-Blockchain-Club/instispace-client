import 'package:flutter/material.dart';

class SplashCard extends StatelessWidget {
  final String image;

  const SplashCard(this.image, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF7756EC),
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                image,
                fit: BoxFit.contain,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 110,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
