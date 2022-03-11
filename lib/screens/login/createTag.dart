import 'package:client/widgets/formTexts.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:client/graphQL/home.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../models/formErrormsgs.dart';

class CreateTag extends StatefulWidget {

  @override
  State<CreateTag> createState() => _CreateTagState();
}

class _CreateTagState extends State<CreateTag> {
  ///Key
  final _formkey = GlobalKey<FormState>();

  ///GraphQL
  String createTag = homeQuery().createTag;

  ///Variables
  String emptyNameErr = '';
  String emptyCategoryErr = '';

  ///Controller
  TextEditingController tagNameController = TextEditingController();
  TextEditingController tagCategoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "Create Tag",
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
                  FormText("Tag Category"),
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
                            hintText: 'Enter tag category',
                          ),
                          controller: tagCategoryController,
                          validator: (val) {
                            if(val == null || val.isEmpty) {
                              setState(() {
                                emptyCategoryErr = "Tag category can't be empty";
                              });
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),

                  errorMessages(emptyCategoryErr),

                  SizedBox(
                    height: 20,
                  ),


                  FormText("Tag Name"),
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
                            hintText: 'Enter tag name',
                          ),
                          controller: tagNameController,
                          validator: (val) {
                            if(val == null || val.isEmpty) {
                              setState(() {
                                emptyNameErr = "Tag name can't be empty";
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
                  Mutation(
                  options: MutationOptions(
                    document: gql(createTag),
                    onCompleted: (dynamic resultData) {
                      if(resultData["createTag"]){
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
                          if (_formkey.currentState!.validate()) {
                            if (tagNameController.text.isNotEmpty && tagCategoryController.text.isNotEmpty) {
                              runMutation({
                                'tagInput': {
                                  "title": tagNameController.text,
                                  "category": tagCategoryController.text,
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


