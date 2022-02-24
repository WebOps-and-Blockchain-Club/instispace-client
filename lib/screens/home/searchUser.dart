import 'package:client/graphQL/home.dart';
import 'package:client/models/user.dart';
import 'package:client/screens/home/searchCard.dart';
import 'package:client/widgets/text.dart';
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
        title: Text("Search Users"),
        elevation: 0.0,
        bottomOpacity: 200,
        backgroundColor: Color(0xFF5451FD),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(7)
          )
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8.0,10,8,0),
        child: Column(
        children: [
          Query(
              options:QueryOptions(
                document: gql(searchUser),
                variables:{"take":take,"lastUserId": "","search":search}
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
                users.clear();
                var data = result.data!["searchUser"]["usersList"];
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
                    variables: {"take": take, "lastUserId":users.last.id ,"search": search},
                    updateQuery: (previousResultData, fetchMoreResultData) {
                      // print("previousResultData:$previousResultData");
                      // print("fetchMoreResultData:${fetchMoreResultData!["getNetops"]["total"]}");
                      // print("posts:$posts");
                      return fetchMoreResultData;
                    }
                );
                return Expanded(
                  flex: 7,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(color: Colors.black,width: 0.5)
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 300,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(8.0,0,0,0),
                                  child: TextFormField(
                                    controller: searchController,
                                    decoration: const InputDecoration(
                                      hintText: "Search",
                                      border: InputBorder.none
                                    ),
                                  ),
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
                        ),
                      ),
                      SizedBox(
                        width: 400,
                        height: MediaQuery.of(context).size.height*0.8,
                        child: ListView(
                          children: users.map((user) =>
                            searchCard( user: user,)
                        ).toList(),
                        ),
                      )
                    ],
                  ),
                );
              }
          ),
        ]
          ),
      ),
    );
  }
}
