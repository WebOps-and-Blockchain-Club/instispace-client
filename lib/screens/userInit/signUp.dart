import 'package:client/screens/userInit/interest.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:client/services/Auth.dart';
import 'package:client/graphQL/auth.dart';
import 'package:client/screens/userInit/dropDown.dart';

import '../../models/formErrormsgs.dart';
import '../../widgets/formTexts.dart';

class SignUp extends StatefulWidget {
  final AuthService auth;
  SignUp({required this.auth});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  ///GraphQL
  String getHostels = authQuery().getHostels;

  ///Variables
  List<String> Hostels = [];
  String _DropDownValue = "Select Hostel";
  final _formkey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController PhoneNumberController = TextEditingController();
  set DropDownValue(String value) => setState(() => _DropDownValue = value);
  String emptyNameErr = "";
  String emptyContactErr = "";
  String emptyHostelErr = '';
  bool validPhone = false;

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: gql(getHostels),
        ),
        builder: (QueryResult result, {fetchMore, refetch}) {
          // print('Hostel:$Hostels');
          Hostels.clear();
          if (result.hasException) {
            return Text(result.exception.toString());
          }
          if (result.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          Hostels.add("Select Hostel");
          for (var i = 0; i < result.data!["getHostels"].length; i++) {
            Hostels.add(result.data!["getHostels"][i]["name"].toString());
          }
          _DropDownValue = Hostels[0];
          // print(Hostels);
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "Sign Up",
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

            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FormText('Name'),
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
                              hintText: 'Enter your name',
                            ),
                            controller: nameController,
                            validator: (val) {
                              if(val == null || val.isEmpty) {
                                setState(() {
                                  emptyNameErr = "Please enter name";
                                });
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),

                    errorMessages(emptyNameErr),

                    const SizedBox(height: 10.0),

                    FormText('Contact number (optional)'),
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
                              hintText: 'Enter Contact number',
                            ),
                            controller: PhoneNumberController,
                            validator: (val) {
                              if(val != null && val.isNotEmpty) {
                                if (!isValidNumber("+91$val")) {
                                  setState(() {
                                    emptyContactErr = "Please enter a valid number";
                                  });
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),

                    errorMessages(emptyContactErr),

                    dropDown(
                        Hostels: Hostels,
                        dropDownValue: _DropDownValue,
                        callback: (val) => _DropDownValue = val),

                    errorMessages(emptyHostelErr),
                    const SizedBox(height: 10.0),

                    const SizedBox(height: 30.0),
                    Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formkey.currentState!.validate()) {
                              if(PhoneNumberController.text.isNotEmpty && isValidNumber("+91${PhoneNumberController.text}")) {
                                setState(() {
                                  validPhone = true;
                                });
                              }
                              if(PhoneNumberController.text.isEmpty) {
                                setState(() {
                                  validPhone = true;
                                });
                              }
                              if(_DropDownValue == "Select Hostel") {
                                setState(() {
                                  emptyHostelErr = "Please select your hostel";
                                });
                              }
                              if(nameController.text.isNotEmpty) {
                                setState(() {
                                  emptyNameErr = "";
                                });
                              }
                              if (nameController.text.isNotEmpty && _DropDownValue != "Select Hostel" && validPhone) {
                                setState(() {
                                  emptyNameErr = "";
                                  emptyContactErr = "";
                                });
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) => InterestPage(
                                      auth: widget.auth,
                                      name: nameController.text,
                                      phoneNumber: PhoneNumberController.text,
                                      hostelName: _DropDownValue,
                                    )));
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
                            child: Text('Select Interests',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  bool isValidNumber (String number) {
    return RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(number);
  }
}
