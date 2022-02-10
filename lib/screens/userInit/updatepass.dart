import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:client/services/Auth.dart';
import 'package:client/graphQL/auth.dart';

class setPassword extends StatefulWidget {
  final AuthService auth;
  setPassword({required this.auth});

  @override
  _setPasswordState createState() => _setPasswordState();
}

class _setPasswordState extends State<setPassword> {
  String updatePassword = authQuery().updatePassword;
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
              color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),
        ),
        elevation: 0.0,
        backgroundColor: Colors.deepPurpleAccent,
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
            Mutation(
                options: MutationOptions(
                  document: gql(updatePassword),
                ),
                builder: (
                  RunMutation runMutation,
                  QueryResult? result,
                ) {
                  if (result!.hasException) {
                    print(result.exception.toString());
                  }
                  if (result.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        runMutation({
                          "newPass": {
                            "newPassword": NewPasscontroller.text,
                          }
                        });
                        widget.auth.setisNewUser(false);
                      }
                    },
                    child: Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
