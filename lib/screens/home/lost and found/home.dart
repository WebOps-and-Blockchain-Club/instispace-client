import 'package:client/graphQL/LnF.dart';
import 'package:client/screens/home/lost%20and%20found/L&FCard.dart';
import 'package:client/screens/home/lost%20and%20found/addfound.dart';
import 'package:client/screens/home/lost%20and%20found/addlost.dart';
import 'package:client/widgets/search.dart';
import 'package:client/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../models/tag.dart';
import '../../../widgets/Filters.dart';
import '../../../widgets/loading screens.dart';
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
  List<String> itemFilter = [];
  int take = 10;
  late int total;
  String search = "";
  bool display = false;
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  var ScaffoldKey = GlobalKey<ScaffoldState>();

  Map<Tag,bool> filterSettings = {};

  @override
  Widget build(BuildContext context) {
    itemFilter.clear();
    if (lostFilterValue) {
      itemFilter.add("LOST");
    }
    if (foundFilterValue) {
      itemFilter.add("FOUND");
    }

    filterSettings.putIfAbsent(Tag(
      category: '',
      id: "id",
      Tag_name: 'Lost',
    ), () => false);
    filterSettings.putIfAbsent(Tag(
      category: '',
      id: "id",
      Tag_name: "Found",
    ), () => false);
    print("itemFilter:$itemFilter");
    return Query(
        options: QueryOptions(
          document: gql(getItems),
          variables: {
            "take": take,
            "lastItemId": "",
            "itemsFilter": itemFilter,
            "search": search
          },
        ),
        builder: (QueryResult result, {fetchMore, refetch}) {
          if (result.hasException) {
            print(result.exception.toString());
            return Text(result.exception.toString());
          }
          if (Posts.isEmpty) {
            if (result.isLoading) {
              return Scaffold(
                // appBar: AppBar(
                //   title: const Text('Lost & Found'),
                //   backgroundColor: const Color(0xFF5451FD),
                // ),
                body: Center(
                  child: Column(
                    children: [
                      PageTitle('Lost & Found', context),
                      Expanded(
                          child: ListView.separated(
                              itemBuilder: (context, index) => NewCardSkeleton(),
                              separatorBuilder: (context, index) => const SizedBox(height: 6,),
                              itemCount: 5)
                      )
                    ],
                  ),
                ),
              );
            }
          }
          Posts.clear();
          var data = result.data!["getItems"]["itemsList"];
          for (var i = 0; i < data.length; i++) {
            var contact;
            List<String> imageUrls = [];
            if (data[i]["images"] != null) {
              imageUrls = data[i]["images"].split(" AND ");
            }
            data[i]["contact"] == null
                ? (data[i]["user"]["mobile"] == null
                    ? contact = "${data[i]["user"]["roll"]}@smail.iitm.ac.in"
                    : contact = data[i]["user"]["mobile"])
                : contact = data[i]["contact"];
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
          total = result.data!["getItems"]["total"];
          userId = result.data!["getMe"]["id"];
          FetchMoreOptions opts = FetchMoreOptions(
              variables: {
                "take": take,
                "lastItemId": Posts.last.id,
                "itemsFilter": itemFilter,
                "search": search
              },
              updateQuery: (previousResultData, fetchMoreResultData) {
                // print("previousResultData:$previousResultData");
                // print("fetchMoreResultData:${fetchMoreResultData!["getNetops"]["total"]}");
                // print("posts:$posts");
                final List<dynamic> repos = [
                  ...previousResultData!["getItems"]["itemsList"]
                      as List<dynamic>,
                  ...fetchMoreResultData!["getItems"]["itemsList"]
                      as List<dynamic>
                ];
                fetchMoreResultData["getItems"]["itemsList"] = repos;
                return fetchMoreResultData;
              });
          scrollController.addListener(() async {
            var triggerFetchMoreSize =
                0.99 * scrollController.position.maxScrollExtent;
            if (scrollController.position.pixels > triggerFetchMoreSize &&
                total > Posts.length) {
              await fetchMore!(opts);
              scrollController.jumpTo(triggerFetchMoreSize);
            }
          });

          return Scaffold(
              // appBar: AppBar(
              //   title: const Text('Lost & Found',
              //     style: TextStyle(
              //         color: Colors.white,
              //         fontWeight: FontWeight.bold
              //     ),
              //   ),
              //   backgroundColor: const Color(0xFF5451FD),
              // ),
              backgroundColor: const Color(0xFFF7F7F7),
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
              floatingActionButton: SpeedDial(
                animatedIcon: AnimatedIcons.menu_arrow,
                backgroundColor: const Color(0xFF5451FD),
                children: [
                  SpeedDialChild(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => AddLost(
                                  refetchPosts: refetch,
                                )));
                      },
                      child: const Icon(Icons.label),
                      label: 'Lost something?'),
                  SpeedDialChild(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => AddFound(
                                  refetchPosts: refetch,
                                )));
                      },
                      child: const Icon(Icons.label),
                      label: "Found something?"),
                ],
              ),
              body: SafeArea(
                child: ListView(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //Title
                      PageTitle("Lost & Found",context),
                  // Padding(
                  //   padding: const EdgeInsets.fromLTRB(24,8,10,8),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.end,
                  //     children: [
                  //       if (display)
                  //       Expanded(
                  //         flex: 12,
                  //         child: Padding(
                  //           padding: const EdgeInsets.fromLTRB(0,0,8,0),
                  //           child: TextFormField(
                  //             controller: searchController,
                  //             // onChanged: (String value){
                  //             //   if(value.length>=3){
                  //             //
                  //             //   }
                  //             // },
                  //           ),
                  //         ),
                  //       ),
                  //
                  //       IconButton(onPressed: (){
                  //         setState(() {
                  //           display = !display;
                  //           search=searchController.text;
                  //           // print("search String $search");
                  //         });
                  //         if(!display){
                  //           refetch!();
                  //         }
                  //       }, icon: Icon(Icons.search_outlined),color: Color(0xFF5451FD),
                  //       ),
                  //
                  //       Padding(
                  //         padding: const EdgeInsets.fromLTRB(0,0,0,0),
                  //         child: IconButton(
                  //             onPressed: () {
                  //               ScaffoldKey.currentState?.openEndDrawer();
                  //             },
                  //             icon: Icon(Icons.filter_alt_outlined),color: Color(0xFF5451FD),),
                  //       )
                  //     ],
                  //   ),
                  // ),


                      Search(search: search, refetch: refetch, ScaffoldKey: ScaffoldKey, page: 'L&F', widget: Filters(isStarred: false, filterSettings: filterSettings, selectedFilterIds: [], mostLikeValues: false, refetch: refetch,page: 'L&F', callback: (bool val) {  },), callback:(val) => search = val,),

                      // //Button Row
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //     children: [
                      //       //Lost Button
                      //       ElevatedButton(
                      //           onPressed: () {
                      //             Navigator.of(context).push(MaterialPageRoute(
                      //                 builder: (BuildContext context) => AddLost(refetchPosts: refetch,)));
                      //           },
                      //           child: Text('Lost Something?',
                      //             style: TextStyle(
                      //               color: Colors.white,
                      //               fontSize: 14,
                      //               fontWeight: FontWeight.bold,
                      //             ),
                      //           ),
                      //         style: ElevatedButton.styleFrom(
                      //           primary: Color(0xFF6B7AFF),
                      //           padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      //           minimumSize: Size(50, 35),
                      //         ),
                      //       ),
                      //
                      //       //Found Button
                      //       ElevatedButton(
                      //           onPressed: ()  {
                      //             Navigator.of(context).push(MaterialPageRoute(
                      //                 builder: (BuildContext context) => AddFound(refetchPosts: refetch,)));
                      //           },
                      //           child: Text('Found Something?',
                      //             style: TextStyle(
                      //               color: Colors.white,
                      //               fontSize: 14,
                      //               fontWeight: FontWeight.bold,
                      //             ),
                      //           ),
                      //         style: ElevatedButton.styleFrom(
                      //           primary: Color(0xFF6B7AFF),
                      //           padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      //           minimumSize: Size(50, 35),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      //List of Posts
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.75,
                        width: 400,
                        child: ListView(
                          controller: scrollController,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                              child: Column(
                                children: Posts.map((post) => LFCard(
                                      refetchPosts: refetch,
                                      userId: userId,
                                      post: post,
                                    )).toList(),
                              ),
                            ),
                            if (result.isLoading)
                              const Center(
                                child: CircularProgressIndicator(),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ]),
              ));
        });
  }
}