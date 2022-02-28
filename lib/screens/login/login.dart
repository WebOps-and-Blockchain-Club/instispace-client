import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:client/graphQL/auth.dart';
import 'package:client/services/Auth.dart';

import 'package:provider/provider.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _auth = Provider.of<AuthService>(context, listen: false);
    });
  }

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late AuthService _auth;
  static var token;
  static var isNewUser;
  static var role;
  String login = authQuery().login;
  late String fcmToken;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  @override
  Widget build(BuildContext context) {
    _firebaseMessaging.getToken().then((token) {
      fcmToken = token!;
      print("fcmtoken:$token");
    });
    return Scaffold(
      backgroundColor: Color(0xFFF7F7F7),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //header
                  const Text(
                    "Sign In",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0),
                  ),

                  //Logo
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                    child: Center(
                      child: SizedBox(
                          height: 150,
                          width: 100,
                          child: Image.network(
                              'https://i.pinimg.com/736x/71/b3/e4/71b3e4159892bb319292ab3b76900930.jpg')),
                    ),
                  ),

                  //Form Column
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 50),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              'UserID*',
                              style: TextStyle(
                                  color: Color(0xFF222222),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 25),
                          child: SizedBox(
                            width: 400.0,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                border: Border.all(
                                  width: 1.5,
                                  color: const Color(0xFF222222),
                                ),
                                color: Colors.white54,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    15.0, 0.0, 15.0, 0.0),
                                child: TextFormField(
                                  controller: usernameController,
                                  cursorColor: Colors.black,
                                  decoration: const InputDecoration(
                                      hintText: 'Enter your User ID',
                                      border: InputBorder.none),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            const Text(
                              'Password*',
                              style: TextStyle(
                                  color: Color(0xFF222222),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                          child: SizedBox(
                            width: 400.0,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  border: Border.all(
                                    width: 1.5,
                                    color: const Color(0xFF222222),
                                  ),
                                  color: Colors.white54),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    10.0, 0.0, 0.0, 0.0),
                                child: TextFormField(
                                  controller: passwordController,
                                  cursorColor: Colors.black,
                                  decoration: InputDecoration(
                                      hintText: 'Enter your password',
                                      border: InputBorder.none),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                          child: Center(
                            child: Mutation(
                              options: MutationOptions(
                                  document: gql(login),
                                  onCompleted: (dynamic resultData) {
                                    print(resultData);
                                    token = resultData["login"]["token"];
                                    isNewUser =
                                        resultData["login"]["isNewUser"];
                                    role = resultData["login"]["role"];
                                    _auth.setToken(token);
                                    _auth.setisNewUser(isNewUser);
                                    _auth.setRole(role);
                                    print(resultData["login"]);
                                  }),
                              builder: (
                                RunMutation runMutation,
                                QueryResult? result,
                              ) {
                                if (result!.hasException) {
                                  print(result.exception.toString());
                                }
                                if (result.isLoading) {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.blue[700],
                                    ),
                                  );
                                }
                                return SizedBox(
                                  width: 100.0,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Color(0xFF42454D),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0))),
                                    onPressed: () {
                                      FirebaseMessaging.instance
                                          .getToken()
                                          .then((token) {
                                        print("token login:$token");
                                      });
                                      runMutation({
                                        'fcmToken': fcmToken,
                                        'loginInputs': {
                                          "roll": usernameController.text,
                                          "pass": passwordController.text,
                                        }
                                      });
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Log In',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    // style: ElevatedButton.styleFrom(
                                    //     primary: Colors.blue[900],
                                    //   shape: RoundedRectangleBorder(
                                    //     borderRadius: BorderRadius.circular(30.0)
                                    //   )
                                    // ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
