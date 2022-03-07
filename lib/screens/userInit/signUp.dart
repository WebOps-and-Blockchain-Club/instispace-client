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

  List<String> Hostels = [];
  late String _DropDownValue;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController PhoneNumberController = TextEditingController();
  set DropDownValue(String value) => setState(() => _DropDownValue = value);
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
          print(result.data);
          for (var i = 0; i < result.data!["getHostels"].length; i++) {
            // print(result.data!["getHostels"].length);
            // print(i);
            Hostels.add(result.data!["getHostels"][i]["name"].toString());
          }
          _DropDownValue = Hostels[0];
          // print(Hostels);
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "SignUp Journey",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              ),
              elevation: 0.0,
              backgroundColor: Colors.deepPurpleAccent,
              automaticallyImplyLeading: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 450.0,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: Colors.blue[200]),
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                          child: TextFormField(
                              decoration: const InputDecoration(
                                  hintText: 'Enter Your Name',
                                  border: InputBorder.none),
                              cursorColor: Colors.blue[700],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "This field can't be empty";
                                }
                              }),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    dropDown(
                        Hostels: Hostels,
                        dropDownValue: _DropDownValue,
                        callback: (val) => _DropDownValue = val),
                    const SizedBox(height: 10.0),
                    SizedBox(
                      width: 450.0,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: Colors.blue[200]),
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                          child: TextFormField(
                            cursorColor: Colors.blue[700],
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter Phone Number'),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    Center(
                        child: SizedBox(
                      width: 400.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue[700],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0))),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => InterestPage(
                                    auth: widget.auth,
                                    name: nameController.text,
                                    phoneNumber: PhoneNumberController.text,
                                    hostelName: _DropDownValue,
                                  )));
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Fill Interests',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
