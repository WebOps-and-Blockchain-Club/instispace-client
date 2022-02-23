import 'package:client/main.dart';
import 'package:client/models/post.dart';
import 'package:client/models/tag.dart';
import 'package:client/screens/Events/home.dart';
import 'package:client/screens/Events/post.dart';
import 'package:client/screens/Login/createAmenity.dart';
import 'package:client/screens/Login/createHostelContacts.dart';
import 'package:client/screens/Login/createhostel.dart';
import 'package:client/screens/home/Announcements/Announcement.dart';
import 'package:client/screens/home/Announcements/home.dart';
import 'package:client/screens/home/Queries/home.dart';
import 'package:client/screens/home/homeCards.dart';
import 'package:client/screens/home/searchUser.dart';
import 'package:client/screens/home/userpage.dart';
import 'package:client/services/notification.dart';
import 'package:client/services/storeMe.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:client/services/Auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
  // late StoreMe _storeMe;
  String getMe = homeQuery().getMe;
  String getMeHome = homeQuery().getMeHome;

  var result;
  late String userName;
  late String userRole;
  Map all = {};
  late String fcmtoken;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _auth = Provider.of<AuthService>(context, listen: false);
      // _storeMe = Provider.of<StoreMe>(context,listen: false);
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if(notification !=null && android !=null){
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            )
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message){
      print('A new onMessageOpenedApp event was published');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if(notification !=null && android != null){
        showDialog(
            context: context,
            builder:(_){
              return AlertDialog(
                title: Text(notification.title!),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notification.body!)
                    ],
                  ),
                ),
              );
            }
        );
      }
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
          // var data = result.data!["getMe"];
          // List<String> interests = [];
          // for(var i=0;i<data["interest"].length;i++){
          //  interests.add("${data["interest"][i]}");
          // }
          // _storeMe.setUser(data["roll"], data["name"], data["role"], "", interests);
          userRole = result.data!["getMe"]["role"];
          // _storeMe.loadUser();
          // print("user data:roll:${_storeMe.roll},name:${_storeMe.name},role:${_storeMe.role},mobile:${_storeMe.mobile},interests:${_storeMe.interest}");
          print(userRole);

          if (userRole == "ADMIN" || userRole == "HAS" || userRole == "HOSTEL_SEC") {
            return Scaffold(
              appBar: AppBar(
                title: Text("Hey ${userRole}"),
                backgroundColor: Colors.deepPurpleAccent,
                actions: [
                  IconButton(onPressed: () {_auth.clearAuth();}, icon: Icon(Icons.logout)),
                  IconButton(onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => searchUser()));
                  }, icon: Icon(Icons.search_outlined)),
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
                  IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => QueryHome()));
                  },
                  iconSize: 30.0,
                  icon: Icon(Icons.query_stats_rounded),
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
              IconButton(onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => Notifications()));
              }, icon: Icon(Icons.notifications_active)),
              IconButton(onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => searchUser()));
              }, icon: Icon(Icons.search_outlined)),
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
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => HostelProfile()));
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
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => QueryHome()));
                  },
                  iconSize: 30.0,
                  icon: Icon(Icons.query_stats_rounded),
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
