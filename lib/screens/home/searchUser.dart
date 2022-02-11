import 'package:client/graphQL/home.dart';
import 'package:client/models/user.dart';
import 'package:client/screens/home/searchCard.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class searchUser extends StatefulWidget {
  const searchUser({Key? key}) : super(key: key);

  @override
  _searchUserState createState() => _searchUserState();
}

class _searchUserState extends State<searchUser> {
  String searchUser = homeQuery().searchUser;
  int skip=0;
  int take= 10;
  String search ="";
  TextEditingController searchController = TextEditingController();
  List <User> users=[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search User"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Query(
                options:QueryOptions(
                  document: gql(searchUser),
                  variables:{"skip":skip,"take":take,"search":search}
                ) ,
                builder:(QueryResult result, {fetchMore, refetch}) {
                  if (result.hasException) {
                    print(result.exception.toString());
                  }
                  if (result.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.blue[700],
                      ),
                    );
                  }
                  var data = result.data!["searchUser"]["usersList"];
                  users.clear();
                  for (var i = 0; i < data.length; i++) {
                    users.add(
                        User(
                          role: data[i]["role"],
                          roll: data[i]["roll"],
                          id: data[i]["id"],
                          hostelName: data[i]["hostel"] != null
                              ? data[i]["hostel"]["name"]
                              : "",
                          name: data[i]["name"] != null ? data[i]["name"] : "",
                        ));
                  };
                  // print(data);
                  FetchMoreOptions opts = FetchMoreOptions(
                      variables: {"skip": skip, "take": take, "search": search},
                      updateQuery: (previousResultData, fetchMoreResultData) {
                        // print("previousResultData:$previousResultData");
                        // print("fetchMoreResultData:${fetchMoreResultData!["getNetops"]["total"]}");
                        // print("posts:$posts");
                        return fetchMoreResultData;
                      }
                  );
                  return Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 300,
                            child: TextFormField(
                              controller: searchController,
                            ),
                          ),
                          IconButton(onPressed: (){
                            setState(() {
                              search=searchController.text;
                            });
                            refetch!();
                          }, icon: Icon(Icons.search))
                        ],
                      ),
                      SizedBox(
                        width: 400,
                        height: 600,
                        child: ListView(
                          children: users.map((user) =>
                            searchCard( user: user,)
                        ).toList(),
                        ),
                      )
                    ],
                  );
                }
            ),
          ]
        ),
      ),
    );
  }
}
