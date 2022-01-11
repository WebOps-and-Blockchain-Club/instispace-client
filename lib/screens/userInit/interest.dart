
import 'package:flutter/material.dart';

import 'package:client/services/Auth.dart';
import 'package:client/screens/userInit/interestWrap.dart';
import 'package:client/graphQL/auth.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:client/services/Client.dart';

class InterestPage extends StatefulWidget {
  final AuthService auth;
  String name;
  String phoneNumber;
  String hostelName;
  InterestPage({required this.auth,required this.name,required this.phoneNumber,required this.hostelName});

  @override
  _InterestPageState createState() => _InterestPageState();
}

class _InterestPageState extends State<InterestPage> {

  String getTags =authQuery().getTags;
  String updateUser =authQuery().updateUser;

  Map<String,List<String>> interest = {};

  Map<String,List<String>>? selectedInterest = {};

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
              interest.clear();
                if (result.hasException) {
                  return Text(result.exception.toString());
                }
                if (result.isLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                for (var i = 0; i < result.data!["getTags"].length; i++) {
                  interest.putIfAbsent(result.data!["getTags"][i]["category"].toString(),()=>[]);
                  interest[result.data!["getTags"][i]["category"]]!.add(result.data!["getTags"][i]["title"].toString());
                }
                print(result.data!["getTags"].length);
                print(result.data);
                print(interest);
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
                  Mutation(
                  options: MutationOptions(
                  document: gql(updateUser),
                  onCompleted: (dynamic resultData){
                  }
                  ),
                  builder: (
                  RunMutation runMutation,
                  QueryResult? result,
                  ){
                  if (result!.hasException) {
                  print(result.exception.toString());
                  }
                  if (result.isLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                  }
                  return ElevatedButton(onPressed: () {
                    runMutation({
                      'userInput' :{
                        'name': widget.name,
                        'interest':selectedInterest,
                        'hostel':widget.hostelName,
                      }
                    });
                    print('name:${widget.name},interest:${selectedInterest},hostel:${widget.hostelName}');
                    widget.auth.setisNewUser(false);
                    Navigator.pop(context);
                  }, child: Text(
                  'submit',
                  ));
                  }
                  )
                ],
              );
            }
          ),
        )
    );
  }
}
