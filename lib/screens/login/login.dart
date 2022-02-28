
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
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp){
        _auth = Provider.of<AuthService>(context,listen: false);
      });
    }
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late AuthService _auth;
  static var token;
  static var isNewUser;
  static var role;
  String login=authQuery().login;
  late String fcmToken;
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  @override
  Widget build(BuildContext context) {

    _firebaseMessaging.getToken().then((token){
      fcmToken= token!;
      print("fcmtoken:$token");
    });
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [
                0.1,
                0.3,
                0.5,
                0.7,
                0.9,
              ],
              colors: [
                Colors.deepPurpleAccent,
                Colors.blue,
                Colors.lightBlueAccent,
                Colors.lightBlueAccent,
                Colors.blueAccent,
              ],
            )
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sign In",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    fontSize: 30.0
                  ),
                ),
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
                SizedBox(
                  height: 20.0,
                ),
                Text(
                    'User*',
                  style: TextStyle(
                    color: Colors.blue[900],
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 10.0),
                SizedBox(
                  width: 400.0,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Colors.blue[200]
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10.0,0.0,0.0,0.0),
                      child: TextFormField(
                        controller: usernameController,
                        cursorColor: Colors.blue[700],
                        decoration: InputDecoration(
                            hintText: 'Enter your User ID',
                            border: InputBorder.none
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                    'Password*',
                  style: TextStyle(
                    color: Colors.blue[900],
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 10.0,),
                SizedBox(
                  width: 400.0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: Colors.blue[200]
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10.0,0.0,0.0,0.0),
                      child: TextFormField(
                        controller: passwordController,
                        cursorColor: Colors.blue[700],
                        decoration: InputDecoration(
                            hintText: 'Enter your password',
                          border: InputBorder.none
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30.0),
                Center(
                  child:
                         Mutation(
                          options:MutationOptions(
                              document: gql(login),
                              onCompleted:(dynamic resultData){
                                // print(resultData);
                                token = resultData["login"]["token"];
                                isNewUser=resultData["login"]["isNewUser"];
                                role=resultData["login"]["role"];
                                _auth.setToken(token);
                                _auth.setisNewUser(isNewUser);
                                _auth.setRole(role);
                                print("loginPage");
                              }
                          ),
                          builder: (
                              RunMutation runMutation,
                              QueryResult? result,
                              ) {
                            if (result!.hasException){
                              print(result.exception.toString());
                            }
                            if(result.isLoading){
                              return Center(
                                child: CircularProgressIndicator(color: Colors.blue[700],),
                              );
                            }
                            return SizedBox(
                              width: 400.0,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.blue[700],
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))
                                ),
                                onPressed: () {
                                  FirebaseMessaging.instance.getToken().then((token){
                                    print("token login:$token");
                                  });
                                   runMutation({

                                    'loginInputs' :{
                                      "roll": usernameController.text,
                                      "pass": passwordController.text,
                                    }
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      'Log in',
                                    style: TextStyle(color: Colors.white,fontSize: 18.0,fontWeight: FontWeight.w600),
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
