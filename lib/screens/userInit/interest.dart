import 'package:client/models/formErrormsgs.dart';
import 'package:client/widgets/formTexts.dart';
import 'package:client/widgets/text.dart';
import 'package:flutter/material.dart';

import 'package:client/services/Auth.dart';
import 'package:client/screens/userInit/interestWrap.dart';
import 'package:client/graphQL/auth.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:client/models/tag.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class InterestPage extends StatefulWidget {
  final AuthService auth;
  final String name;
  final String phoneNumber;
  final String hostelName;
  InterestPage(
      {required this.auth,
      required this.name,
      required this.phoneNumber,
      required this.hostelName});

  @override
  _InterestPageState createState() => _InterestPageState();
}

class _InterestPageState extends State<InterestPage> {
  String getTags = authQuery().getTags;

  // String getTags =authQuery().getTags;
  String updateUser = authQuery().updateUser;

  Map<String, List<Tag>> interest = {};
  Map<String, List<Tag>>? selectedInterest = {};
  List selected = [];
  String interestsErr = "";

  @override
  Widget build(BuildContext context) {
    print(widget.hostelName);
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
                            print("resultData in interest: $resultData");
                            if(resultData["updateUser"]){
                              widget.auth.setisNewUser(false);
                              Navigator.pop(context);
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
                        return Center(
                          child: ElevatedButton(
                              onPressed: () {
                                print("selectedInterests2 : $selectedInterest");
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
                                  runMutation({
                                    'userInput': {
                                      'name': widget.name,
                                      'interest': selected,
                                      'hostel': widget.hostelName,
                                    }
                                  });
                                  print(
                                      'name:${widget.name},interest:${selected},hostel:${widget.hostelName}');                                }
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
