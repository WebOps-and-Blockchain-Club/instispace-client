import 'package:client/graphQL/auth.dart';
import 'package:client/graphQL/home.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../models/formErrormsgs.dart';
import '../../../../widgets/formTexts.dart';
import '../../../userInit/dropDown.dart';

class CreateHostelContact extends StatefulWidget {
  final String userRole;
  final Refetch<Object?>? refetch;

  CreateHostelContact({required this.refetch,required this.userRole});

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
  String emptyTypeErr = "";
  String emptyNameErr = "";
  String emptyContactErr = "";

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
          title: const Text(
            "Create Hostel Contact",
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
              FormText("Select Hostel"),
              SizedBox(height: 10.0),
              dropDown(
                  Hostels: Hostels.keys.toList(),
                  dropDownValue: _DropDownValue,
                  callback: (val) => _DropDownValue = val),
              FormText("Post"),
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
                        hintText: 'Enter the post of the person',
                      ),
                      controller: typeController,
                      validator: (val) {
                        if(val == null || val.isEmpty) {
                          setState(() {
                            emptyTypeErr = "Post can't be empty";
                          });
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),

              errorMessages(emptyTypeErr),

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
                        hintText: 'Enter name',
                      ),
                      controller: nameController,
                      validator: (val) {
                        if(val == null || val.isEmpty) {
                          setState(() {
                            emptyNameErr = "Name can't be empty";
                          });
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),

              errorMessages(emptyNameErr),

              FormText('Contact'),
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
                        hintText: 'Enter contact details',
                      ),
                      controller: contactController,
                      validator: (val) {
                        if(val == null || val.isEmpty) {
                          setState(() {
                            emptyContactErr = "Contact can't be empty";
                          });
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),

              errorMessages(emptyContactErr),

              SizedBox(height: 30.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {},
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
                  Mutation(
                      options: MutationOptions(
                        document: gql(createHostelContacts),
                        onCompleted: (resultData){
                         if(resultData["createHostelContact"]) {
                           widget.refetch!();
                           Navigator.pop(context);
                           ScaffoldMessenger.of(context).showSnackBar(
                             const SnackBar(content: Text('Contact created')),
                           );
                         }
                         else{
                           ScaffoldMessenger.of(context).showSnackBar(
                             const SnackBar(content: Text('Contact not created')),
                           );
                         }
                        },
                          onError: (dynamic error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Contact not created, server error')),
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
                        return ElevatedButton(
                          onPressed: () {
                            if (_formkey.currentState!.validate()) {
                              if (nameController.text.isNotEmpty && contactController.text.isNotEmpty && typeController.text.isNotEmpty) {
                                var key = Hostels.keys.firstWhere((k) => k == _DropDownValue);
                                runMutation({
                                  'createContactInput': {
                                    "name": nameController.text,
                                    "type": typeController.text,
                                    "contact": contactController.text
                                  },
                                  'hostelId': Hostels[key],
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
                        );
                      }
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
    );
  }
}
