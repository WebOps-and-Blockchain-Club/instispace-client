import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:client/services/Auth.dart';

class SU_PasswordChange extends StatefulWidget {
  const SU_PasswordChange({Key? key}) : super(key: key);

  @override
  _SU_PasswordChangeState createState() => _SU_PasswordChangeState();
}

class _SU_PasswordChangeState extends State<SU_PasswordChange> {
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
