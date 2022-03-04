import 'package:client/models/formErrormsgs.dart';
import 'package:client/widgets/formTexts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:client/graphQL/home.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CreateHostel extends StatefulWidget {

  @override
  State<CreateHostel> createState() => _CreateHostelState();
}

class _CreateHostelState extends State<CreateHostel> {
  final formkey = GlobalKey<FormState>();

  ///GraphQL
  String createHostel = homeQuery().createHostel;

  ///Variable
  String emptyHostelErr = '';

  ///Controller
  TextEditingController hostelController = TextEditingController();

  @override
  Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Create Hostel",
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
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormText('Hostel Name'),
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
                          hintText: 'Enter hostel name',
                        ),
                        controller: hostelController,
                        validator: (val) {
                          if(val == null || val.isEmpty) {
                            setState(() {
                              emptyHostelErr = "Hostel name can't be empty";
                            });
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),

                errorMessages(emptyHostelErr),

                SizedBox(
                  height: 20,
                ),

                Mutation(
                options: MutationOptions(
                document: gql(createHostel),
                  onCompleted: (dynamic resultData) {
                  if(resultData["createHostel"]){
                    Navigator.pushNamed(context, '/');
                  }
                  }
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
                        child: LoadingAnimationWidget.threeRotatingDots(
                          color: const Color(0xFF2B2E35),
                          size: 20,
                        ));
                  }
                  return Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          if(hostelController.text.isNotEmpty) {
                            print(
                                "formKey: ${formkey.currentState!.validate()}");
                            runMutation({
                              'createHostelInput': {
                                "name": hostelController.text,
                              }
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
                }
                ),
              ],
            ),
          ),
        );
      }
}


