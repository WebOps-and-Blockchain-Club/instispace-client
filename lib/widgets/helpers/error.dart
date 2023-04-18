import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../services/auth.dart';
import '../../themes.dart';

class Error extends StatelessWidget {
  final String error;
  final String? message;
  final void Function()? onRefresh;
  const Error(
      {Key? key, required this.error, this.message, required this.onRefresh})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SvgPicture.asset(getAsset(error, message),
              height: 250, semanticsLabel: 'A red up arrow'),
        ),
        ErrorText(error: error, message: message),
        TextButton(
          child: const Text('Refresh'),
          onPressed: onRefresh,
        )
      ],
    );
  }
}

class ErrorText extends StatelessWidget {
  final String error;
  final String? message;
  const ErrorText({Key? key, required this.error, this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      message ?? formatErrorMessage(error, context),
      style: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(color: ColorPalette.palette(context).error, fontSize: 18),
      textAlign: TextAlign.center,
    );
  }
}

String getAsset(String error, String? message) {
  if (error.contains("No Posts") ||
      (message != null &&
          (message.contains("No") || message.contains("is empty")))) {
    return "assets/illustrations/no_data.svg";
  } else if (error.contains("Failed host lookup")) {
    return "assets/illustrations/network_error.svg";
  } else {
    return "assets/illustrations/error.svg";
  }
}

String formatErrorMessage(String error, BuildContext context) {
  print(error);
  // return error;
  if (error.contains("Failed host lookup")) {
    return "No network connection";
  } else if (error.contains('UNAUTHENTICATED')) {
    Provider.of<AuthService>(context, listen: false).logout();
    return "Login to continue";
  } else if (error.contains(
      "Access denied! You need to be authorized to perform this action!")) {
    Provider.of<AuthService>(context, listen: false).logout();
    return "Login to continue";
  } else if (error
      .contains("Access denied! You don't have permission for this action!")) {
    return "Not Allowed to perform this action";
  } else if (error.contains("Invalid Credentials")) {
    return "Invalid Credentials";
  } else if (error.contains("Email or password are invalid")) {
    return "Invalid Credentials";
  } else if (error.contains("Email Not Registered!")) {
    return "Account not found";
  } else if (error.contains("No Posts")) {
    return "No Posts";
  } else if (error.contains("Tag already exists")) {
    return "Tag already exists";
  } else if (error.contains("User doesn’t exist")) {
    return "User doesn’t exist";
  } else if (error.contains("Invalid Role")) {
    return "Roll number doesn't belongs to USER role";
  } else if (error.contains("No Tags found")) {
    return "No Tags found";
  } else if (error.contains("duplicate key value violates unique constraint")) {
    return "Already Exists";
  } else {
    return error;
  }
}
