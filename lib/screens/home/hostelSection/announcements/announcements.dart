import 'package:client/graphQL/announcements.dart';
import 'package:client/graphQL/auth.dart';
import 'package:client/graphQL/home.dart';
import 'package:flutter/material.dart';
import 'package:client/screens/home/hostelSection/announcements/addAnnouncements.dart';
import 'package:client/models/announcementsClass.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:client/widgets/announcementCard.dart';
import 'package:client/widgets/text.dart';
import 'package:client/widgets/loadingScreens.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../userInit/dropDown.dart';

class Announcements extends StatefulWidget {
  const Announcements({Key? key}) : super(key: key);

  @override
  _AnnouncementsState createState() => _AnnouncementsState();
}


class _AnnouncementsState extends State<Announcements> {

  ///GraphQL
  String getAnnouncements = AnnouncementQM().getAnnouncements;
  String getHostels = authQuery().getHostels;



  ///Variables
  List<Announcement> announcements = [];
  String _dropDownValue = "All";
  String role="";
  String id="";
  String userHostelID="";
  String userHostelName="";
  int skip = 0;
  int take = 10;
  late int total;
  late var createdAt;
  String search = "";
  String hostelIdFilter = "";
  Map<String, String> hostels = {};
  int hostelNumber = 0;
  SharedPreferences? prefs;

  void _sharedPreference()async{
    prefs = await SharedPreferences.getInstance();
    setState(() {
      role = prefs!.getString("role")!;
      id = prefs!.getString('id')!;
      userHostelID = prefs!.getString('hostelId')!;
      userHostelName = prefs!.getString('hostelName')!;
    });
  }

  ///Controllers
  ScrollController scrollController = ScrollController();

  ///Keys
  var ScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _sharedPreference();
  }

  @override
  Widget build(BuildContext context) {
    if (role == "ADMIN" || role == "HAS" || role == "HOSTEL_SEC") {
      return Query(
        options: QueryOptions(
          document: gql(getHostels),
        ),
        builder: (QueryResult result,{fetchMore, refetch}) {
          if(result.hasException) {
            return Text(result.hasException.toString());
          }
          if (result.isLoading ) {
            return Scaffold(
              body: Center(
                child: Column(
                  children: [
                    PageTitle('Announcements', context),
                    Expanded(
                        child: ListView.separated(
                            itemBuilder: (context, index) => const NewCardSkeleton(),
                            separatorBuilder: (context, index) => const SizedBox(height: 6,),
                            itemCount: 5)
                    )
                  ],
                ),
              ),
            );
          }
          hostels.clear();
          hostels.putIfAbsent(
              "All", () => ""
          );
          hostelNumber = result.data!["getHostels"].length;
          for(var i = 0; i < result.data!["getHostels"].length; i++) {
            hostels.putIfAbsent(
              result.data!["getHostels"][i]["name"],
                  () =>
              result.data!["getHostels"][i]["id"],
            );
          }

          return Query(
              options: QueryOptions(
                  document: gql(getAnnouncements),
                  variables: {"hostelId": hostelIdFilter,"take": take,"lastAnnouncementId":"","search": ""}
              ),
              builder: (QueryResult result, {fetchMore, refetch}) {
                if (result.isLoading ) {
                  return Scaffold(
                    body: Center(
                      child: Column(
                        children: [
                          PageTitle('Announcements', context),
                          Expanded(
                              child: ListView.separated(
                                  itemBuilder: (context, index) => const NewCardSkeleton(),
                                  separatorBuilder: (context, index) => const SizedBox(height: 6,),
                                  itemCount: 5)
                          )
                        ],
                      ),
                    ),
                  );
                }
                if (result.isLoading && announcements.isEmpty) {
                  return Scaffold(
                    body: Center(
                      child: Column(
                        children: [
                          PageTitle('Announcements', context),
                          Expanded(
                              child: ListView.separated(
                                  itemBuilder: (context, index) => const NewCardSkeleton(),
                                  separatorBuilder: (context, index) => const SizedBox(height: 6,),
                                  itemCount: 5)
                          )
                        ],
                      ),
                    ),
                  );
                }

                if (result.hasException) {
                  return Text(result.exception.toString());
                }

                if (result.data!["getAnnouncements"]["announcementsList"] != null || result.data!["getAnnouncements"]["announcementsList"].isNotEmpty) {
                  announcements.clear();

                  for (var i = 0; i < result
                      .data!["getAnnouncements"]["announcementsList"]
                      .length; i++) {
                    List<String> hostelIDs = [];
                    List<String> hostelNames = [];
                    for (var j = 0; j < result
                        .data!["getAnnouncements"]["announcementsList"][i]["hostels"]
                        .length; j++) {
                      hostelIDs.add(result
                          .data!["getAnnouncements"]["announcementsList"][i]["hostels"][j]["name"]);
                      hostelNames.add(result
                          .data!["getAnnouncements"]["announcementsList"][i]["hostels"][j]["name"]);
                    }
                    createdAt = result.data!["getAnnouncements"]
                    ["announcementsList"][i]["createdAt"];
                    // print(createdAt);

                    announcements.add(Announcement(
                        title: result.data!["getAnnouncements"]
                        ["announcementsList"][i]["title"],
                        description: result.data!["getAnnouncements"]
                        ["announcementsList"][i]["description"],
                        endTime: result.data!["getAnnouncements"]
                        ["announcementsList"][i]["endTime"],
                        id: result.data!["getAnnouncements"]
                        ["announcementsList"][i]["id"],
                        hostelIds: hostelIDs,
                        images: result.data!["getAnnouncements"]
                        ["announcementsList"][i]["images"],
                        createdByUserId: result.data!["getAnnouncements"]
                        ["announcementsList"][i]["user"]["id"],
                        hostelNames: hostelNames
                    ));
                  }
                }

                total=result.data!["getAnnouncements"]["total"];
                if(announcements.isNotEmpty) {
                  FetchMoreOptions opts = FetchMoreOptions(
                      variables: {
                        "hostelId": hostelIdFilter,
                        "take": take,
                        "lastAnnouncementId": announcements.last.id,
                        "search": search
                      },
                      updateQuery: (previousResultData,
                          fetchMoreResultData) {
                        final List<dynamic> repos = [
                          ...previousResultData!["getAnnouncements"] as List<
                              dynamic>,
                          ...fetchMoreResultData!["getAnnouncements"] as List<
                              dynamic>
                        ];
                        fetchMoreResultData["getAnnouncements"] = repos;
                        return fetchMoreResultData;
                      }
                  );
                  scrollController.addListener(() {
                    var triggerFetchMoreSize =
                        0.99 * scrollController.position.maxScrollExtent;
                    if (scrollController.position.pixels >
                        triggerFetchMoreSize && total > announcements
                        .length) {
                      fetchMore!(opts);
                      scrollController.jumpTo(triggerFetchMoreSize);
                    }
                  });
                }
                return Scaffold(
                  key: ScaffoldKey,

                  backgroundColor: const Color(0xFFF7F7F7),

                  body: Center(
                      child: ListView(
                          children:[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PageTitle("Announcements", context),

                                ///Hostel DropDown
                                dropDown(
                                    Hostels: hostels.keys.toList(),
                                    dropDownValue: _dropDownValue,
                                    callback: (val) {
                                      setState(() {
                                        _dropDownValue = val;
                                        hostelIdFilter= hostels[_dropDownValue]!;
                                      });
                                    }
                                ),

                                if (result.data!["getAnnouncements"]["announcementsList"] == null || result.data!["getAnnouncements"]["announcementsList"].isEmpty || result.data!["getAnnouncements"]["announcementsList"] == [])
                                  const Text(
                                    'No announcements Yet !!',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 30,
                                        fontWeight: FontWeight.w600
                                    ),
                                    textAlign: TextAlign.center,
                                  ),

                                if (result.data!["getAnnouncements"]["announcementsList"] != null || result.data!["getAnnouncements"]["announcementsList"].isNotEmpty || result.data!["getAnnouncements"]["announcementsList"] != [])
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 0.0),
                                    child: SizedBox(
                                      height: MediaQuery.of(context).size.height*0.7,
                                      child: RefreshIndicator(
                                        onRefresh: () {
                                          return refetch!();
                                        },
                                        child: ListView(
                                            controller: scrollController,
                                            children: [
                                              Column(
                                                children: announcements
                                                    .map((post) => AnnouncementsCards(context,role,id,refetch,post,hostelNumber)
                                                )
                                                    .toList(),
                                              ),
                                            ]
                                        ),
                                      ),
                                    ),
                                  ),
                                if (result.isLoading)
                                  const Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFFDEDDFF),
                                    ),
                                  ),
                              ],
                            ),
                          ]
                      )
                  ),

                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              AddAnnouncements(
                                  refetchAnnouncement: refetch)));
                    },
                    child: const Icon(Icons.add,color: Color(0xFFFFFFFF),),
                    backgroundColor: Colors.black,
                  ),
                );
              });
        },
      );
    } else {
      // print(userHostelID);
      return Query(
          options: QueryOptions(
              document: gql(getAnnouncements),
              variables: {
                "hostelId": userHostelID,
                "lastAnnouncementId": "",
                "take": take,
                "search": search,
              }),
          builder: (QueryResult result, {fetchMore, refetch}) {
            if (result.hasException) {
              return Text(result.exception.toString());
            }
            if (announcements.isEmpty && result.isLoading) {
              return Scaffold(
                body: Center(
                  child: Column(
                    children: [
                      PageTitle('Announcements', context),
                      Expanded(
                          child: ListView.separated(
                              itemBuilder: (context, index) => const NewCardSkeleton(),
                              separatorBuilder: (context, index) => const SizedBox(height: 6,),
                              itemCount: 5)
                      )
                    ],
                  ),
                ),
              );
            }
            if (result.data!["getAnnouncements"]["announcementsList"] == null || result.data!["getAnnouncements"]["announcementsList"].isEmpty){
              return Scaffold(
                body: Center(
                  child: Column(
                    children: [
                      PageTitle('Announcements', context),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0,250,0,0),
                        child: Container(
                            alignment: Alignment.center,
                            child: const Text(
                              'No announcements Yet !!',
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
              );
            }
            else{
              announcements.clear();
              for (var i = 0;
              i <
                  result.data!["getAnnouncements"]["announcementsList"]
                      .length;
              i++) {
                List<String> hostelIDs = [];
                List<String> hostelNames = [];
                for (var j = 0;
                j < result.data!["getAnnouncements"]["announcementsList"][i]["hostels"].length; j++) {
                  hostelIDs.add(result.data!["getAnnouncements"]
                  ["announcementsList"][i]["hostels"][j]["id"]);
                  hostelNames.add(result.data!["getAnnouncements"]
                  ["announcementsList"][i]["hostels"][j]["name"]);
                }
                announcements.add(Announcement(
                    title: result.data!["getAnnouncements"]
                    ["announcementsList"][i]["title"],
                    description: result.data!["getAnnouncements"]
                    ["announcementsList"][i]["description"],
                    endTime: result.data!["getAnnouncements"]
                    ["announcementsList"][i]["endTime"],
                    id: result.data!["getAnnouncements"]["announcementsList"]
                    [i]["id"],
                    hostelIds: hostelIDs,
                    images: result.data!["getAnnouncements"]
                    ["announcementsList"][i]["images"],
                    createdByUserId: result.data!["getAnnouncements"]
                    ["announcementsList"][i]["user"]["id"],
                    hostelNames: hostelNames
                ));
              }
              total = result.data!["getAnnouncements"]["total"];
              FetchMoreOptions opts = FetchMoreOptions(
                  variables: {
                    "lastAnnouncementId": announcements.last.id,
                    "hostelId": userHostelID,
                    "take": take,
                    "search": search,
                  },
                  updateQuery: (previousResultData, fetchMoreResultData) {
                    final List<dynamic> repos = [
                      ...previousResultData!['getAnnouncements']
                      ['announcementsList'] as List<dynamic>,
                      ...fetchMoreResultData!['getAnnouncements']
                      ['announcementsList'] as List<dynamic>
                    ];
                    fetchMoreResultData['getAnnouncements']
                    ['announcementsList'] = repos;
                    return fetchMoreResultData;
                  });
              scrollController.addListener(() async {
                var triggerFetchMoreSize =
                    0.99 * scrollController.position.maxScrollExtent;
                if (scrollController.position.pixels >
                    triggerFetchMoreSize &&
                    total > announcements.length) {
                  await fetchMore!(opts);
                  scrollController.jumpTo(triggerFetchMoreSize);
                }
              });

              return Scaffold(

                key: ScaffoldKey,

                backgroundColor: const Color(0xFFDFDFDF),

                body: RefreshIndicator(
                  color: const Color(0xFF2B2E35),
                  onRefresh: () {
                    return refetch!();
                  },
                  child: ListView(controller: scrollController, children: [

                    ///Heading
                    PageTitle('Announcements',context),

                    ///Listing of Announcements
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 0.0),
                      child: RefreshIndicator(
                        onRefresh: () {
                          return refetch!();
                        },
                        child: Column(
                          children: announcements
                              .map((post) => AnnouncementsCards(context,role,id,refetch,post,hostelNumber))
                              .toList(),
                        ),
                      ),
                    ),
                    if (result.isLoading)
                      Center(
                        child: LoadingAnimationWidget.staggeredDotsWave(
                            color: Colors.black54,
                            size: 30
                        ),
                      ),
                  ]),
                ),
              );
            }
          }
      );
    }
  }
}
