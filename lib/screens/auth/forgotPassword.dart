import 'package:client/graphQL/auth.dart';
import 'package:client/themes.dart';
import 'package:client/widgets/button/elevated_button.dart';
import 'package:client/widgets/headers/main.dart';
import 'package:client/widgets/helpers/error.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ForgotPassword extends StatefulWidget {
  final String roll;
  const ForgotPassword({Key? key, required this.roll}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController newpass = TextEditingController();
  final TextEditingController confirmPass = TextEditingController();

  bool mailSent = false;

  final formKey = GlobalKey<FormState>();
  bool passVisible = true;
  bool confirmPassVisible = true;

  @override
  void initState() {
    email.text = widget.roll;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Mutation(
        options: MutationOptions(
          document: gql(AuthGQL().forgotPassword),
          onCompleted: (dynamic resultData) {
            print(resultData);
            if (resultData == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invalid password')));
            }
            if (resultData["forgotPassword"] == true) {
              if (mailSent == false) {
                setState(() {
                  mailSent = true;
                });
              } else {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Login to continue')));
              }
            }
          },
          onError: (dynamic error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(formatErrorMessage(error.toString(), context))),
            );
          },
        ),
        builder: (
          RunMutation runMutation,
          QueryResult? result,
        ) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Forgot Password',
                style: TextStyle(
                    letterSpacing: 1,
                    color: Color(0xFF3C3C3C),
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
            ),
            body: SafeArea(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: Column(
                      children: [
                        Form(
                            key: formKey,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: TextFormField(
                                    controller: email,
                                    readOnly: mailSent,
                                    decoration: const InputDecoration(
                                      labelText: "Email",
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Enter the roll number";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                if (mailSent)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: TextFormField(
                                      controller: password,
                                      decoration: const InputDecoration(
                                        labelText:
                                            "PASSWORD (sent to the mail)",
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Enter the password";
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                if (mailSent)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: TextFormField(
                                      controller: newpass,
                                      obscureText: passVisible,
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () => setState(() {
                                              passVisible = !passVisible;
                                            }),
                                            icon: Icon(
                                                passVisible
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                                size: 20),
                                          ),
                                          suffixIconConstraints:
                                              Themes.inputIconConstraints,
                                          labelText: "New Password"),
                                    ),
                                  ),
                                if (mailSent)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: TextFormField(
                                      controller: confirmPass,
                                      obscureText: confirmPassVisible,
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () => setState(() {
                                              confirmPassVisible =
                                                  !confirmPassVisible;
                                            }),
                                            icon: Icon(
                                                confirmPassVisible
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                                size: 20),
                                          ),
                                          prefixIconConstraints:
                                              Themes.inputIconConstraints,
                                          suffixIconConstraints:
                                              Themes.inputIconConstraints,
                                          labelText: "Confirm Password"),
                                      validator: (val) {
                                        if (val == null || val.isEmpty) {
                                          return "Re-enter the password to confirm";
                                        } else if (newpass.text != val) {
                                          return "Password don't match";
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                              ],
                            )),
                        CustomElevatedButton(
                            isLoading:
                                result != null ? result.isLoading : false,
                            onPressed: () {
                              final isValid = formKey.currentState!.validate();
                              FocusScope.of(context).unfocus();

                              print(email.text);
                              print(mailSent ? password.text : null);
                              print(mailSent ? newpass.text : null);

                              if (isValid) {
                                runMutation({
                                  "forgotPasswordInput": {
                                    "roll": email.text,
                                    "password": mailSent ? password.text : null,
                                    "newpass": mailSent ? newpass.text : null
                                  }
                                });
                              }
                            },
                            text: 'Submit')
                      ],
                    ))),
          );
        });
  }
}
