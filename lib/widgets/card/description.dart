import 'package:client/utils/validation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:validators/validators.dart';

class Description extends StatelessWidget {
  final String content;
  const Description({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SelectableText.rich(
      TextSpan(
        children: content.split(" ").map((_data) {
          if (isValidEmail(_data)) {
            return TextSpan(
                text: _data + " ",
                recognizer: TapGestureRecognizer()
                  ..onTap = () => launchUrl(Uri(scheme: 'mailto', path: _data)),
                style: const TextStyle(color: Color(0xFF0000EE)));
          }
          if (isURL(_data)) {
            return TextSpan(
                text: _data + " ",
                recognizer: TapGestureRecognizer()
                  ..onTap = () =>
                      launchUrlString(_data, mode: LaunchMode.inAppWebView),
                style: const TextStyle(color: Color(0xFF0000EE)));
          }
          if (isValidNumber(_data)) {
            return TextSpan(
                text: _data + " ",
                recognizer: TapGestureRecognizer()
                  ..onTap = () => launchUrl(Uri(scheme: 'tel', path: _data)),
                style: const TextStyle(color: Color(0xFF0000EE)));
          }
          return TextSpan(text: _data + " ");
        }).toList(),
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      textAlign: TextAlign.justify,
    );
  }
}
