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

String getAnnouncements = homeQuery().getAnnouncements;
String getAllAnnouncements = homeQuery().getAllAnnouncements;
String getMe = homeQuery().getMe;

List<Announcement> announcements = [];

var ScaffoldKey = GlobalKey<ScaffoldState>();

class _AnnouncementsState extends State<Announcements> {

  static var role;
  // late String image;
  late String userHostelID;

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: gql(getMe),),
        builder: (QueryResult result, {fetchMore, refetch}) {
          if (result.hasException) {
            print(result.exception.toString());
          }
          if (result.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: Colors.blue[700],),
            );
          }
          role = result.data!["getMe"]["role"];
          if (role == "ADMIN" || role == "HAS" || role == "HOSTEL_SEC") {
            return Query(
                options: QueryOptions(
                    document: gql(getAllAnnouncements),
                    ),
                builder: (QueryResult result, {fetchMore, refetch}) {
                  if (result.hasException) {
                    print(result.exception.toString());
                  }
                  if (result.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(color: Colors.blue[700],),
                    );
                  }
                  announcements.clear();
                  for (var i = 0; i <
                      result.data!["getAllAnnouncements"].length; i++) {
                    List<String> hostelIDs = [];
                    for (var j = 0; j <
                        result.data!["getAllAnnouncements"][i]["hostels"].length; j++) {
                      hostelIDs.add(result.data!["getAllAnnouncements"][i]["hostels"][j]["name"]);
                    }
                    // List<String> images = [];
                    // for (var j = 0; j <
                    //     result.data!["getAllAnnouncements"][i]["images"].length; j++) {
                    //   images.add(result.data!["getAllAnnouncements"][i]["images"][j]);
                    // }
                    // print(images);

                    announcements.add(Announcement(
                      title: result.data!["getAllAnnouncements"][i]["title"],
                      description: result.data!["getAllAnnouncements"][i]["description"],
                      endTime: result.data!["getAllAnnouncements"][i]["endTime"],
                      id: result.data!["getAllAnnouncements"][i]["id"],
                      hostelIds: hostelIDs,
                      images: result.data!["getAllAnnouncements"][i]["images"],
                    ));
                  }

                  return Scaffold(
                    key: ScaffoldKey,
                    appBar: AppBar(
                      title: Text(
                        "Announcements",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      elevation: 0.0,
                      backgroundColor: Colors.deepPurpleAccent,
                      actions: [
                        IconButton(
                            onPressed: () =>
                                ScaffoldKey.currentState?.openEndDrawer(),
                            icon: Icon(Icons.filter_alt_outlined)),
                          IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        AddAnnouncements(refetchAnnouncement: refetch)));
                              },
                              icon: Icon(Icons.add_box))
                      ],
                    ),
                    body: Container(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 0.0),
                          child: ListView(
                              children: [
                                Column(
                                  children: announcements.map((post) =>
                                      AnnouncementCard(
                                        announcement: post,
                                        refetchAnnouncement: refetch,
                                      )).toList(),
                                ),
                              ]
                          ),)
                    ),
                    // endDrawer: Drawer(
                    //     child: Container(
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.center,
                    //         children: [
                    //           Padding(
                    //             padding: const EdgeInsets.fromLTRB(10.0, 10.0,
                    //                 10.0, 10.0),
                    //             child: SizedBox(
                    //               height: 250.0,
                    //               child: Text(
                    //                 "Sort By",
                    //                 style: TextStyle(
                    //                   fontWeight: FontWeight.bold,
                    //                   fontSize: 20.0,
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //           Padding(
                    //             padding: const EdgeInsets.fromLTRB(10.0, 0.0,
                    //                 10.0, 0.0),
                    //             child: SizedBox(
                    //               height: 280.0,
                    //               child: Text(
                    //                 "Filter",
                    //                 style: TextStyle(
                    //                   fontWeight: FontWeight.bold,
                    //                   fontSize: 20.0,
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     )
                    // ),
                  );
                }
            );
          }
          else {
            userHostelID = result.data!["getMe"]["hostel"]["id"];
            print(userHostelID);
            return Query(
                options: QueryOptions(
                    document: gql(getAnnouncements),
                    variables: {"hostelId": userHostelID}),
                builder: (QueryResult result, {fetchMore, refetch}) {
                  if (result.hasException) {
                    print(result.exception.toString());
                  }
                  if (result.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(color: Colors.blue[700],),
                    );
                  }

                  for (var i = 0; i <
                      result.data!["getAnnouncements"].length; i++) {
                    List<String> hostelIDs = [];
                    for (var j = 0; j <
                        result.data!["getAnnouncements"][i]["hostels"].length; j++) {
                      hostelIDs.add(result.data!["getAnnouncements"][i]["hostels"][j]["id"]);
                    }
                    // List<String> images = [];
                    // for (var j = 0; j <
                    //     result.data!["getAnnouncements"][i]["images"].length; j++) {
                    //   images.add(result.data!["getAnnouncements"][i]["images"][j]["id"]);
                    // }
                    announcements.add(Announcement(
                      title: result.data!["getAnnouncements"][i]["title"],
                      description: result.data!["getAnnouncements"][i]["description"],
                      endTime: result.data!["getAnnouncements"][i]["endTime"],
                      id: result.data!["getAnnouncements"][i]["id"],
                      hostelIds: hostelIDs,
                      images: result.data!["getAllAnnouncements"][i]["images"],
                    ));

                  }
                  return Scaffold(
                    key: ScaffoldKey,
                    appBar: AppBar(
                      title: Text(
                        "Announcements",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      elevation: 0.0,
                      backgroundColor: Colors.deepPurpleAccent,
                      actions: [
                        IconButton(
                            onPressed: () =>
                                ScaffoldKey.currentState?.openEndDrawer(),
                            icon: Icon(Icons.filter_alt_outlined)),
                      ],
                    ),
                    body: Container(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 0.0),
                          child: ListView(
                              children: [
                                Column(
                                  children: announcements.map((post) =>
                                      AnnouncementCard(
                                        announcement: post,
                                        refetchAnnouncement: refetch,
                                      )).toList(),
                                ),
                              ]
                          ),)
                    ),
                    endDrawer: Drawer(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10.0, 10.0,
                                    10.0, 10.0),
                                child: SizedBox(
                                  height: 250.0,
                                  child: Text(
                                    "Sort By",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10.0, 0.0,
                                    10.0, 0.0),
                                child: SizedBox(
                                  height: 280.0,
                                  child: Text(
                                    "Filter",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                  );
                }
            );
          }
        });
  }
  }
