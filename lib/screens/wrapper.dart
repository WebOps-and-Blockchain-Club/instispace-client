import 'package:client/screens/home/main.dart';
import 'package:flutter/material.dart';
import 'package:client/screens/login/login.dart';
import 'package:client/services/Auth.dart';
import 'package:provider/provider.dart';
class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<AuthService>(
      create:(_)=>AuthService(),
      lazy: false,
      child:Consumer<AuthService>(
        builder:(context,auth,child){
          return auth.token == null ? LogIn():HomePage();
        }
      )
    );
  }
}
