import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:client/services/Auth.dart';

class setPassword extends StatefulWidget {
  const setPassword({Key? key}) : super(key: key);

  @override
  _setPasswordState createState() => _setPasswordState();
}

class _setPasswordState extends State<setPassword> {
  late AuthService _auth;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _auth = Provider.of<AuthService>(context, listen: false);
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: Text('password change screen'),
      ),
      body:  ElevatedButton(
        onPressed: (){
          _auth.setisNewUser(false);
        }, child:Text('update user'),
      ),
    ));
  }
}
