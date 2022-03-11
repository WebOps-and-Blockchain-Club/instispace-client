import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:client/services/Auth.dart';
import 'package:client/graphQL/auth.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../models/formErrormsgs.dart';
import '../../widgets/formTexts.dart';

class setPassword extends StatefulWidget {
  final AuthService auth;
  setPassword({required this.auth});

  @override
  _setPasswordState createState() => _setPasswordState();
}

class _setPasswordState extends State<setPassword> {
  String updatePassword = authQuery().updatePassword;
  final newPassController = TextEditingController();
  final confirmPassController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late String err;
  String emptyNewPassErr = "";
  String emptyConfirmPassErr = "";
  String emptyNameErr = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Set New Password",
          style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 20,
              fontWeight: FontWeight.bold
          ),
        ),
        elevation: 0,
        backgroundColor: const Color(0xFF2B2E35),
      ),

      backgroundColor: const Color(0xFFDFDFDF),

      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            ///Name
            FormText('Name'),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
              child: SizedBox(
                height: 35,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0,0,0,0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(8,5,0,8),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      hintText: 'Enter your name',
                    ),
                    controller: nameController,
                    validator: (val) {
                      if(val == null || val.isEmpty) {
                        setState(() {
                          emptyNameErr = "Please enter name";
                        });
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),

            errorMessages(emptyNameErr),

            ///New Password
            FormText('New Password'),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
              child: SizedBox(
                height: 35,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0,0,0,0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(8,5,0,8),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      hintText: 'Enter new password',
                    ),
                    controller: newPassController,
                    validator: (val) {
                      if(val == null || val.isEmpty) {
                        setState(() {
                          emptyNewPassErr = "Please enter new password";
                        });
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),

            errorMessages(emptyNewPassErr),

            ///Confirm Password
            FormText('Confirm Password'),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
              child: SizedBox(
                height: 35,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0,0,0,0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(8,5,0,8),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      hintText: 'Confirm your password',
                    ),
                    controller: confirmPassController,
                      validator: (val) {
                        if (val == null || val.isEmpty && newPassController.text.isNotEmpty) {
                          setState(() {
                            emptyConfirmPassErr = "Please confirm Password";
                          });
                        } else if (val != newPassController.text) {
                          emptyConfirmPassErr = "Passwords don't match";
                        }
                        return null;
                      }
                  ),
                ),
              ),
            ),

            errorMessages(emptyConfirmPassErr),

            Mutation(
                options: MutationOptions(
                  document: gql(updatePassword),
                  onCompleted: (resultData) {
                    print(resultData);
                    widget.auth.setisNewUser(false);
                  }
                ),
                builder: (
                  RunMutation runMutation,
                  QueryResult? result,
                ) {
                  if (result!.hasException) {
                    print(result.exception.toString());
                  }
                  if(result.isLoading){
                    return Center(
                        child: LoadingAnimationWidget.threeRotatingDots(
                          color: const Color(0xFF2B2E35),
                          size: 20,
                        ));
                  }
                  return Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          runMutation({
                            "updateSuperUserInput": {
                              "newPassword": newPassController.text,
                              "name": nameController.text
                            }
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF2B2E35),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24)
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        minimumSize: const Size(80, 35),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(15,5,15,5),
                        child: Text('Submit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
