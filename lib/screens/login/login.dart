import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:client/widgets/formTexts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:client/graphQL/auth.dart';
import 'package:client/services/Auth.dart';

import 'package:provider/provider.dart';

import '../../models/formErrormsgs.dart';


class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}
class _LogInState extends State<LogIn> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp){
      _auth = Provider.of<AuthService>(context,listen: false);
    });
  }
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late AuthService _auth;
  static var token;
  static var isNewUser;
  static var role;
  String emptyPasswordErr = "";
  String emptyUsernameErr = "";
  String invalidLogin = "";
  String userName = "";
  bool valid = false;
  String login=authQuery().login;
  late String fcmToken;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  Widget build(BuildContext context) {
    _firebaseMessaging.getToken().then((token) {
      fcmToken = token!;
      print("fcmtoken:$token");
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
      child: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //header
              const Padding(
                padding: EdgeInsets.fromLTRB(40,40,40,0),
                child: Text(
                  "Sign In",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0
                  ),
                ),
              ),

              //Logo
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0,20.0,0.0,0.0),
                child: Center(
                  child: SizedBox(
                      height: 150,
                      width: 100,
                      child: Image.network('https://i.pinimg.com/736x/71/b3/e4/71b3e4159892bb319292ab3b76900930.jpg')
                  ),
                ),
              ),

              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: FormText("Username"),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 15, 20, 5),
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
                                hintText: 'Enter your Username',
                              ),
                              controller: usernameController,
                              validator: (val) {
                                if(val == null || val.isEmpty) {
                                  setState(() {
                                    emptyUsernameErr = "Please enter your username";
                                  });
                                }
                                else if (!isValidRoll(val.toUpperCase()) && !isValidEmail(val)) {
                                  setState(() {
                                    emptyUsernameErr = "Please enter a valid username";
                                  });
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),

                      errorMessages(emptyUsernameErr),


                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: FormText("Password"),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 15, 20, 5),
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
                                hintText: 'Enter your password',
                              ),
                              controller: passwordController,
                              validator: (val) {
                                if(val == null || val.isEmpty) {
                                  setState(() {
                                    emptyPasswordErr = "Please enter your password";
                                  });
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),

                      errorMessages(emptyPasswordErr),

                      errorMessages(invalidLogin),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Center(
                          child:
                          Mutation(
                            options:MutationOptions(
                                document: gql(login),
                                onCompleted:(dynamic resultData){
                                  print(resultData);
                                  token = resultData["login"]["token"];
                                  isNewUser=resultData["login"]["isNewUser"];
                                  role=resultData["login"]["role"];
                                  _auth.setToken(token);
                                  _auth.setisNewUser(isNewUser);
                                  _auth.setRole(role);
                                  print("login result : ${resultData["login"]}");
                                },

                            ),
                            builder: (
                                RunMutation runMutation,
                                QueryResult? result,
                                ) {

                              // if(result!.hasException) {
                              //   Column(
                              //     children: [
                              //       const Text("Invalid Login",style: TextStyle(color: Colors.red),),
                              //       Padding(
                              //         padding: const EdgeInsets.fromLTRB(0,25,0,0,),
                              //         child: ElevatedButton(
                              //           onPressed: () {
                              //             if (_formKey.currentState!.validate()) {
                              //               if (isValidEmail(usernameController.text) || isValidRoll(usernameController.text.toUpperCase())) {
                              //                 setState(() {
                              //                   valid = true;
                              //                   emptyUsernameErr = "";
                              //                   emptyPasswordErr = "";
                              //                 });
                              //               }
                              //               if (usernameController.text.isNotEmpty && passwordController.text.isNotEmpty && valid) {
                              //                 runMutation({
                              //                   'loginInputs' :{
                              //                     "roll": usernameController.text,
                              //                     "pass": passwordController.text,
                              //                   }
                              //                 });
                              //               }
                              //             }
                              //           },
                              //           style: ElevatedButton.styleFrom(
                              //             primary: const Color(0xFF2B2E35),
                              //             shape: RoundedRectangleBorder(
                              //                 borderRadius: BorderRadius.circular(24)
                              //             ),
                              //             padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              //             minimumSize: const Size(80, 35),
                              //           ),
                              //           child: const Padding(
                              //             padding: EdgeInsets.fromLTRB(15,5,15,5),
                              //             child: Text('Login',
                              //               style: TextStyle(
                              //                 color: Colors.white,
                              //                 fontSize: 16,
                              //                 fontWeight: FontWeight.bold,
                              //               ),
                              //             ),
                              //           ),
                              //         ),
                              //       )
                              //     ],
                              //   );
                              // }
                              // }
                              if(result!.isLoading){
                                return const Center(
                                  child: CircularProgressIndicator(color: Color(0xFF2B2E35),),
                                );
                              }
                              return Column(
                                children: [
                                  if(result.hasException)
                                  const Text("Invalid Login",style: TextStyle(color: Colors.red),),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0,25,0,0,),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          if (isValidEmail(usernameController.text) || isValidRoll(usernameController.text.toUpperCase())) {
                                            setState(() {
                                              valid = true;
                                              emptyUsernameErr = "";
                                              emptyPasswordErr = "";
                                            });
                                          }
                                          if (usernameController.text.isNotEmpty && passwordController.text.isNotEmpty && valid) {

                                            if(isValidRoll(usernameController.text.toUpperCase())
                                            ) {
                                              userName = usernameController.text.toUpperCase();
                                            }
                                            else{
                                              userName = usernameController.text;
                                            }
                                            runMutation({
                                              'fcmToken':fcmToken,
                                              'loginInputs' :{
                                                "roll": userName,
                                                "pass": passwordController.text,
                                              }
                                            });
                                          }
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
                                        child: Text('Login',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                      )

                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
        ),
    );
  }

  bool isValidEmail(String email) {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }

  bool isValidRoll (String roll) {
    return RegExp(
    r'\b([a-zA-Z]{2,2}[0-9]{2,2}[a-zA-Z][0-9]{3,3})\b')
        .hasMatch(roll);
  }
}

