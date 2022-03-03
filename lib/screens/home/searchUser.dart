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
        backgroundColor: Color(0xFF2B2E35),
      ),
      backgroundColor: Color(0xFFDFDFDF),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12,10,12,0),
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
                }
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
                            borderRadius: BorderRadius.circular(40.0),
                            border: Border.all(color: Colors.black,width: 0.5)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(15,0,0,0),
                                  child: TextFormField(
                                    controller: searchController,
                                    decoration: const InputDecoration(
                                      hintText: "Search",
                                      border: InputBorder.none
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                                child: IconButton(onPressed: (){
                                  setState(() {
                                    search=searchController.text;
                                  });
                                  refetch!();
                                }, icon: Icon(Icons.search)),
                              )
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width*0.92,
                          height: MediaQuery.of(context).size.height*0.75,
                          child: ListView(
                            children: users.map((user) =>
                              searchCard( user: user,)
                          ).toList(),
                          ),
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
