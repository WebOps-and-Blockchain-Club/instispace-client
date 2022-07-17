import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../graphQL/auth.dart';
import '../../services/auth.dart';
import '../../themes.dart';
import '../../widgets/button/elevated_button.dart';
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

  late String? fcmToken = "";

  Future<void> getToken() async {
    String? _fcmToken = await FirebaseMessaging.instance.getToken();
    setState(() {
      fcmToken = _fcmToken;
    });
  }

  @override
  void initState() {
    getToken();
    super.initState();
  }

  bool passwordVisible = true;

  @override
  Widget build(BuildContext context) {
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
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextFormField(
                        controller: name,
                        decoration: InputDecoration(
                          labelText: "Roll Number",
                          prefixIcon: const Icon(Icons.person, size: 20),
                          prefixIconConstraints: Themes.inputIconConstraints,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter the roll number";
                          } else if (!isValidRoll(value.toUpperCase().trim()) &&
                              !isValidEmail(value.trim())) {
                            return "Enter the valid username";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextFormField(
                        controller: pass,
                        obscureText: passwordVisible,
                        maxLines: 1,
                        decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.password, size: 20),
                            suffixIcon: IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () => setState(() {
                                passwordVisible = !passwordVisible;
                              }),
                              icon: Icon(
                                  passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  size: 20),
                            ),
                            prefixIconConstraints: Themes.inputIconConstraints,
                            suffixIconConstraints: Themes.inputIconConstraints,
                            labelText: "Password"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter the LDAP password";
                          }
                          return null;
                        },
                      ),
                    ),
                    if (result != null && result.hasException)
                      SelectableText(result.exception.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: ColorPalette.palette(context).error)),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: CustomElevatedButton(
                        onPressed: () {
                          final isValid = formKey.currentState!.validate();
                          FocusScope.of(context).unfocus();

                          if (isValid) {
                            runMutation({
                              'fcmToken': "fcmToken",
                              'loginInputs': {
                                "roll": name.text.trim().toLowerCase(),
                                "pass": pass.text,
                              }
                            });
                          }
                        },
                        text: "SIGN IN",
                        isLoading: result!.isLoading,
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
