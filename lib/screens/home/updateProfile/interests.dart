import 'dart:convert';

import 'package:client/services/Auth.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../graphQL/auth.dart';
import '../../../models/formErrormsgs.dart';
import '../../../models/tag.dart';
import '../../../widgets/text.dart';
import '../../userInit/interestWrap.dart';
import 'basicInfo.dart';

class EditInterests extends StatefulWidget {
  final String name;
  final String phoneNumber;
  final String hostelName;
  final String hostelId;
  EditInterests(
      { required this.name,
        required this.phoneNumber,
        required this.hostelName,
        required this.hostelId,
      });

  @override
  _EditInterestsState createState() => _EditInterestsState();
}

class _EditInterestsState extends State<EditInterests> {

  String getTags = authQuery().getTags;

  // String getTags =authQuery().getTags;
  String updateUser = authQuery().updateUser;

  Map<String, List<Tag>> interest = {};
  Map<String, List<Tag>>? selectedInterest = {};
  List selected = [];
  String interestsErr = "";
  String roll = '';
  String role="";
  String id = '';
  List<Tag> interests = [];
  final AuthService _auth = AuthService();
  @override
  void initState(){
    super.initState();
    _sharedPreference();

  }

  SharedPreferences? prefs;
  void _sharedPreference()async{
    prefs = await SharedPreferences.getInstance();
    print("prefs name");
    setState(() {
      roll = prefs!.getString('roll')!;
      role = prefs!.getString('role')!;
      id = prefs!.getString('id')!;
      var _interests = prefs!.getStringList("interests")!;
      for(var i=0;i<_interests.length;i++){
        var interest = jsonDecode(_interests[i]);
        interests.add(
            Tag(
                category: interest["category"], Tag_name: interest["title"], id: interest["id"]
            ));
        selectedInterest?.putIfAbsent("", () => interests);
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "Interests Page",
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

          body: Query(
              options: QueryOptions(
                document: gql(getTags),
              ),
              builder: (QueryResult result, {fetchMore, refetch}) {
                interest.clear();
                // selectedInterest!.clear();
                // selected.clear();
                if (result.hasException) {
                  return Text(result.exception.toString());
                }
                if (result.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                for (var i = 0; i < result.data!["getTags"].length; i++) {
                  interest.putIfAbsent(
                      result.data!["getTags"][i]["category"].toString(), () => []);
                  interest[result.data!["getTags"][i]["category"]]!.add(Tag(
                      Tag_name: result.data!["getTags"][i]["title"].toString(),
                      category: result.data!["getTags"][i]["category"].toString(),
                      id: result.data!["getTags"][i]["id"].toString()));
                }

                  interest.remove(selectedInterest?.values);
                return ListView(
                    children: [

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PageTitle("Please Select Interests", context),

                          SizedBox(height: 15.0),

                          interestWrap(
                              selectedInterest: selectedInterest,
                              interest: interest),

                          errorMessages(interestsErr),

                          Mutation(
                              options: MutationOptions(
                                  document: gql(updateUser),
                                  onCompleted: (dynamic resultData) {
                                    if(resultData["updateUser"] == true){
                                      List<String> interests = [];
                                      for (var element in selectedInterest!.values) {
                                        for(var i=0;i<element.length;i++){
                                          interests.add(jsonEncode(element[i]));
                                        }
                                      }
                                      // print("interest in edit : $interests");
                                      _auth.setMe(roll, widget.name, role, interests, id, widget.hostelName, widget.hostelId, widget.phoneNumber);
                                      Navigator.of(context).popAndPushNamed('/');
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                              content: Text("Profile updated successfully")
                                          )
                                      );
                                    }
                                  }),
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
                                        color: const Color(0xFF2B2E35),
                                        size: 20,
                                      ));
                                }
                                print(selectedInterest!.values.length);
                                // print(selectedInterest!.values.length);
                                // print(result.data);
                                return Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      selectedInterest!.forEach((key, value) {
                                        for (var i = 0; i < value.length; i++) {
                                          selected.add(value[i].id);
                                        }
                                      });
                                      print("selected : $selected");
                                      if(selected.length < 3) {
                                        setState(() {
                                          interestsErr = "Please select at least 3 interests";
                                        });
                                      }
                                      else {
                                        //ToDo runMutation
                                        runMutation({
                                          'userInput': {
                                            'name': widget.name,
                                            'interest': selected,
                                            'hostel': widget.hostelName,
                                            // "mobile": widget.phoneNumber
                                          }
                                        });
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
                              })
                        ],
                      ),
                    ]
                );
                // }

                // return Container(
                //   decoration: BoxDecoration(
                //       gradient: LinearGradient(colors: [
                //     Colors.deepPurpleAccent,
                //     Colors.blue,
                //     Colors.lightBlueAccent,
                //     Colors.lightBlueAccent,
                //     Colors.blueAccent,
                //   ], stops: [
                //     0.1,
                //     0.3,
                //     0.4,
                //     0.6,
                //     0.9,
                //   ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                //   child: Padding(
                //     padding: const EdgeInsets.all(20.0),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Text(
                //           "Please choose your interests*",
                //           style: TextStyle(
                //               color: Colors.white,
                //               fontWeight: FontWeight.bold,
                //               fontSize: 20.0),
                //         ),
                //         SizedBox(height: 20.0),
                //         SizedBox(
                //             height: 400,
                //             width: 400,
                //             child: ListView(children: [
                //               Container(
                //                   decoration: BoxDecoration(
                //                       color: Colors.blue[200],
                //                       borderRadius: BorderRadius.circular(20.0)),
                //                   child: interestWrap(
                //                       selectedInterest: selectedInterest,
                //                       interest: interest))
                //             ])),
                //         Center(
                //           child: SizedBox(
                //             width: 400,
                //             child: ElevatedButton(
                //                 style: ElevatedButton.styleFrom(
                //                     primary: Colors.blue[700],
                //                     shape: RoundedRectangleBorder(
                //                         borderRadius: BorderRadius.circular(30.0))),
                //                 onPressed: () {
                //                   widget.auth.setisNewUser(false);
                //                   Navigator.pop(context);
                //                 },
                //                 child: Padding(
                //                   padding: const EdgeInsets.all(8.0),
                //                   child: Text(
                //                     'Submit',
                //                     style: TextStyle(
                //                         color: Colors.white,
                //                         fontSize: 18.0,
                //                         fontWeight: FontWeight.w600),
                //                   ),
                //                 )),
                //           ),
                //         )
                //       ],
                //     ),
                //   ),
                // );
              }),
        ));
  }

}
