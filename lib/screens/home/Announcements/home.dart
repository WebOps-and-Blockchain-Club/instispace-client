import 'package:client/graphQL/announcement_queries.dart';
import 'package:client/graphQL/home.dart';
import 'package:client/screens/home/Announcements/AnnouncementCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:client/screens/home/Announcements/add_announcements.dart';
import 'package:client/screens/home/Announcements/Announcement.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Announcements extends StatefulWidget {
  @override
  _AnnouncementsState createState() => _AnnouncementsState();
}

String getAnnouncements = AnnouncementQueries().getAnnouncements;
String getAllAnnouncements = AnnouncementQueries().getAllAnnouncements;
String getMe = homeQuery().getMe;

List<Announcement> announcements = [];

var ScaffoldKey = GlobalKey<ScaffoldState>();

class _AnnouncementsState extends State<Announcements> {
  static var role;
  late String userHostelID;
  int skip = 0;
  int take = 10;
  ScrollController scrollController = ScrollController();
  late int total;

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: gql(getMe),
        ),
        builder: (QueryResult result, {fetchMore, refetch}) {
          if (result.isLoading) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "Announcements",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
                elevation: 0.0,
                backgroundColor: Colors.deepPurpleAccent,
              ),
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.blue[700],
                ),
              ),
            );
          }
          if (result.hasException) {
            print(result.exception.toString());
          }
          role = result.data!["getMe"]["role"];
          if (role == "ADMIN" || role == "HAS" || role == "HOSTEL_SEC") {
            return Query(
                options: QueryOptions(
                    document: gql(getAllAnnouncements),
                    variables: {"skip": skip, "take": take}),
                builder: (QueryResult result, {fetchMore, refetch}) {
                  if (announcements.isEmpty && result.isLoading) {
                    return Scaffold(
                      appBar: AppBar(
                        title: Text(
                          "Announcements",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                        elevation: 0.0,
                        backgroundColor: Colors.deepPurpleAccent,
                      ),
                      body: Center(
                        child: CircularProgressIndicator(
                          color: Colors.blue[700],
                        ),
                      ),
                    );
                  }
                  if (result.hasException) {
                    print(result.exception.toString());
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
                        "skip": skip + 10,
                        "take": take,
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
                      title: Text(
                        "Announcements",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                      elevation: 0.0,
                      backgroundColor: Colors.deepPurpleAccent,
                      actions: [
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      AddAnnouncements(
                                          refetchAnnouncement: refetch)));
                            },
                            icon: Icon(Icons.add_box))
                      ],
                    ),
                    body: Container(
                        child: Padding(
                      padding: const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 0.0),
                      child: ListView(
                          controller: scrollController,
                          children: [
                            Column(
                              children: announcements
                              .map((post) => AnnouncementCard(
                                    announcement: post,
                                    refetchAnnouncement: refetch,
                                  ))
                              .toList(),
                            ),
                            if (result.isLoading)
                          Center(
                            child: CircularProgressIndicator(
                              color: Colors.blue[700],
                            ),
                          ),
                      ]),
                    )),
                  );
                });
          } else {
            userHostelID = result.data!["getMe"]["hostel"]["id"];
            print(userHostelID);
            return Query(
                options: QueryOptions(
                    document: gql(getAnnouncements),
                    variables: {
                      "hostelId": userHostelID,
                      "skip": skip,
                      "take": take
                    }),
                builder: (QueryResult result, {fetchMore, refetch}) {
                  if (result.hasException) {
                    print(result.exception.toString());
                  }
                  if (announcements.isEmpty && result.isLoading) {
                    return Scaffold(
                      appBar: AppBar(
                        title: Text(
                          "Announcements",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                        elevation: 0.0,
                        backgroundColor: Colors.deepPurpleAccent,
                      ),
                      body: Center(
                        child: CircularProgressIndicator(
                          color: Colors.blue[700],
                        ),
                      ),
                    );
                  }
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
                        "skip": skip + 10,
                        "take": take,
                      },
                      updateQuery: (previousResultData, fetchMoreResultData) {
                        // print("previousResultData:$previousResultData");
                        // print("fetchMoreResultData:${fetchMoreResultData!["getNetops"]["total"]}");
                        // print("posts:$posts");
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
                    appBar: AppBar(
                      title: Text(
                        "Announcements",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                      elevation: 0.0,
                      backgroundColor: Colors.deepPurpleAccent,
                    ),
                    body: Container(
                        child: Padding(
                      padding: const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 0.0),
                      child: ListView(controller: scrollController, children: [
                        Column(
                          children: announcements
                              .map((post) => AnnouncementCard(
                                    announcement: post,
                                    refetchAnnouncement: refetch,
                                  ))
                              .toList(),
                        ),
                        if (result.isLoading)
                          Center(
                            child: CircularProgressIndicator(
                              color: Colors.blue[700],
                            ),
                          ),
                      ]),
                    )),
                  );
                });
          }
        });
  }
}
