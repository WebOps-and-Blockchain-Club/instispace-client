import 'package:client/screens/userInit/interest.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:client/services/Auth.dart';

import 'package:client/graphQL/auth.dart';
import 'package:client/screens/userInit/dropDown.dart';


class SignUp extends StatefulWidget {
  final AuthService auth;
  SignUp({required this.auth});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  String getHostels = authQuery().getHostels;

  List<String> Hostels = [
  ];
  late String _DropDownValue ;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController PhoneNumberController = TextEditingController();
  set DropDownValue(String value) => setState(() => _DropDownValue = value);
  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: gql(getHostels),),
        builder: (QueryResult result, {fetchMore, refetch}) {
          // print('Hostel:$Hostels');
          Hostels.clear();
            if (result.hasException) {
              return Text(result.exception.toString());
            }
            if (result.isLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            print(result.data);
            for (var i = 0; i < result.data!["getHostels"].length; i++) {
              // print(result.data!["getHostels"].length);
              // print(i);
              Hostels.add(result.data!["getHostels"][i]["name"].toString());
            }
            _DropDownValue=Hostels[0];
          // print(Hostels);
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "SignUp Journey",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              backgroundColor: Color(0xFFE6CCA9),
            ),
            body: Padding(
              padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: nameController,
                        decoration: InputDecoration(
                            hintText: 'Enter Your Name',
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                const BorderSide(color: Colors.black,
                                    width: 1.0),
                                borderRadius: BorderRadius.circular(20.0))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "This field can't be empty";
                          }
                        }
                    ),
                    SizedBox(height: 5.0),
                    dropDown( Hostels: Hostels,dropDownValue: _DropDownValue,callback: (val) => _DropDownValue=val),
                    SizedBox(height: 10.0),
                    TextFormField(
                      controller: PhoneNumberController,
                      decoration: InputDecoration(
                          hintText: 'Enter Phone Number'
                      ),
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (BuildContext context)=> InterestPage(auth: widget.auth,name: nameController.text,phoneNumber: PhoneNumberController.text,hostelName: _DropDownValue,)));
                          },
                        child: Text('fill interests'),
                      ),
                    ),
                  ],
                ),),
            ),
          );
        }
    );
    }
  }
