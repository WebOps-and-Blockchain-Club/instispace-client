import 'package:flutter/material.dart';
import 'package:client/graphQL/home.dart';
import 'package:graphql_flutter/graphql_flutter.dart';


class UserPage extends StatelessWidget {

  List<String> interest = [];

  String getMe = homeQuery().getMe;

  static var name;
  static var hostel;
  static var roll;


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
          child: CircularProgressIndicator(),
        );
      }
      name = result.data!["getMe"]["name"];
      hostel = result.data!["getMe"]["hostel"]["name"];
      roll = result.data!["getMe"]["roll"];
      for (var i = 0; i < result.data!.length; i++) {
        interest.add(result.data!["getMe"]["interest"][i]["title"].toString());
      }
      print(interest);
      print(name);
      print(hostel);
      print(roll);

      return Scaffold(
        appBar: AppBar(
          title: Text("User Profile",
            style: TextStyle(
                color: Colors.white
            ),),
          backgroundColor: Color(0xFFE6CCA9),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(name.toString()),
            Text(roll.toString()),
            Text(hostel.toString()),
            SizedBox(
              height: 100.0,
              width: 80.0,
              child: ListView(
                  children: interest.map((s) =>
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: MaterialButton(
                          //shape,color etc...
                          onPressed: () {},
                          child: Text(s),
                          color: Colors.grey,
                        ),
                      )).toList()
              ),
            )
          ],
        ),
      );
     }
    );
  }
}
