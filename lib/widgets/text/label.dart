import 'package:flutter/material.dart';

class LabelText extends StatelessWidget {
  final String text;
  const LabelText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Text(text, style: Theme.of(context).textTheme.titleSmall),
    );
  }
}
