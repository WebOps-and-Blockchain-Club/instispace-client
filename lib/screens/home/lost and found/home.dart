import 'package:client/graphQL/LnF.dart';
import 'package:client/screens/home/lost%20and%20found/L&FCard.dart';
import 'package:client/screens/home/lost%20and%20found/addfound.dart';
import 'package:client/screens/home/lost%20and%20found/addlost.dart';
import 'package:client/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'LFclass.dart';

class LNFListing extends StatefulWidget {
  const LNFListing({Key? key}) : super(key: key);

  @override
  _LNFListingState createState() => _LNFListingState();
}

class _LNFListingState extends State<LNFListing> {
  String getItems = LnFQuery().getItems;
  List<LnF> Posts = [];
  late String userId;
  bool lostFilterValue = true;
  bool foundFilterValue = true;
  List itemFilter = [];
  int skip=0;
  int take=10;
  late int total;
  ScrollController scrollController =ScrollController();

  @override
  Widget build(BuildContext context) {
    itemFilter.clear();
    if (lostFilterValue) {
      itemFilter.add("LOST");
    }
    if (foundFilterValue) {
      itemFilter.add("FOUND");
    }
    print("itemFilter:$itemFilter");
    return Query(
        options: QueryOptions(
          document: gql(getItems),
          variables: {"itemsFilter": itemFilter,"skip":skip,"take":take},
        ),
        builder: (QueryResult result, {fetchMore, refetch}){

          if (result.hasException) {
            print(result.exception.toString());
            return Text(result.exception.toString());
          }
          if(Posts.isEmpty){
            if(result.isLoading){
              return Scaffold(
                appBar: AppBar(
                  title: Text('Lost & Found'),
                  backgroundColor: Color(0xFF5451FD),
                ),
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }
          Posts.clear();
          var data = result.data!["getItems"]["itemsList"];
          for (var i = 0; i < data.length; i++) {
            var contact;
            List<String> imageUrls=[];
            if(data[i]["images"]!=null)
            {imageUrls=data[i]["images"].split(" AND ");}
            data[i]["contact"]==null ?
            (
                data[i]["user"]["mobile"] == null
                ? contact = "${data[i]["user"]["roll"]}@smail.iitm.ac.in"
                : contact = data[i]["user"]["mobile"]
            ): contact=data[i]["contact"];
            Posts.add(LnF(
                category: data[i]["category"],
                what: data[i]["name"],
                id: data[i]["id"],
                location: data[i]["location"],
                time: data[i]["time"],
                contact: contact,
                createdId: data[i]["user"]["id"],
                imageUrl: imageUrls,
            ));
          }
          total=result.data!["getItems"]["total"];
          userId = result.data!["getMe"]["id"];
          FetchMoreOptions opts =FetchMoreOptions(
              variables: {"itemsFilter": itemFilter,"skip":skip+10,"take":take},
              updateQuery: (previousResultData,fetchMoreResultData){
                // print("previousResultData:$previousResultData");
                // print("fetchMoreResultData:${fetchMoreResultData!["getNetops"]["total"]}");
                // print("posts:$posts");
                final List<dynamic> repos = [
                  ...previousResultData!["getItems"]["itemsList"] as List<dynamic>,
                  ...fetchMoreResultData!["getItems"]["itemsList"] as List<dynamic>
                ];
                fetchMoreResultData["getItems"]["itemsList"] = repos;
                return fetchMoreResultData;
              }
          );
          scrollController.addListener(()async {
            var triggerFetchMoreSize =
                0.99 * scrollController.position.maxScrollExtent;
            if (scrollController.position.pixels >
                triggerFetchMoreSize && total>Posts.length){
              await fetchMore!(opts);
              scrollController.jumpTo(triggerFetchMoreSize);
            }
          }
          );

          return Scaffold(
              appBar: AppBar(
                title: Text('Lost & Found',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),
                ),
                backgroundColor: Color(0xFF5451FD),
              ),
              backgroundColor: Color(0xFFF7F7F7),
              endDrawer: Drawer(
                child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter stateState) {
                    return SafeArea(
                        child: ListView(
                        primary: false,
                        children: [
                        Column(
                          children: [
                            Text("Filter"),
                            CheckboxListTile(
                                title: Text('Lost'),
                                value: lostFilterValue,
                                onChanged: (bool? value) {
                                  setState(() {
                                    lostFilterValue = value!;
                                  });
                                }),
                            CheckboxListTile(
                                title: Text('Found'),
                                value: foundFilterValue,
                                onChanged: (bool? value) {
                                  setState(() {
                                    foundFilterValue = value!;
                                  });
                                }),
                            ElevatedButton(
                              onPressed: () {
                                refetch!();
                              },
                              child: Text('Apply'),
                            )
                          ],
                        )
                      ],
                    ));
                  },
                ),
              ),
              body: SafeArea(
                child: ListView(
                  children: [Column(
                    children: [
                      //Button Row
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //Lost Button
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) => AddLost(refetchPosts: refetch,)));
                                },
                                child: Text('Lost Something?',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFF6B7AFF),
                                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                minimumSize: Size(50, 35),
                              ),
                            ),

                            //Found Button
                            ElevatedButton(
                                onPressed: ()  {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) => AddFound(refetchPosts: refetch,)));
                                },
                                child: Text('Found Something?',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFF6B7AFF),
                                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                minimumSize: Size(50, 35),
                              ),
                            ),
                          ],
                        ),
                      ),

                      //List of Posts
                      SizedBox(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.79,
                        width: 400,
                        child: ListView(
                          controller: scrollController,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                              child: Column(
                                children: Posts.map((post) => LFCard(
                                      refetchPosts: refetch,
                                      userId: userId,
                                      post: post,
                                    )).toList(),
                              ),
                            ),
                            if (result.isLoading)
                            Center(
                              child: CircularProgressIndicator(),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  ]
                ),
              ));
        }
        );
  }
}
