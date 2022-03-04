import 'package:client/graphQL/announcements.dart';
import 'package:client/graphQL/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:client/screens/home/HostelSection/Announcements/addAnnouncements.dart';
import 'package:client/models/announcementsClass.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:client/widgets/announcementCard.dart';
import 'package:client/widgets/text.dart';
import 'package:client/widgets/loadingScreens.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Announcements extends StatefulWidget {
  const Announcements({Key? key}) : super(key: key);

  @override
  _AnnouncementsState createState() => _AnnouncementsState();
}


class _AnnouncementsState extends State<Announcements> {

  ///GraphQL
  String getAnnouncements = AnnouncementQM().getAnnouncements;
  String getAllAnnouncements = AnnouncementQM().getAllAnnouncements;
  String getMe = homeQuery().getMe;

  ///Variables
  List<Announcement> announcements = [];
  static var role;
  static var id;
  late String userHostelID;
  late String userHostelName;
  int skip = 0;
  int take = 10;
  late int total;
  late var createdAt;
  String search = "";

  ///Controllers
  ScrollController scrollController = ScrollController();

  ///Keys
  var ScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: gql(getMe),
        ),
        builder: (QueryResult result, {fetchMore, refetch}) {
          if (result.isLoading) {
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
          role = result.data!["getMe"]["role"];
          id = result.data!["getMe"]["id"];
          if (role == "ADMIN" || role == "HAS" || role == "HOSTEL_SEC") {
            return Query(
                options: QueryOptions(
                    document: gql(getAllAnnouncements),
                    variables: {"take": take,"lastAnnouncementId":"","search": ""}),
                builder: (QueryResult result, {fetchMore, refetch}) {
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
                  if (result.hasException) {
                    return Text(result.exception.toString());
                  }
                  if (result.data!["getAllAnnouncements"]["announcementsList"] == null || result.data!["getAllAnnouncements"]["announcementsList"].isEmpty){
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
                                    'No Announcements Yet !!',
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
                  announcements.clear();

                  for (var i = 0;
                      i <
                          result
                              .data!["getAllAnnouncements"]["announcementsList"]
                              .length;
                      i++) {
                    List<String> hostelIDs = [];
                    for (var j = 0;
                        j <
                            result
                                .data!["getAllAnnouncements"]
                                    ["announcementsList"][i]["hostels"]
                                .length;
                        j++) {
                      hostelIDs.add(result.data!["getAllAnnouncements"]
                          ["announcementsList"][i]["hostels"][j]["name"]);
                    }
                    createdAt = result.data!["getAllAnnouncements"]
                    ["announcementsList"][i]["createdAt"];
                    // print(createdAt);

                    announcements.add(Announcement(
                      title: result.data!["getAllAnnouncements"]
                          ["announcementsList"][i]["title"],
                      description: result.data!["getAllAnnouncements"]
                          ["announcementsList"][i]["description"],
                      endTime: result.data!["getAllAnnouncements"]
                          ["announcementsList"][i]["endTime"],
                      id: result.data!["getAllAnnouncements"]
                          ["announcementsList"][i]["id"],
                      hostelIds: hostelIDs,
                      images: result.data!["getAllAnnouncements"]
                          ["announcementsList"][i]["images"],
                      createdByUserId: result.data!["getAllAnnouncements"]
                          ["announcementsList"][i]["user"]["id"],
                    ));
                  }
                  total = result.data!["getAllAnnouncements"]["total"];
                  FetchMoreOptions opts = FetchMoreOptions(
                      variables: {
                        "lastAnnouncementId": announcements.last.id,
                        "take": take,
                        "search": search,
                      },
                      updateQuery: (previousResultData, fetchMoreResultData) {
                        // print("previousResultData:$previousResultData");
                        // print("fetchMoreResultData:${fetchMoreResultData!["getNetops"]["total"]}");
                        // print("posts:$posts");
                        final List<dynamic> repos = [
                          ...previousResultData!['getAllAnnouncements']
                              ['announcementsList'] as List<dynamic>,
                          ...fetchMoreResultData!['getAllAnnouncements']
                              ['announcementsList'] as List<dynamic>
                        ];
                        fetchMoreResultData['getAllAnnouncements']
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

                    appBar: AppBar(
                      title: const Text(
                        "Announcements",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      elevation: 0.0,
                      automaticallyImplyLeading: false,
                      backgroundColor: const Color(0xFF5451FD),
                      actions: [
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      AddAnnouncements(
                                          refetchAnnouncement: refetch)));
                            },
                            iconSize: 30,
                            icon: const Icon(Icons.add))
                      ],
                    ),

                    backgroundColor: const Color(0xFFF7F7F7),

                    body: Container(
                        child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 0.0),
                      child: RefreshIndicator(
                        onRefresh: () {
                          return refetch!();
                        },
                        child: ListView(
                          shrinkWrap: true,
                            controller: scrollController,
                            children: [
                              Column(
                                children: announcements
                                .map((post) => AnnouncementsCards(context,role,id,refetch,post))
                                .toList(),
                              ),
                              if (result.isLoading)
                            const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFFDEDDFF),
                              ),
                            ),
                        ]),
                      ),
                    )),
                  );
                });
          } else {
            userHostelID = result.data!["getMe"]["hostel"]["id"];
            userHostelName = result.data!["getMe"]["hostel"]["name"];
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
                                    'No Announcements Yet !!',
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
                    for (var j = 0;
                        j <
                            result
                                .data!["getAnnouncements"]["announcementsList"]
                                    [i]["hostels"]
                                .length;
                        j++) {
                      hostelIDs.add(result.data!["getAnnouncements"]
                          ["announcementsList"][i]["hostels"][j]["id"]);
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
                                  .map((post) => AnnouncementsCards(context,role,id,refetch,post))
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
        });
  }
}
