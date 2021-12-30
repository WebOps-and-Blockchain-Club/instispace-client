import 'dart:io';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:client/services/Auth.dart';
import 'package:client/services/Client.dart';


class LogIn extends StatefulWidget {
  @override

  _LogInState createState() => _LogInState();
}

  String login = """mutation(\$loginInputs: LoginInput!){
  login( LoginInputs: \$loginInputs)
   {
    role
    token
    isNewUser
  }
}""";

  class _LogInState extends State<LogIn> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  static var token;
  final auth=AuthService();
  
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                      height: 150,
                      width: 100,
                      child: Image.network('https://i.pinimg.com/736x/71/b3/e4/71b3e4159892bb319292ab3b76900930.jpg')
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                    'Username'
                ),
                SizedBox(
                  width: 400.0,
                  child: TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                        hintText: 'Username'
                    ),
                  ),
                ),
                SizedBox(height: 10.0,),
                Text(
                  'your ldap id',
                  style: TextStyle(
                    fontWeight: FontWeight.w200,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                    'password'
                ),
                SizedBox(
                  width: 400.0,
                  child: TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                        hintText: 'password'
                    ),
                  ),
                ),
                Center(
                  child:
                         Mutation(
                          options:MutationOptions(
                              document: gql(login),
                              onCompleted:(dynamic resultData){
                                token = resultData["login"]["token"];
                                auth.setToken(token);
                                print(resultData["login"]);
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
                                child: CircularProgressIndicator(),
                              );
                            }
                            return ElevatedButton(
                              onPressed: () {
                                 runMutation({
                                  'loginInputs' :{
                                    "roll": usernameController.text,
                                    "pass": passwordController.text,
                                  }
                                });
                              },
                              child: Text(
                                  'login'
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
