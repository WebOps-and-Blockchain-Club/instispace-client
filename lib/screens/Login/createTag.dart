import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:client/graphQL/home.dart';

class CreateTag extends StatelessWidget {

  final _formkey = GlobalKey<FormState>();

  String createTag = homeQuery().createTag;
  TextEditingController tagController = TextEditingController();


  @override
  Widget build(BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "Create Tag",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0
                ),),
              elevation: 0.0,
              backgroundColor: Colors.deepPurpleAccent,
            ),
            body: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [
                      0.1,
                      0.3,
                      0.5,
                      0.7,
                      0.9,
                    ],
                    colors: [
                      Colors.deepPurpleAccent,
                      Colors.blue,
                      Colors.lightBlueAccent,
                      Colors.lightBlueAccent,
                      Colors.blueAccent,
                    ],
                  )
              ),
              child: Form(
                key: _formkey,
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tag Name*',
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
                              controller: tagController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                  hintText: "Enter tag name",
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
                        document: gql(createTag),
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
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))
                            ),
                            onPressed: () {
                              if (_formkey.currentState!.validate()) {
                                runMutation({
                                  'tagInput': {
                                    "title": tagController.text,
                                  }
                                });
                                Navigator.pushNamed(context, '/');
                              }
                              },
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Submit",
                                style: TextStyle(
                                    color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600
                                ),),
                            )
                          ),
                        );
                      }
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}


