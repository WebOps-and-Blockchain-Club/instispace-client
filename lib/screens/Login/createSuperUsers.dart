import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:client/graphQL/home.dart';

class CreateSuperUsers extends StatefulWidget {

  @override
  _CreateSuperUsersState createState() => _CreateSuperUsersState();
}

class _CreateSuperUsersState extends State<CreateSuperUsers> {

  String createSuperUser = homeQuery().createSuperUser;
  String getMe = homeQuery().getMe;
  static var role;
  List<String> Roles = ["LEADS","HAS","HOSTEL_SEC","MODERATOR"];
  late String DropDownValue ;
  TextEditingController rollController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
        document: gql(getMe),),
        builder: (QueryResult result, {fetchMore, refetch}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }
          if (result.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: Colors.blue[700],),
            );
          }
          role = result.data!["getMe"]["role"];
          print(role);
          if(role == "LEADS") {
            Roles.clear();
            Roles.add("Moderator");
            print(Roles);
          }
          else if(role == "HAS") {
            Roles.clear();
            Roles.add("Hostel Secretory");
          }
          DropDownValue =Roles[0];
          return Scaffold(
              appBar: AppBar(
                title: Text("Create Superusers",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0
                  ),),
                backgroundColor: Colors.deepPurpleAccent,
                elevation: 0.0,
              ),
              body: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [
                        0.1,
                        0.3,
                        0.4,
                        0.6,
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
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Email ID*',
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
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                  hintText: 'Enter email ID',
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.black, width: 1.0),
                                      borderRadius: BorderRadius.circular(20.0)
                                  )
                              ),
                              controller: rollController,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        'Select Role*',
                        style: TextStyle(
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: Colors.blue[200]
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10.0,0.0,10.0,0.0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              hint: Text("Select Role"),
                              dropdownColor: Colors.blue[100],
                              value: DropDownValue,
                              onChanged: (String? newValue) {
                                setState(() {
                                  DropDownValue = newValue!;
                                });
                                },
                              items: Roles
                                  .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Mutation(
                          options:MutationOptions(
                            document: gql(createSuperUser),
                          ),
                          builder: (
                              RunMutation runMutation,
                              QueryResult? result,
                              ) {
                            if (result!.hasException){
                              print(result.exception.toString());
                            }
                            if(result.isLoading){
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
                                    runMutation({
                                      'createAccountInput' :{
                                        "roll": rollController.text,
                                        "role": DropDownValue,
                                      }
                                    });
                                    },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        "Submit",
                                      style: TextStyle(color: Colors.white,fontSize: 18.0,fontWeight: FontWeight.w600),
                                    ),
                                  )
                              ),
                            );
                          })
                    ],
                  ),
                ),
              )
          );
        }
        );
  }
}
