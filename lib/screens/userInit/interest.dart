
import 'package:flutter/material.dart';

import 'package:client/services/Auth.dart';
import 'package:client/screens/userInit/interestWrap.dart';
import 'package:client/graphQL/auth.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:client/models/tag.dart';


class InterestPage extends StatefulWidget {
  final AuthService auth;
  final String name;
  final String phoneNumber;
  final String hostelName;
  InterestPage({required this.auth,required this.name,required this.phoneNumber,required this.hostelName});

  @override
  _InterestPageState createState() => _InterestPageState();
}

class _InterestPageState extends State<InterestPage> {

  String getTags =authQuery().getTags;
  String updateUser =authQuery().updateUser;

  Map<String,List<Tag>> interest = {};

  Map<String,List<Tag>>? selectedInterest ={};
  List selected =[];
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
              selectedInterest!.clear();
              selected.clear();
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
                  interest[result.data!["getTags"][i]["category"]]!.add(Tag(Tag_name: result.data!["getTags"][i]["title"].toString(),category: result.data!["getTags"][i]["category"].toString(),id: result.data!["getTags"][i]["id"].toString()));
                }
                // print(result.data!["getTags"].length);
                // print(result.data);
                // print(interest);
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

                  // print(selectedInterest!.values.length);
                  // print(result.data);
                  return ElevatedButton(onPressed: (){
                    print("selectedInterests2 : $selectedInterest");
                    print("selected : $selected");
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
