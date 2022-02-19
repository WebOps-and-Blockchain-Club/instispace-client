import 'package:flutter/material.dart';
import 'package:client/graphQL/home.dart';
import 'package:graphql_flutter/graphql_flutter.dart';


class UserPage extends StatelessWidget {

  List<String> interest = [];

  String getMe = homeQuery().getMe;

  late String name;
  late String hostelName;
  late String roll;


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
        return Scaffold(
          appBar: AppBar(
            title: Text("Profile",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            backgroundColor: Color(0xFF5451FD),
            automaticallyImplyLeading: false,
          ),
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
      name = result.data!["getMe"]["name"];
      hostelName = result.data!["getMe"]["hostel"]["name"];
      roll = result.data!["getMe"]["roll"];
      for (var i = 0; i < result.data!.length; i++) {
        interest.add(result.data!["getMe"]["interest"][i]["title"].toString());
      }
      print(interest);
      print(name);
      print(hostelName);
      print(roll);

      return Scaffold(
        appBar: AppBar(
          title: Text("Profile",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          backgroundColor: Color(0xFF5451FD),
          automaticallyImplyLeading: false,
        ),

        //UI
        body: SafeArea(
          child: Column(
            children: [
              //Demographics
              Center(
                child: Column(
                  children: [
                    //User Name
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 15, 5, 0),
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4151E5),
                        ),
                      ),
                    ),

                    //Roll Number
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                      child: Text(
                        roll,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF4151E5),
                        ),
                      ),
                    ),

                    //Hostel Name
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: Text(
                        "${hostelName} Hostel",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF4151E5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //Tags Box
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                child: SizedBox(
                  // height: MediaQuery
                  //   .of(context)
                  //   .size
                  //   .height * 0.20,
                  // width: MediaQuery
                  //     .of(context)
                  //     .size
                  //     .width * 0.25,

                  child: Container(
                    width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.10,
                    child: ListView(
                        children: interest.map((s) =>
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: ElevatedButton(
                                onPressed: () {},
                                child: Text(s,
                                  style: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFF6B7AFF),
                                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                  minimumSize: Size(50, 35),
                                ),
                              ),
                            )).toList()
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
     }
    );
  }
}
