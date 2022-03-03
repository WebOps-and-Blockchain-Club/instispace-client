
import 'package:flutter/material.dart';
import 'package:client/services/Auth.dart';
import 'package:client/screens/userInit/signUp.dart';
import 'package:client/screens/userInit/updatePass.dart';

class userInit extends StatefulWidget {
  final AuthService auth;
  userInit({required this.auth});

  @override
  _userInitState createState() => _userInitState();
}

class _userInitState extends State<userInit> {
  @override
  Widget build(BuildContext context) {
    return widget.auth.role == "USER" ? SignUp(auth: widget.auth,) : setPassword(auth: widget.auth);
  }
}
