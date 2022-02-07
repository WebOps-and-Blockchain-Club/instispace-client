import 'package:client/models/homeClasses.dart';
import 'package:client/models/tag.dart';
import 'package:client/screens/Events/home.dart';
import 'package:client/screens/home/Announcements/home.dart';
import 'package:client/screens/home/homeCards.dart';
import 'package:client/screens/home/userpage.dart';
import 'package:client/screens/userInit/updatepass.dart';
import 'package:flutter/material.dart';
import 'package:client/services/Auth.dart';
import 'package:provider/provider.dart';
import 'lost and found/home.dart';
import 'networking_and _opportunities/post_listing.dart';
import 'package:client/graphQL/home.dart';
import 'package:graphql_flutter/graphql_flutter.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const routeName = "/home";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AuthService _auth;
  String getMe = homeQuery().getMe;
  String getMeHome = homeQuery().getMeHome;
  var result;
  late String userName;
  late String userRole;
  List<eventsClass> events = [];
  List<eventsClass> netops = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _auth = Provider.of<AuthService>(context, listen: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: gql(getMe),
        ),
        builder: (QueryResult result, {fetchMore, refetch}) {
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

          userRole = result.data!["getMe"]["role"];
          print(userRole);

          if (userRole == "ADMIN" || userRole == "HAS" || userRole == "HOSTEL_SEC") {
            return Scaffold(
              appBar: AppBar(
                title: Text("Hey ${userRole}"),
                backgroundColor: Colors.deepPurpleAccent,
                actions: [
                  IconButton(onPressed: () {_auth.clearAuth();}, icon: Icon(Icons.logout))
                ],
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 500,
                    child: Center(
                      child: Text(
                        "HOMEPAGE !!!",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 50.0,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) => EventsHome()));
                              },
                            iconSize: 30.0,
                              icon: Icon(Icons.event),
                          ),
                          Text("Events",style: TextStyle(fontSize: 10.0),),
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) => Announcements()));
                              },
                              iconSize: 30.0,
                              icon: Icon(Icons.announcement)
                          ),
                          Text("Announcements", style: TextStyle(fontSize: 10.0),)
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) => Post_Listing()));
                            },
                              iconSize: 30.0,
                            icon: Icon(Icons.connect_without_contact_sharp)
                          ),
                          Text("Networking & Opportunities", style: TextStyle(fontSize: 10.0),)
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) => LNFListing()));
                            },
                              iconSize: 30.0,
                            icon: Icon(Icons.local_grocery_store_outlined)
                          ),
                          Text("Lost & Found", style: TextStyle(fontSize: 10.0),)
                        ],
                      )
                    ],
                  )
                ],
              ),
            );
          }
          else {
            return Query(
            options: QueryOptions(
            document: gql(getMeHome),
    ),
    builder: (QueryResult result, {fetchMore, refetch}) {
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
      events.clear();
      for (var i = 0; i < result.data!["getMe"]["getHome"]["events"].length; i++) {
        List<Tag> tags = [];
        for(var k=0;k < result.data!["getMe"]["getHome"]["events"][i]["tags"].length;k++){
          // print("Tag_name: ${netopList[i]["tags"][k]["title"]}, category: ${netopList[i]["tags"][k]["category"]}");
          tags.add(
            Tag(
              Tag_name: result.data!["getMe"]["getHome"]["events"][i]["tags"][k]["title"],
              category: result.data!["getMe"]["getHome"]["events"][i]["tags"][k]["category"],
              id: result.data!["getMe"]["getHome"]["events"][i]["tags"][k]["id"],
            ),
          );
        }
        events.add(eventsClass(
            title: result.data!["getMe"]["getHome"]["events"][i]["title"],
            tags: tags,
            id: result.data!["getMe"]["getHome"]["events"][i]["id"],
            isStared: result.data!["getMe"]["getHome"]["events"][i]["isStared"],
            // location: result.data!["getMe"]["getHome"]["events"][i]["location"],
        ));
      }
      netops.clear();
      for (var i = 0; i < result.data!["getMe"]["getHome"]["netops"].length; i++) {
        List<Tag> tags = [];
        for(var k=0;k < result.data!["getMe"]["getHome"]["netops"][i]["tags"].length;k++){
          // print("Tag_name: ${netopList[i]["tags"][k]["title"]}, category: ${netopList[i]["tags"][k]["category"]}");
          tags.add(
            Tag(
              Tag_name: result.data!["getMe"]["getHome"]["netops"][i]["tags"][k]["title"],
              category: result.data!["getMe"]["getHome"]["netops"][i]["tags"][k]["category"],
              id: result.data!["getMe"]["getHome"]["netops"][i]["tags"][k]["id"],
            ),
          );
        }
        netops.add(eventsClass(
          title: result.data!["getMe"]["getHome"]["netops"][i]["title"],
          tags: tags,
          id: result.data!["getMe"]["getHome"]["netops"][i]["id"],
          isStared: result.data!["getMe"]["getHome"]["netops"][i]["isStared"],
        ));
      }
      userName = result.data!["getMe"]["name"];
      return Scaffold(
          appBar: AppBar(
            title:
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => UserPage()));
                    },
                    icon: Icon(Icons.account_circle_outlined)
                ),
                Text("Hey ${userName
                    .split(" ")
                    .first} "),
              ],
            ),
            backgroundColor: Colors.deepPurpleAccent,
            actions: [
              Column(
                children: [
                  IconButton(
                      onPressed: () {
                        _auth.clearAuth();
                      },
                      icon: Icon(Icons.logout)
                  ),
                  Text("Logout", style: TextStyle(fontSize: 10.0),)
                ],
              )
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Text("Events"),
                SizedBox(
                  height: 250,
                  child: ListView(
                      children : events
                            .map((events) => EventsHomeCard(
                          events: events,
                        ))
                            .toList(),
                      ),
                ),
                Text("Networking & Opportunities"),
                SizedBox(
                  height: 250,
                  child: ListView(
                    children : netops
                        .map((netops) => NetOpHomeCard(
                      netops: netops,
                    ))
                        .toList(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) => EventsHome()));
                          },
                          iconSize: 30.0,
                          icon: Icon(Icons.event),
                        ),
                        Text("Events",style: TextStyle(fontSize: 10.0),),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) => Announcements()));
                            },
                            iconSize: 30.0,
                            icon: Icon(Icons.announcement)
                        ),
                        Text("Announcements", style: TextStyle(fontSize: 10.0),)
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) => Post_Listing()));
                            },
                            iconSize: 30.0,
                            icon: Icon(Icons.connect_without_contact_sharp)
                        ),
                        Text("Networking & Opportunities", style: TextStyle(fontSize: 10.0),)
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) => LNFListing()));
                            },
                            iconSize: 30.0,
                            icon: Icon(Icons.local_grocery_store_outlined)
                        ),
                        Text("Lost & Found", style: TextStyle(fontSize: 10.0),)
                      ],
                    )
                  ],
                )
              ],
            ),
          ));
    }
            );
          }
    }
    );
  }
}
