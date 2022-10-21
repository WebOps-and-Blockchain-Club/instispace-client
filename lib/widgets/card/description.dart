import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:validators/validators.dart';

import '../../utils/validation.dart';

class Description extends StatelessWidget {
  final String content;
  const Description({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> _dataArr = content.split("\n");
    return SelectableText.rich(
      TextSpan(
        children: _dataArr.map((_data) {
          if (_data.contains(RegExp(r'\s'))) {
            List<String> _dataArr2 = _data.split(RegExp(r'\s'));
            return TextSpan(
                children: [..._dataArr2, _dataArr.last == _data ? "" : "\n"]
                    .map((_data2) => textWidget(_data2, " "))
                    .toList());
          } else {
            return textWidget(_data.trim(), _dataArr.last == _data ? "" : "\n");
          }
        }).toList(),
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  TextSpan textWidget(String _data, String _sec) {
    if (isValidEmail(_data)) {
      return TextSpan(
          text: _data + _sec,
          recognizer: TapGestureRecognizer()
            ..onTap = () => launchUrl(Uri(scheme: 'mailto', path: _data)),
          style: const TextStyle(color: Color(0xFF0000EE)));
    }
    if (isURL(_data)) {
      return TextSpan(
          text: _data + _sec,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              _data.contains("http")
                  ? launchUrlString(_data.trim(),
                      mode: LaunchMode.externalApplication)
                  : launchUrlString("http://" + _data.trim(),
                      mode: LaunchMode.externalApplication);
            },
          style: const TextStyle(color: Color(0xFF0000EE)));
    }
    if (isValidNumber(_data)) {
      return TextSpan(
          text: _data + _sec,
          recognizer: TapGestureRecognizer()
            ..onTap = () => launchUrl(Uri(scheme: 'tel', path: _data)),
          style: const TextStyle(color: Color(0xFF0000EE)));
    }
    return TextSpan(text: _data + _sec);
  }
}
