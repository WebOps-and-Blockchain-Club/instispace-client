import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../themes.dart';
import '../button/elevated_button.dart';

void showWarningAlert(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
            titlePadding: const EdgeInsets.only(top: 30, bottom: 10),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            actionsPadding: const EdgeInsets.all(10),
            title: const Text('Hang On', textAlign: TextAlign.center),
            content: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        'Please avoid posting any inappropriate content here, since your activity is traced on your account, as detailed in ',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text: 'terms of service.',
                    style: const TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrlString(
                            'https://docs.google.com/document/d/e/2PACX-1vTCDv6MFgQ6BmWKHQdGqeo2qVVhHMnlNyU24buZV_Vf1riw0ixCz_yysktiCYc-mCLsTplq3XZVdXrU/pub',
                            mode: LaunchMode.externalApplication);
                      },
                  ),
                ],
              ),
            ),
            actions: [
              CustomElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                text: "Agreed",
                color: ColorPalette.palette(context).primary,
                type: ButtonType.outlined,
              )
            ],
          ));
}
