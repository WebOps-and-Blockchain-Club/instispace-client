import 'package:client/graphQL/hostel.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../graphQL/auth.dart';
import '../../../../models/formErrormsgs.dart';
import '../../../../widgets/formTexts.dart';
import '../../../userInit/dropDown.dart';

class UpdateAmenity extends StatefulWidget {
  const UpdateAmenity({Key? key}) : super(key: key);

  @override
  _UpdateAmenityState createState() => _UpdateAmenityState();
}

class _UpdateAmenityState extends State<UpdateAmenity> {

  ///GraphQL
  String getHostels = authQuery().getHostels;
  String updateAmenity = hostelQM().updateAmenity;

  ///Variables
  // List<String> Hostels = [];
  Map <String, String> Hostels = {};
  late String _DropDownValue;
  set DropDownValue(String value) => setState(() => _DropDownValue = value);
  String emptyNameErr = '';
  String emptyDescErr = '';
  final _formkey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
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
              title: const Text(
                "Create Hostel Amenity",
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
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FormText('Amenity Name'),
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
                            hintText: 'Enter Amenity name',
                          ),
                          controller: nameController,
                          validator: (val) {
                            if(val == null || val.isEmpty) {
                              setState(() {
                                emptyNameErr = "Amenity name can't be empty";
                              });
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),

                  errorMessages(emptyNameErr),

                  SizedBox(
                    height: 20,
                  ),
                  FormText('Amenity Description'),
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
                            hintText: 'Enter Amenity Description',
                          ),
                          controller: descController,
                          validator: (val) {
                            if(val == null || val.isEmpty) {
                              setState(() {
                                emptyDescErr = "Amenity description can't be empty";
                              });
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),

                  errorMessages(emptyDescErr),

                  SizedBox(
                    height: 20,
                  ),

                  FormText("Select Hostel"),
                  SizedBox(height: 15.0),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: dropDown(
                        Hostels: Hostels.keys.toList(),
                        dropDownValue: _DropDownValue,
                        callback: (val) => _DropDownValue = val),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  Mutation(
                      options: MutationOptions(
                        document: gql(updateAmenity),
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
                        return Center(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formkey.currentState!.validate()) {
                                if (nameController.text.isNotEmpty &&
                                    descController.text.isNotEmpty) {
                                  var key = Hostels.keys.firstWhere((k) =>
                                  k == _DropDownValue);
                                  runMutation({
                                    'updateAmenityInput': {
                                      "name": nameController.text,
                                      "description": descController.text,
                                    },
                                    'amenityId': Hostels[key],
                                  });
                                  Navigator.pushNamed(context, '/');
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
                      }
                  ),
                ],
              ),
            ),
          );
        });
  }
}
