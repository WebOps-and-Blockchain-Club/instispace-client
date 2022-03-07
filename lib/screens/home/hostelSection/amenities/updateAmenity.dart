import 'package:client/graphQL/hostel.dart';
import 'package:client/models/hostelProfile.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../graphQL/auth.dart';
import '../../../../models/formErrormsgs.dart';
import '../../../../widgets/formTexts.dart';
import '../../../userInit/dropDown.dart';

class UpdateAmenity extends StatefulWidget {

  final Amenities amenities;
  final Refetch<Object?>? refetch;
  UpdateAmenity({required this.amenities,required this.refetch});
  @override
  _UpdateAmenityState createState() => _UpdateAmenityState();
}

class _UpdateAmenityState extends State<UpdateAmenity> {

  ///GraphQL
  String getHostels = authQuery().getHostels;
  String updateAmenity = hostelQM().updateAmenity;

  ///Variables
  Map <String, String> Hostels = {};
  late String _DropDownValue;
  set DropDownValue(String value) => setState(() => _DropDownValue = value);
  String emptyNameErr = '';
  String emptyDescErr = '';

  ///Key
  final _formkey = GlobalKey<FormState>();

  ///Controllers
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

          _DropDownValue = widget.amenities.hostel;
          nameController.text = widget.amenities.name;
          descController.text = widget.amenities.description;

          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "Update Hostel Amenity",
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

                  ///Amenity Name
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

                  ///error in Amenity name
                  errorMessages(emptyNameErr),

                  const SizedBox(
                    height: 20,
                  ),

                  ///Amenity Description
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

                  ///error in description
                  errorMessages(emptyDescErr),

                  const SizedBox(
                    height: 20,
                  ),

                  ///Hostels dropdown
                  FormText("Select Hostel"),
                  const SizedBox(height: 15.0),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: dropDown(
                        Hostels: Hostels.keys.toList(),
                        dropDownValue: _DropDownValue,
                        callback: (val) => _DropDownValue = val),
                  ),

                  const SizedBox(
                    height: 20,
                  ),


                  ///discard and submit button row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ///Discard Button
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
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
                          child: Text('Discard',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      ///Submit Button
                      Mutation(
                          options: MutationOptions(
                            document: gql(updateAmenity),
                            onCompleted: (resultData) {
                              print(resultData["updateAmenity"]);
                              if(resultData["updateAmenity"]){
                                widget.refetch!();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Amenity updated')),
                                );
                              }
                              else{
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Amenity updating failed')),
                                );
                              }
                            },
                              onError: (dynamic error){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Post updating failed,server error')),
                                );
                              }
                          ),
                          builder: (
                              RunMutation runMutation,
                              QueryResult? result,
                              ) {
                            if (result!.hasException) {
                              print(result.exception.toString());
                            }

                              if(result.isLoading){
                                return Center(
                                    child: LoadingAnimationWidget.threeRotatingDots(
                                      color: Color(0xFF2B2E35),
                                      size: 20,
                                    ));
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
                                        'amenityId': widget.amenities.id,
                                      });
                                      Navigator.pop(context);
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
                ],
              ),
            ),
          );
        });
  }
}
