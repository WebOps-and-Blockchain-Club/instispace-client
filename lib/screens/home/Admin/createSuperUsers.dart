import 'package:client/graphQL/auth.dart';
import 'package:client/screens/home/searchCard.dart';
import 'package:client/screens/userInit/dropDown.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:client/graphQL/home.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../models/formErrormsgs.dart';
import '../../../widgets/formTexts.dart';

class CreateSuperUsers extends StatefulWidget {

  @override
  _CreateSuperUsersState createState() => _CreateSuperUsersState();
}

class _CreateSuperUsersState extends State<CreateSuperUsers> {

  String createAccount = homeQuery().createAccount;
  String getMe = homeQuery().getMe;
  String getHostels = authQuery().getHostels;
  static var role;
  String emptyRollErr = "";
  List<String> Roles = ["HAS","HOSTEL_SEC","SECRETARY","LEADS"];
  Map<String,String> hostels = {};
  String dropDownValueRole  = "HAS";
  late String dropDownValueHostel;
  late String? hostelId;
  TextEditingController rollController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(getHostels)
      ),
      builder: (QueryResult result, {fetchMore, refetch}) {

        if (result.hasException) {
          print(result.exception.toString());
        }
        if (result.isLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.blue[700],
            ),
          );
        }

        hostels.clear();
        for (var i = 0; i < result.data!["getHostels"].length; i++) {
          hostels.putIfAbsent(result.data!["getHostels"][i]["name"], () => result.data!["getHostels"][i]["id"]);
        }

        dropDownValueHostel = hostels.keys.first;
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
                                  hintText: 'Enter email id',
                                ),
                                controller: rollController,
                                validator: (val) {
                                  if(val == null || val.isEmpty) {
                                    setState(() {
                                      emptyRollErr = "Please enter email id";
                                    });
                                  }
                                  else if (!isValidEmail(val)) {
                                    setState(() {
                                      emptyRollErr = "Please enter a valid email id";
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
                                  value: dropDownValueRole,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropDownValueRole = newValue!;
                                      print("inside SetState : $dropDownValueRole");
                                    });
                                    print("Outside SetaState : $dropDownValueRole");
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

                        if(dropDownValueRole == "HOSTEL_SEC")
                        dropDown(Hostels: hostels.keys.toList(), dropDownValue: dropDownValueHostel, callback: (val) => dropDownValueHostel = val),

                        SizedBox(height: 15.0),
                        Mutation(
                            options:MutationOptions(
                              document: gql(createAccount),
                              onCompleted: (resultData) {
                                if(resultData["createAccount"]) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("Account created successfully")
                                      )
                                  );
                                }
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
                                    child: LoadingAnimationWidget.threeRotatingDots(
                                      color: const Color(0xFF2B2E35),
                                      size: 20,
                                    ));
                              }
                              return Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    if(formKey.currentState!.validate()) {
                                      var key = hostels.keys.firstWhere((k) =>
                                      k == dropDownValueHostel);
                                      if(dropDownValueRole == "HOSTEL_SEC") {
                                        hostelId = hostels[key];
                                      }
                                      else{
                                        hostelId = null;
                                      }
                                      if(isValidEmail(rollController.text)) {
                                        runMutation({
                                          "createAccountInput": {
                                            "roll": rollController.text,
                                            "role": dropDownValueRole
                                          },
                                          "hostelId": hostelId
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
                                    child: Text('Submit',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
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
      },
    );
  }
  bool isValidEmail(String email) {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }
}
