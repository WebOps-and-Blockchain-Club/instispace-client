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

  final NewPasscontroller = TextEditingController();
  final ConfirmPasscontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late String err;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        title: Text(
          "Set New Password",
          style: TextStyle(
              color: Colors.white,
              fontSize: 30.0,
              fontWeight: FontWeight.bold
          ),
        ),
        elevation: 0.0,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [
                0.1,
                0.3,
                0.5,
                0.7,
                0.9,
              ],
              colors: [
                Colors.deepPurpleAccent,
                Colors.blue,
                Colors.lightBlueAccent,
                Colors.lightBlueAccent,
                Colors.blueAccent,
              ],
            )
        ),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'New Password*',
                  style: TextStyle(
                      color: Colors.blue[900],
                      fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 10.0),
                SizedBox(
                  width: 400.0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: Colors.blue[200]
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10.0,0.0,0.0,0.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter your new password',
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.black, width: 1.0),
                                borderRadius: BorderRadius.circular(20.0))),
                        controller: NewPasscontroller,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "This field can't be empty";
                          }
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Confirm Password*',
                  style: TextStyle(
                      color: Colors.blue[900],
                      fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 10.0),
                SizedBox(
                  width: 400.0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: Colors.blue[200]
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10.0,0.0,0.0,0.0),
                      child: TextFormField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                              hintText: 'Enter your new password again',
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.black, width: 1.0),
                                  borderRadius: BorderRadius.circular(20.0))),
                          controller: ConfirmPasscontroller,
                          validator: (val) {
                            if (val == null ||
                                val.isEmpty && NewPasscontroller.text.isNotEmpty) {
                              return "Please confirm Password";
                            } else if (val != NewPasscontroller.text) {
                              return "Passwords don't match";
                            }
                            return null;
                          }),
                    ),
                  ),
                ),
                SizedBox(height: 30.0),
                Center(
                  child: SizedBox(
                    width: 400.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue[700],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _auth.setisNewUser(false);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Continue",
                          style: TextStyle(color: Colors.white,fontSize: 18.0,fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
