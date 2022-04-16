import 'package:client/graphQL/LnF.dart';
import 'package:client/screens/home/lostAndFound/LFCard.dart';
import 'package:client/screens/home/lostAndFound/addFound.dart';
import 'package:client/screens/home/lostAndFound/addLost.dart';
import 'package:client/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/tag.dart';
import '../../../widgets/loadingScreens.dart';
import '../../../models/L&Fclass.dart';

class LNFListing extends StatefulWidget {
  const LNFListing({Key? key}) : super(key: key);

  @override
  _LNFListingState createState() => _LNFListingState();
}

class _LNFListingState extends State<LNFListing> {

  ///GraphQL
  String getItems = LnFQuery().getItems;

  ///Variables
  List<LnF> Posts = [];
  String userId="";
  bool lostFilterValue = false;
  bool foundFilterValue = false;
  bool all = true;
  List<String> itemFilter = ["LOST","FOUND"];
  int take = 10;
  late int total;
  String search = "";
  bool display = false;
  Map<Tag,bool> filterSettings = {};
  String emptyScreenText = "No Lost & Found cases yet !!";

  ///Controllers
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController1 = ScrollController();
  ScrollController scrollController = ScrollController();

  ///Keys
  var ScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _sharedPreference();
  }
  SharedPreferences? prefs;
  void _sharedPreference()async{
    prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs!.getString('id')!;
    });
  }

  @override
  Widget build(BuildContext context) {

    // itemFilter.clear();
    // if(lostFilterValue){
    //   itemFilter.add("LOST");
    // }
    // if(foundFilterValue) {
    //   itemFilter.add("FOUND");
    // }
    // if(all) {
    //   itemFilter.add("LOST");
    //   itemFilter.add("FOUND");
    // }
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
          print("search : $search");
          if (result.hasException) {
            return Text(result.exception.toString());
          }
            if (result.isLoading) {
              return Scaffold(
                body: Center(
                  child: Column(
                    children: [
                      ///Heading
                      PageTitle('Lost & Found', context),
                      Expanded(
                          child: ListView.separated(
                              itemBuilder: (context, index) =>
                              const NewCardSkeleton(),
                              separatorBuilder: (context,
                                  index) => const SizedBox(height: 6,),
                              itemCount: 5)
                      )
                    ],
                  ),
                ),
              );
            }

          ///For empty screen
          if (result.data == null) {
            return Scaffold(
              body: Center(
                child: Column(
                  children: [
                    PageTitle('Lost & Found', context),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 250, 0, 0),
                      child: Container(
                          alignment: Alignment.center,
                          child: const Text(
                            'No Lost & Found cases yet !!',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.w600
                            ),
                            textAlign: TextAlign.center,
                          )
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: SpeedDial(
                useRotationAnimation: true,
                buttonSize: Size(56, 56),
                animatedIcon: AnimatedIcons.menu_arrow,
                backgroundColor: const Color(0xFFFF0000),
                overlayColor: const Color(0x00FFFFFF),
                animationSpeed: 300,
                renderOverlay: false,
                children: [

                  ///To add lost
                  SpeedDialChild(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                AddLost(
                                  refetchPosts: refetch,
                                )));
                      },
                      child: const Icon(Icons.search),
                      label: 'Lost something?'),

                  ///To add found
                  SpeedDialChild(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                AddFound(
                                  refetchPosts: refetch,
                                )));
                      },
                      child: const Icon(Icons.lightbulb_outline),
                      label: "Found something?"),
                ],
              ),
            );
          }
          else {
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
                createdName: data[i]["user"]["name"],
                imageUrl: imageUrls,
              ));
            }
            total = result.data!["getItems"]["total"];

            if(Posts.isEmpty) {
              FetchMoreOptions opts = FetchMoreOptions(
                  variables: {
                    "take": take,
                    "lastItemId": "",
                    "itemsFilter": itemFilter,
                    "search": search
                  },
                  updateQuery: (previousResultData, fetchMoreResultData) {
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
            }

            if(Posts.isNotEmpty) {
              FetchMoreOptions opts = FetchMoreOptions(
                variables: {
                  "take": take,
                  "lastItemId": Posts.last.id,
                  "itemsFilter": itemFilter,
                  "search": search
                },
                updateQuery: (previousResultData, fetchMoreResultData) {
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
            }


            return Scaffold(

                backgroundColor: const Color(0xFFDFDFDF),
                ///Adding lost or Found
                floatingActionButton: SpeedDial(
                  useRotationAnimation: true,
                  buttonSize: Size(56, 56),
                  animatedIcon: AnimatedIcons.menu_arrow,
                  backgroundColor: const Color(0xFFFF0000),
                  overlayColor: const Color(0x00FFFFFF),
                  animationSpeed: 300,
                  renderOverlay: false,
                  children: [

                    ///To add lost
                    SpeedDialChild(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  AddLost(
                                    refetchPosts: refetch,
                                  )));
                        },
                        child: const Icon(Icons.search),
                        label: 'Lost something?'),

                    ///To add found
                    SpeedDialChild(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  AddFound(
                                    refetchPosts: refetch,
                                  )));
                        },
                        child: const Icon(Icons.lightbulb_outline),
                        label: "Found something?"),
                  ],
                ),

                body: SafeArea(
                  child: RefreshIndicator(
                    color: const Color(0xFF2B2E35),
                    onRefresh: () {
                      return refetch!();
                    },
                    child: ListView(
                      controller: scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ///Heading
                          PageTitle("Lost & Found", context),

                          ///Search bar
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(22,8,10,0),
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height*0.06,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [

                                    ///Search bar
                                    Expanded(
                                      flex: 12,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(0,0,0,0),
                                        child: SizedBox(
                                          height: 35,
                                          child: TextFormField(
                                            controller: searchController,
                                            cursorColor: Colors.grey,
                                            decoration: InputDecoration(
                                              contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 2.0),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(100.0),
                                              ),

                                              hintText: 'Search',
                                            ),
                                            keyboardType: TextInputType.multiline,
                                            // onChanged: (String value){
                                            //   if(value.length>=3){
                                            //
                                            //   }
                                            // },
                                          ),
                                        ),
                                      ),
                                    ),

                                    ///Search button
                                    IconButton(
                                      onPressed: (){
                                        setState(() {
                                          search = searchController.text;
                                        });
                                      },
                                      icon: const Icon(Icons.search_outlined),
                                      color: const Color(0xFF42454D),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.fromLTRB(22.0,0,0,0),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height*0.05,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets
                                        .fromLTRB(
                                        0.0, 0.0, 6.0, 0.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          lostFilterValue = false;
                                          foundFilterValue = false;
                                          all = true;
                                        });
                                        emptyScreenText = "No Lost & Found cases yet !!";
                                        itemFilter.clear();
                                        itemFilter.add("LOST");
                                        itemFilter.add("FOUND");
                                        refetch!();
                                      },
                                      style: ElevatedButton
                                          .styleFrom(
                                        primary: all ? Colors
                                            .white : Color(
                                            0xFF42454D),
                                        padding: const EdgeInsets
                                            .symmetric(vertical: 4,
                                            horizontal: 8),
                                        minimumSize: Size(50, 35),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius
                                                .circular(20.0)
                                        ),
                                      ),
                                      child: Text("All",
                                        style: TextStyle(
                                            fontWeight: FontWeight
                                                .bold,
                                            color: all ? Color(
                                                0xFF42454D) : Colors
                                                .white,
                                            fontSize: 15
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets
                                        .fromLTRB(
                                        0.0, 0.0, 6.0, 0.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          lostFilterValue = true;
                                          all = false;
                                          foundFilterValue = false;
                                        });
                                        emptyScreenText = "No Lost cases yet !!";
                                        itemFilter.clear();
                                        itemFilter.add("LOST");
                                        refetch!();
                                        },
                                      style: ElevatedButton
                                          .styleFrom(
                                        primary: lostFilterValue ? Colors
                                            .white : Color(
                                            0xFF42454D),
                                        padding: const EdgeInsets
                                            .symmetric(vertical: 4,
                                            horizontal: 8),
                                        minimumSize: Size(50, 35),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius
                                                .circular(20.0)
                                        ),
                                      ),
                                      child: Text("Lost",
                                        style: TextStyle(
                                            fontWeight: FontWeight
                                                .bold,
                                            color: lostFilterValue ? Color(
                                                0xFF42454D) : Colors
                                                .white,
                                            fontSize: 15
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets
                                        .fromLTRB(
                                        0.0, 0.0, 6.0, 0.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          foundFilterValue = true;
                                          all = false;
                                          lostFilterValue = false;
                                        });
                                        emptyScreenText = "No Found cases yet !!";
                                        itemFilter.clear();
                                        itemFilter.add("FOUND");
                                        refetch!();
                                      },
                                      style: ElevatedButton
                                          .styleFrom(
                                        primary: foundFilterValue ? Colors
                                            .white : Color(
                                            0xFF42454D),
                                        padding: const EdgeInsets
                                            .symmetric(vertical: 4,
                                            horizontal: 8),
                                        minimumSize: Size(50, 35),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius
                                                .circular(20.0)
                                        ),
                                      ),
                                      child: Text("Found",
                                        style: TextStyle(
                                            fontWeight: FontWeight
                                                .bold,
                                            color: foundFilterValue ? Color(
                                                0xFF42454D) : Colors
                                                .white,
                                            fontSize: 15
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          ///Listing of lost and found cards

                          if(Posts.isNotEmpty)
                          SizedBox(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * 0.55,
                            width: MediaQuery
                                .of(context)
                                .size
                                .height * 0.550,
                            child: ListView(
                              shrinkWrap: true,
                              controller: scrollController1,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      12, 5, 12, 0),
                                  child: Column(
                                    children: Posts.map((post) =>
                                        LFCard(
                                          refetchPosts: refetch,
                                          userId: userId,
                                          post: post,
                                        )).toList(),
                                  ),
                                ),
                                if (result.isLoading)
                                  Center(
                                    child: LoadingAnimationWidget
                                        .staggeredDotsWave(
                                        color: Colors.black54,
                                        size: 30
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          if(Posts.isEmpty)
                            Container(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0,150,0,0),
                                  child: Text(
                                    emptyScreenText,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 30,
                                        fontWeight: FontWeight.w600
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                            )
                        ],
                      ),
                      ]
                    ),
                  ),
                ));
          }
        });
  }
}