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
      appBar: AppBar(
        title: Text(
          "Update Password",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFFE6CCA9),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              decoration: InputDecoration(
                  hintText: 'Enter New Password',
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
            TextFormField(
                decoration: InputDecoration(
                    hintText: 'Confirm Password',
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
            // SizedBox(height: 30.0,child: errorMsg("errmsg")),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _auth.setisNewUser(false);
                }
              },
              child: Text(
                "Submit",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
