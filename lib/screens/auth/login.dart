import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../graphQL/auth.dart';
import '../../services/auth.dart';
import '../../themes.dart';
import '../../utils/validation.dart';
import '../../widgets/helpers/error.dart';
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
              print(resultData["login"]);
              widget.auth.login(
                resultData["login"]["token"],
                //resultData["login"]["isNewUser"]
              );
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
          return Scaffold(
              body: SafeArea(
            child: Padding(
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
                    const LabelText(text: "Login with LDAP"),
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
                      ErrorText(error: result.exception.toString()),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: CustomElevatedButton(
                        onPressed: () {
                          final isValid = formKey.currentState!.validate();
                          FocusScope.of(context).unfocus();

                          if (isValid) {
                            runMutation({
                              //'fcmToken': fcmToken,
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
            ),
          ));
        });
  }
}
