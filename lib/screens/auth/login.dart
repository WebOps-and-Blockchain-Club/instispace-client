import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../graphQL/auth.dart';
import '../../services/auth.dart';
import '../../widgets/button/elevated_button.dart';
import '../../widgets/form/text_form_field.dart';
import '../../widgets/text/label.dart';

class LogIn extends StatefulWidget {
  final AuthService auth;
  const LogIn({Key? key, required this.auth}) : super(key: key);

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController name = TextEditingController();
  final TextEditingController pass = TextEditingController();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  late String fcmToken;

  @override
  void initState() {
    super.initState();
  }

  bool passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    _firebaseMessaging.getToken().then((token) {
      fcmToken = token!;
    });

    return Mutation(
        options: MutationOptions(
          document: gql(AuthGQL().login),
          onCompleted: (dynamic resultData) {
            if (resultData["login"] != null) {
              widget.auth.login(
                  resultData["login"]["token"],
                  resultData["login"]["role"],
                  resultData["login"]["isNewUser"]);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('User Logged In')),
              );
            }
          },
        ),
        builder: (
          RunMutation runMutation,
          QueryResult? result,
        ) {
          return SafeArea(
            child: Scaffold(
                body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Form(
                key: formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const Center(
                      child: SizedBox(
                        height: 350,
                        width: 250,
                        child: Image(
                            image: AssetImage(
                                'assets/logo/primary_with_text.png')),
                      ),
                    ),
                    const LabelText(text: "Log In with LDAP"),
                    CustomTextFormField(
                        controller: name,
                        labelText: "Roll Number",
                        prefixIcon: Icons.person,
                        isDense: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter the roll number";
                          } else if (!isValidRoll(value.toUpperCase().trim()) &&
                              !isValidEmail(value.trim())) {
                            return "Enter the valid username";
                          }
                          return null;
                        }),
                    CustomTextFormField(
                        controller: pass,
                        labelText: "Password",
                        prefixIcon: Icons.password,
                        isDense: false,
                        obscureText: passwordVisible,
                        maxLines: 1,
                        suffixIcon: passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        suffixIconPressed: () => setState(() {
                              passwordVisible = !passwordVisible;
                            }),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter the LDAP password";
                          }
                          return null;
                        }),
                    if (result!.hasException)
                      Text(result.exception.toString(),
                          style:
                              const TextStyle(color: Colors.red, fontSize: 12)),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: CustomElevatedButton(
                        onPressed: () {
                          final isValid = formKey.currentState!.validate();
                          FocusScope.of(context).unfocus();

                          if (isValid) {
                            runMutation({
                              'fcmToken': fcmToken,
                              'loginInputs': {
                                "roll": name.text.trim().toLowerCase(),
                                "pass": pass.text,
                              }
                            });
                          }
                        },
                        text: "SIGN IN",
                        isLoading: result.isLoading,
                      ),
                    )
                  ],
                ),
              ),
            )),
          );
        });
  }

  bool isValidEmail(String email) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }

  bool isValidRoll(String roll) {
    return RegExp(r'\b([a-zA-Z]{2,2}[0-9]{2,2}[a-zA-Z][0-9]{3,3})\b')
        .hasMatch(roll);
  }
}
