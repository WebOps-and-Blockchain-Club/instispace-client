import 'package:client/graphQL/auth.dart';
import 'package:client/graphQL/home.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../userInit/dropDown.dart';

class CreateHostelContact extends StatefulWidget {
  const CreateHostelContact({Key? key}) : super(key: key);

  @override
  _CreateHostelContactState createState() => _CreateHostelContactState();
}

class _CreateHostelContactState extends State<CreateHostelContact> {

  String getHostels = authQuery().getHostels;
  String createHostelContacts = homeQuery().createHostelContact;

  Map <String, String> Hostels = {};
  late String _DropDownValue;
  set DropDownValue(String value) => setState(() => _DropDownValue = value);
  final _formkey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController contactController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
        document: gql(getHostels),
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
      for (var i = 0; i < result.data!["getHostels"].length; i++) {
        Hostels.putIfAbsent(result.data!["getHostels"][i]["name"], () => result.data!["getHostels"][i]["id"]);
      }

      _DropDownValue = Hostels.keys.first;
      return Scaffold(
        appBar: AppBar(
          title: Text("Create Hostel Contacts",style: TextStyle(fontWeight: FontWeight.bold),),
          elevation: 0.0,
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Hostel*',
                  style: TextStyle(
                      color: Colors.blue[900],
                      fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 10.0),
                dropDown(
                    Hostels: Hostels.keys.toList(),
                    dropDownValue: _DropDownValue,
                    callback: (val) => _DropDownValue = val),
                Text(
                  'Post*',
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
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        controller: typeController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter the post of the person",
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.black, width: 1.0),
                                borderRadius: BorderRadius.circular(20.0)
                            )
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "This field can't be empty";
                          }
                        },
                      ),
                    ),
                  ),
                ),
                Text(
                  'Name*',
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
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        controller: nameController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter name",
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.black, width: 1.0),
                                borderRadius: BorderRadius.circular(20.0)
                            )
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "This field can't be empty";
                          }
                        },
                      ),
                    ),
                  ),
                ),
                Text(
                  'Contact*',
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
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        controller: contactController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter contact details",
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.black, width: 1.0),
                                borderRadius: BorderRadius.circular(20.0)
                            )
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "This field can't be empty";
                          }
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30.0),
                Mutation(
                    options: MutationOptions(
                      document: gql(createHostelContacts),
                    ),
                    builder: (
                        RunMutation runMutation,
                        QueryResult? result,
                        ) {
                      if (result!.hasException) {
                        print(result.exception.toString());
                      }
                      if (result.isLoading) {
                        return Center(
                          child: CircularProgressIndicator(color: Colors.blue[700],),
                        );
                      }
                      return SizedBox(
                        width: 400.0,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.blue[700],
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))
                          ),
                          onPressed: () {
                            if (_formkey.currentState!.validate()) {
                              var key = Hostels.keys.firstWhere((k) => k == _DropDownValue);
                              runMutation({
                                'createContactInput': {
                                  "name": nameController.text,
                                  "type": typeController.text,
                                  "contact": contactController.text
                                },
                                'hostelId': Hostels[key],
                              });
                              Navigator.pushNamed(context, '/');
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Submit", style: TextStyle(color: Colors.white,fontSize: 18.0,fontWeight: FontWeight.w600),),
                          ),
                        ),
                      );
                    }
                ),
              ],
            ),
          ),
        ),
      );
    }
    );
  }
}
