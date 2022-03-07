import 'package:client/screens/home/searchCard.dart';
import 'package:client/screens/userInit/dropDown.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:client/graphQL/home.dart';

import '../../models/formErrormsgs.dart';
import '../../widgets/formTexts.dart';

class CreateSuperUsers extends StatefulWidget {

  @override
  _CreateSuperUsersState createState() => _CreateSuperUsersState();
}

class _CreateSuperUsersState extends State<CreateSuperUsers> {

  String createSuperUser = homeQuery().createSuperUser;
  String getMe = homeQuery().getMe;
  static var role;
  String emptyRollErr = "";
  List<String> Roles = ["HAS","HOSTEL_SEC","SECRETARY","LEADS"];
  String DropDownValue  = "HAS";
  TextEditingController rollController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
        document: gql(getMe),),
        builder: (QueryResult result, {fetchMore, refetch}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }
          if (result.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: Colors.blue[700],),
            );
          }
          role = result.data!["getMe"]["role"];
          print(role);
          if(role == "HAS") {
            Roles.clear();
            Roles.add("HOSTEL_SEC");
            Roles.add("LEADS");
          }
          if(role == "SECRETARY") {
            Roles.clear();
            Roles.add("LEADS");
          }
          return Scaffold(
              appBar: AppBar(
                title: const Text(
                  "Create Account",
                  style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                ),
                elevation: 0,
                backgroundColor: const Color(0xFF2B2E35),
              ),

              backgroundColor: const Color(0xFFDFDFDF),

              body: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FormText('Email-Id'),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
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
                              hintText: 'Enter hostel name',
                            ),
                            controller: rollController,
                            validator: (val) {
                              if(val == null || val.isEmpty) {
                                setState(() {
                                  emptyRollErr = "Hostel name can't be empty";
                                });
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),

                    errorMessages(emptyRollErr),

                    SizedBox(height: 20.0),

                    FormText("Select Role"),

                    SizedBox(height: 10.0),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(15,15,15,15),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10,0,10,0),
                            child: DropdownButton<String>(
                              hint: const Padding(
                                padding: EdgeInsets.fromLTRB(10,0,10,0),
                                child: Text("Select Role"),
                              ),
                              dropdownColor: Colors.white,
                              value: DropDownValue,
                              onChanged: (String? newValue) {
                                setState(() {
                                  DropDownValue = newValue!;
                                  print("inside SetState : $DropDownValue");
                                });
                                print("Outside SetaState : $DropDownValue");
                                },
                              items: Roles
                                  .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 15.0),
                    Mutation(
                        options:MutationOptions(
                          document: gql(createSuperUser),
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
                              onPressed: () {
                                runMutation({
                                  'createAccountInput' :{
                                    "roll": rollController.text,
                                    "role": DropDownValue,
                                  }
                                });
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
                              child: Text('Submit',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        })
                  ],
                ),
              )
          );
        }
        );
  }
}
