
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Sign In",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),),
        backgroundColor: Color(0xFF5451FD),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0,20.0,0.0,0.0),
                child: Center(
                  // child: SizedBox(
                  //     height: 150,
                  //     width: 100,
                  //     child: Image.network('https://i.pinimg.com/736x/71/b3/e4/71b3e4159892bb319292ab3b76900930.jpg')
                  // ),
                  child: CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage('https://pbs.twimg.com/profile_images/1459179322854367232/Zj38Rken_400x400.jpg')
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                  'User*',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Color(0xFF4151E5),
                ),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.fromLTRB(15,8,15,5),
                child: SizedBox(
                  height: 40.0,
                  child: TextFormField(
                    controller: usernameController,
                    cursorColor: Colors.blue[700],
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 2.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100.0),
                      ),

                      hintText: 'Enter Username',
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
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Color(0xFF4151E5),
                ),
              ),
              SizedBox(height: 10.0,),
              Padding(
                padding: const EdgeInsets.fromLTRB(15,8,15,5),
                child: SizedBox(
                  height: 40.0,
                  child: TextFormField(
                    controller: passwordController,
                    cursorColor: Colors.blue[700],
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 2.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100.0),
                      ),

                      hintText: 'Enter Password',
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
                              print(resultData);
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
                              child: CircularProgressIndicator(color: Colors.blue[700],),
                            );
                          }
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFF6B7AFF),
                              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              minimumSize: Size(80, 35),
                            ),
                            onPressed: () {
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
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
