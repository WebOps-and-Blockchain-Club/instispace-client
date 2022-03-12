import 'package:client/graphQL/updateRole.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../models/formErrormsgs.dart';

class UpdateRole extends StatefulWidget {
  const UpdateRole({Key? key}) : super(key: key);

  @override
  _UpdateRoleState createState() => _UpdateRoleState();
}

class _UpdateRoleState extends State<UpdateRole> {

  ///GraphQL
  String updateRole = UpdateRoles().updateRole;

  ///Controller
  TextEditingController rollController = TextEditingController();

  ///Variables
  String emptyRollErr = "";

  ///Keys
  final formkey = GlobalKey<FormState>();

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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
                "Roll number",
              style: TextStyle(
                color: Color(0xFF2B2E35),
                fontSize: 24,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
              child: SizedBox(
                height: 45,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0,0,0,0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(8,5,0,8),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      hintText: 'Enter roll number',
                    ),
                    controller: rollController,
                    validator: (val) {
                      if(val == null || val.isEmpty) {
                        setState(() {
                          emptyRollErr = "Please enter roll number of user whose role you want to update";
                        });
                      }
                      else if (!isValidRoll(val.toUpperCase())) {
                        setState(() {
                          emptyRollErr = "Please enter a valid username";
                        });
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),

            errorMessages(emptyRollErr),

            Mutation(
                options: MutationOptions(
                    document: gql(updateRole),
                    onCompleted: (dynamic resultData) {
                      if(resultData["updateRole"]){
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Role updated successfully")
                          )
                        );
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
                          if(rollController.text.isNotEmpty && isValidRoll(rollController.text.toUpperCase())) {
                            runMutation({
                              'moderatorInput': {
                                "roll": rollController.text.toUpperCase(),
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
  bool isValidRoll (String roll) {
    return RegExp(
        r'\b([a-zA-Z]{2,2}[0-9]{2,2}[a-zA-Z][0-9]{3,3})\b')
        .hasMatch(roll);
  }
}
