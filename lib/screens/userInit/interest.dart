import 'package:flutter/material.dart';

import 'package:client/services/Auth.dart';
import 'package:client/screens/userInit/interestWrap.dart';
import 'package:client/graphQL/auth.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:client/services/Client.dart';

class InterestPage extends StatefulWidget {
  final AuthService auth;
  InterestPage({required this.auth});

  @override
  _InterestPageState createState() => _InterestPageState();
}

class _InterestPageState extends State<InterestPage> {

  String getTags =authQuery().getTags;

  List<String> interest = [
  ];

  List<String> selectedInterest = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
                'Interests Page',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20.0
              ),
            ),
            elevation: 0.0,
            backgroundColor: Colors.deepPurpleAccent,
          ),
          body: Query(
            options: QueryOptions(
            document: gql(getTags),),
            builder: (QueryResult result, {fetchMore, refetch}) {
              if (interest.isEmpty) {
                if (result.hasException) {
                  return Text(result.exception.toString());
                }
                if (result.isLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                for (var i = 0; i < result.data!.length; i++) {
                  interest.add(
                      result.data!["getTags"][i]["title"].toString());
                }
              };
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.deepPurpleAccent,
                      Colors.blue,
                      Colors.lightBlueAccent,
                      Colors.lightBlueAccent,
                      Colors.blueAccent,
                    ],
                    stops: [
                      0.1,
                      0.3,
                      0.4,
                      0.6,
                      0.9,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter
                  )
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          "Please choose your interests*",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          fontSize: 20.0
                        ),
                      ),
                      SizedBox(height: 20.0),
                      SizedBox(
                          height: 400,
                          width: 400,
                          child: ListView(
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blue[200],
                                        borderRadius: BorderRadius.circular(20.0)
                                    ),
                                  child: interestWrap(
                                        selectedInterest: selectedInterest, interest: interest
                                    )
                                )
                              ]
                          )
                      ),
                      Center(
                        child: SizedBox(
                          width: 400,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue[700],
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))
                            ),
                              onPressed: () {
                                widget.auth.setisNewUser(false);
                                Navigator.pop(context);
                                },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Submit',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                              )
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
          ),
        )
    );
  }
}
