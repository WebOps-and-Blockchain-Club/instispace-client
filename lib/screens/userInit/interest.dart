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
            title: Text('Interests Page'),
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
              return Column(
                children: [
                  Text("Please choose your interests"),
                  SizedBox(height: 15.0),
                  SizedBox(
                      height: 400,
                      width: 400,
                      child: ListView(
                          children: [
                            interestWrap(selectedInterest: selectedInterest, interest: interest)
                          ]
                      )
                  ),
                  ElevatedButton(onPressed: () {
                    widget.auth.setisNewUser(false);
                    Navigator.pop(context);
                  }, child: Text(
                    'submit',
                  ))
                ],
              );
            }
          ),
        )
    );
  }
}
