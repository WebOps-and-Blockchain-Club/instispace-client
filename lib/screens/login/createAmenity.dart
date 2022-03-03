import 'package:client/graphQL/auth.dart';
import 'package:client/graphQL/home.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../userInit/dropDown.dart';

class CreateHostelAmenity extends StatefulWidget {
  const CreateHostelAmenity({Key? key}) : super(key: key);

  @override
  _CreateHostelAmenityState createState() => _CreateHostelAmenityState();
}

class _CreateHostelAmenityState extends State<CreateHostelAmenity> {
  String getHostels = authQuery().getHostels;
  String createAmenity = homeQuery().createAmenity;
  // List<String> Hostels = [];
  Map <String, String> Hostels = {};
  late String _DropDownValue;
  set DropDownValue(String value) => setState(() => _DropDownValue = value);
  final _formkey = GlobalKey<FormState>();

  TextEditingController namecontroller = TextEditingController();
  TextEditingController desccontroller = TextEditingController();


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
          title: Text("Create Hostel Amenity", style: TextStyle(fontWeight: FontWeight.bold),),
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
                  'Amenity Name*',
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
                        controller: namecontroller,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter Amenity name",
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
                  'Amenity Description*',
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
                        controller: desccontroller,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter Amenity Description",
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
                      document: gql(createAmenity),
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
                                'createAmenityInput': {
                                  "name": namecontroller.text,
                                  "description": desccontroller.text,
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
    });
  }
}
