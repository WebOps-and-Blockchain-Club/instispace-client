import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:client/services/Auth.dart';


class InterestPage extends StatefulWidget {
  const InterestPage({Key? key}) : super(key: key);

  @override
  _InterestPageState createState() => _InterestPageState();
}

class _InterestPageState extends State<InterestPage> {
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
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Interests Page'),
          ),
          body: ElevatedButton(
            onPressed: (){
              _auth.setisNewUser(false);
            }, child:Text('update user'),
          ),
        )
    );
  }
}
