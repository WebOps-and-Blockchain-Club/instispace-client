
import 'package:client/screens/userInit/main.dart';
import 'package:flutter/material.dart';
import 'package:client/screens/login/login.dart';
import 'package:client/services/Auth.dart';
import 'package:provider/provider.dart';
import 'package:client/screens/home/main.dart';

import 'home/home.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:(_)=>AuthService(),
      child:Consumer<AuthService>(
        builder:(context,auth,child){

          return auth.token == null ? LogIn():(auth.isNewUser==false?mainHome():userInit(auth: auth));
        }
      )
    );
  }
}
