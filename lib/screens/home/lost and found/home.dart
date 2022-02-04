import 'package:client/graphQL/LnF.dart';
import 'package:client/screens/home/lost%20and%20found/L&FCard.dart';
import 'package:client/screens/home/lost%20and%20found/addfound.dart';
import 'package:client/screens/home/lost%20and%20found/addlost.dart';
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
          Posts.clear();
          if (result.hasException) {
            print(result.exception.toString());
            return Text(result.exception.toString());
          }
          if(result.isLoading){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
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
                title: Text('Lost & Found'),
              ),
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
              body: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) => AddLost(refetchPosts: refetch,)));
                          },
                          child: Text('Lost Something?')),
                      ElevatedButton(
                          onPressed: ()  {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) => AddFound(refetchPost: refetch,)));
                          },
                          child: Text('Found Something?')),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.78,
                    width: 400,
                    child: ListView(
                      controller: scrollController,
                      children: [
                        Column(
                          children: Posts.map((post) => LFCard(
                                refetchPosts: refetch,
                                userId: userId,
                                post: post,
                              )).toList(),
                        ),
                        if (result.isLoading)
                        Center(
                          child: CircularProgressIndicator(),
                        ),
                      ],
                    ),
                  )
                ],
              ));
        }
        );
  }
}
