import 'package:client/models/post.dart';
import 'package:client/models/tag.dart';
import 'package:client/screens/Events/home.dart';
import 'package:client/screens/Events/post.dart';
import 'package:client/screens/Login/createAmenity.dart';
import 'package:client/screens/Login/createHostelContacts.dart';
import 'package:client/screens/Login/createhostel.dart';
import 'package:client/screens/home/Announcements/Announcement.dart';
import 'package:client/screens/home/Announcements/home.dart';
import 'package:client/screens/home/homeCards.dart';
import 'package:client/screens/home/userpage.dart';
import 'package:client/screens/userInit/updatepass.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:client/services/Auth.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'hostel_profile.dart';
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
Map all = {};

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
                  Container(
                    height: 500,
                    child: Column(
                      children: [
                        Text(
                          "HOMEPAGE !!!",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) => CreateHostel()
                              ));
                            }, child: Text("Create New Hostel")),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) => CreateHostelAmenity()
                              ));
                            }, child: Text("Create Hostel Amenity")),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) => CreateHostelContact()
                              ));
                            }, child: Text("Create Hostel Contact"))
                      ],
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
                              icon: const Icon(Icons.event),
                          ),
                          const Text("Events",style: TextStyle(fontSize: 10.0),),
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
      all.clear();
      for(var i = 0; i < result.data!["getMe"]["getHome"]["announcements"].length; i++){
        all.putIfAbsent(Announcement(
            title: result.data!["getMe"]["getHome"]["announcements"][i]["title"],
            hostelIds: [],
            description: result.data!["getMe"]["getHome"]["announcements"][i]["description"],
            endTime: '',
            id: result.data!["getMe"]["getHome"]["announcements"][i]["id"],
            images: result.data!["getMe"]["getHome"]["announcements"][i]["images"],
            createdByUserId: ''
        ), () => "announcement");
      }
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
        all.putIfAbsent(Post(
            title: result.data!["getMe"]["getHome"]["events"][i]["title"],
            tags: tags,
            id: result.data!["getMe"]["getHome"]["events"][i]["id"],
          createdById: '',
          likeCount: 0,
          imgUrl: [],
          linkName: '',
          description: '',
          time: result.data!["getMe"]["getHome"]["events"][i]["time"],
          location: result.data!["getMe"]["getHome"]["events"][i]["location"],
          linkToAction: '',
            // location: result.data!["getMe"]["getHome"]["events"][i]["location"],
        ),
            () => "event",
        );
      }
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
        all.putIfAbsent(NetOpPost(
          title: result.data!["getMe"]["getHome"]["netops"][i]["title"],
          tags: tags,
          id: result.data!["getMe"]["getHome"]["netops"][i]["id"], comments: [], like_counter: 0, endTime: '', attachment: '', imgUrl: '', linkToAction: '', linkName: '',
          description: result.data!["getMe"]["getHome"]["netops"][i]["content"],

        ),()=>"netop");
      }
      userName = result.data!["getMe"]["name"];

      print("userName:$userName");
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
              ),
              Column(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => HostelProfile()));
                      },
                      icon: Icon(Icons.account_balance)
                  ),
                  Text("My Hostel", style: TextStyle(fontSize: 10.0),)
                ],
              )
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 500,
                  child: ListView(
                      children :[
                        Column(
                          children: all.keys.map((e) => cardFunction(all[e],e)
                          ).toList(),
                        )
                      ]
                      ),
                ),
                // Text("Networking & Opportunities"),
                // SizedBox(
                //   height: 250,
                //   child: ListView(
                //     children : netops
                //         .map((netops) => NetOpHomeCard(
                //       netops: netops,
                //     ))
                //         .toList(),
                //   ),
                // ),
                // SizedBox(
                //   height: 250,
                //   child: ListView(
                //     children : all
                //         .map((netops) => NetOpHomeCard(
                //       netops: netops,
                //     ))
                //         .toList(),
                //   ),
                // ),
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
  Widget cardFunction (String category, post){
    if(category == "event"){
      return EventsHomeCard(events: post);
    }
    else if(category == "netop"){
      return NetOpHomeCard(netops: post);
    }
    else if(category == "announcement"){
      return AnnouncementHomeCard(announcements: post);
    }
    return Container();
  }
}
