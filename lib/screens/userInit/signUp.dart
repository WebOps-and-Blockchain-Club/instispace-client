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
    'Select Hostel',
  ];
  late String _DropDownValue = 'Sindhu';
  final _formkey = GlobalKey<FormState>();

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
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          for (var i = 0; i < result.data!["getHostels"].length; i++) {
            Hostels.add(result.data!["getHostels"][i]["name"].toString());
          }
          // print(Hostels);
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "SignUp Journey",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              ),
              elevation: 0.0,
              backgroundColor: Colors.deepPurpleAccent,
            ),
            body: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Colors.deepPurpleAccent,
                Colors.blue,
                Colors.lightBlueAccent,
                Colors.lightBlueAccent,
                Colors.blueAccent
              ], stops: [
                0.1,
                0.3,
                0.4,
                0.6,
                0.9
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
              child: Padding(
                padding: EdgeInsets.all(20.0),
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
                                decoration: InputDecoration(
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
                      SizedBox(height: 10.0),
                      dropDown(
                          Hostels: Hostels,
                          dropDownValue: _DropDownValue,
                          callback: (val) => _DropDownValue = val),
                      SizedBox(height: 10.0),
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
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter Phone Number'),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30.0),
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
                                builder: (BuildContext context) =>
                                    InterestPage(auth: widget.auth)));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
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
            ),
          );
        });
  }
}
