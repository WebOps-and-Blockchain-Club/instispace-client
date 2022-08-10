import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final String? message;
  const Loading({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String assetName = 'assets/illustrations/loading.gif';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          assetName,
          height: 125.0,
          width: 125.0,
        ),
        Text(
          message ?? "Loading...",
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
