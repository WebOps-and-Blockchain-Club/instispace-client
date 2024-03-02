import 'package:client/screens/auth/forgotPassword.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../graphQL/auth.dart';
import '../../services/auth.dart';
import '../../themes.dart';
import '../../utils/validation.dart';
import '../../widgets/helpers/error.dart';

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
          return Stack(
            children: [
              Scaffold(
                  body: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Form(
                      key: formKey,
                      child: ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          const SizedBox(height: 30),
                          const Center(
                            child: SizedBox(
                              height: 240,
                              width: 170,
                              child: Image(
                                color: Color.fromARGB(255, 100, 90, 247),
                                  opacity: AlwaysStoppedAnimation(10),
                                  image: AssetImage(
                                      'assets/logo/primary_with_text.png')),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(25, 0, 25, 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: const [
                                          Text('L',
                                              style: TextStyle(
                                                  fontSize: 44,
                                                  fontWeight: FontWeight.w900)),
                                          Padding(
                                            padding: EdgeInsets.only(bottom: 1),
                                            child: Text('OGIN',
                                                style: TextStyle(
                                                    fontSize: 37,
                                                    fontWeight:
                                                        FontWeight.w900)),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'Use your LDAP credentials',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      )
                                    ],
                                  ),
                                ),
                                TextFormField(
                                  style: const TextStyle(fontSize: 18),
                                  controller: name,
                                  decoration: const InputDecoration(
                                    labelText: "Roll Number",
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Enter the roll number";
                                    } else if (!isValidRoll(
                                            value.toUpperCase().trim()) &&
                                        !isValidEmail(value.trim())) {
                                      return "Enter the valid username";
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  style: const TextStyle(fontSize: 18),
                                  controller: pass,
                                  obscureText: passwordVisible,
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                      suffixIcon: InkWell(
                                        onTap: () => setState(() {
                                          passwordVisible = !passwordVisible;
                                        }),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                              passwordVisible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              size: 20),
                                        ),
                                      ),
                                      suffixIconConstraints:
                                          Themes.inputIconConstraints,
                                      labelText: "Password"),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Enter the LDAP password";
                                    }
                                    return null;
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ForgotPassword(
                                                          roll: name.text)));
                                        },
                                        child: Text(
                                          'Forgot Password?',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                      ),
                                      Text('(Only for super users)',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  color: Colors.grey[700])),
                                    ],
                                  ),
                                ),

                                if (result != null && result.hasException)
                                  ErrorText(error: result.exception.toString()),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(25, 50, 25, 25),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(37)),
                                        backgroundColor:
                                            ColorPalette.palette(context)
                                                .primary),
                                    child: Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                           Text(
                                            '           Sign in',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.normal,
                                                color:  Colors.white
                                                ),
                                          ),
                                          (result != null && result.isLoading)
                                              ? const CircularProgressIndicator(
                                                  color: Colors.white,
                                                )
                                              : const Icon(Icons.arrow_forward)
                                        ],
                                      ),
                                    ),
                                    onPressed: () {
                                      final isValid =
                                          formKey.currentState!.validate();
                                      FocusScope.of(context).unfocus();

                                      if (isValid) {
                                        runMutation({
                                          'fcmToken': fcmToken,
                                          'loginInputs': {
                                            "roll":
                                                name.text.trim().toLowerCase(),
                                            "pass": pass.text,
                                          }
                                        });
                                      }
                                    },
                                  ),
                                ),
                                // const SizedBox(height: 20),
                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceEvenly,
                                //   children: [
                                //     ElevatedButton(
                                //         style: ElevatedButton.styleFrom(
                                //             shape: RoundedRectangleBorder(
                                //                 borderRadius:
                                //                     BorderRadius.circular(
                                //                         15.73)),
                                //             side: const BorderSide(
                                //                 style: BorderStyle.none),
                                //             padding: const EdgeInsets.symmetric(
                                //                 vertical: 2, horizontal: 15),
                                //             backgroundColor: Colors.white),
                                //         onPressed: () {},
                                //         child: Padding(
                                //           padding: const EdgeInsets.symmetric(
                                //               horizontal: 15, vertical: 8),
                                //           child: Row(
                                //             mainAxisAlignment:
                                //                 MainAxisAlignment.spaceBetween,
                                //             children: const [
                                //               Image(
                                //                   height: 31,
                                //                   image: AssetImage(
                                //                       'assets/google.png')),
                                //               SizedBox(width: 15),
                                //               Text(
                                //                 'Sign in with Google',
                                //                 style: TextStyle(
                                //                     color: Colors.black,
                                //                     fontWeight:
                                //                         FontWeight.normal,
                                //                     fontSize: 16),
                                //               )
                                //             ],
                                //           ),
                                //         )),
                                //   ],
                                // )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )),
              const Positioned(
                  top: -50,
                  right: -80,
                  child: Image(
                      width: 300,
                      image: AssetImage('assets/illustrations/decor.png'))),
            ],
          );
        });
  }
}
