
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                              isNewUser=resultData["login"]["isNewUser"];
                              role=resultData["login"]["role"];
                              _auth.setToken(token);
                              _auth.setisNewUser(isNewUser);
                              _auth.setRole(role);
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
    );
  }
}
