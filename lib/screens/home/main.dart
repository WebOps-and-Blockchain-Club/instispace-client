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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:client/services/Auth.dart';
import 'package:provider/provider.dart';
import 'home.dart';
import 'hostel_profile.dart';
import 'lost and found/home.dart';
import 'networking_and _opportunities/post_listing.dart';
import 'package:client/graphQL/home.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class mainHome extends StatefulWidget {
  const mainHome({Key? key}) : super(key: key);
  static const routeName = "/home";

  @override
  _mainHomeState createState() => _mainHomeState();
}

class _mainHomeState extends State<mainHome> {
  late AuthService _auth;
  String getMe = homeQuery().getMe;
  String getMeHome = homeQuery().getMeHome;

  var result;
  late String userName;
  late String userRole;
  bool isAll = true;
  bool isAnnouncements = false;
  bool isEvents = false;
  bool isNetops = false;
  Map all = {};
  int _selectedIndex = 2;

  static const List<Widget> _widgetOptions = <Widget>[
    LNFListing(),
    QueryHome(),
    HomePage(),
    EventsHome(),
    Post_Listing(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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

          if (userRole == "ADMIN" || userRole == "HAS" || userRole == "HOSTEL_SEC") {
            return Scaffold(
              appBar: AppBar(
                title: Text("Hey ${userRole}"),
                backgroundColor: Colors.deepPurpleAccent,
                actions: [
                  IconButton(
                      onPressed: () {
                        _auth.clearAuth();
                      },
                      icon: const Icon(Icons.logout)),
                  IconButton(
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => const searchUser()));
                      },
                      icon: const Icon(Icons.search_outlined)),
                ],
              ),
              body: ListView(
                  children: [Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 500,
                        child: Column(
                          children: [
                            const Text(
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
                                },
                                child: const Text("Create New Hostel")),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) => const CreateHostelAmenity()
                                  ));
                                },
                                child: const Text("Create Hostel Amenity")),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) => const CreateHostelContact()
                                  ));
                                },
                                child: const Text("Create Hostel Contact"))
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => const QueryHome()));
                        },
                        iconSize: 30.0,
                        icon: const Icon(Icons.query_stats_rounded),
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
                                  icon: const Icon(Icons.announcement)
                              ),
                              const Text("Announcements", style: TextStyle(fontSize: 10.0),)
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
                                  icon: const Icon(Icons.connect_without_contact_sharp)
                              ),
                              const Text("Networking & Opportunities", style: TextStyle(fontSize: 10.0),)
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (BuildContext context) => const LNFListing()));
                                  },
                                  iconSize: 30.0,
                                  icon: const Icon(Icons.local_grocery_store_outlined)
                              ),
                              const Text("Lost & Found", style: TextStyle(fontSize: 10.0),)
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                  ]
              ),
            );
          }
          else {
            //User UI
            return Scaffold(
                    body: Center(
                      child: _widgetOptions.elementAt(_selectedIndex),
                    ),
                    bottomNavigationBar: BottomNavigationBar(
                      currentIndex: _selectedIndex,
                      items: const <BottomNavigationBarItem>[

                        //L&F Button
                        BottomNavigationBarItem(
                          icon: Icon(Icons.local_grocery_store),
                          label: 'L&F',
                          backgroundColor: Color(0xFF5451FD),
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.query_stats_rounded),
                          label: 'Queries',
                          backgroundColor: Color(0xFF5451FD),
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.home),
                          label: 'Home',
                          backgroundColor: Color(0xFF5451FD),
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.event),
                          label: 'Events',
                          backgroundColor: Color(0xFF5451FD),
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.connect_without_contact_sharp),
                          label: 'Net&Op',
                          backgroundColor: Color(0xFF5451FD),
                        ),
                      ],
                      selectedItemColor: Color(0xFFFFFFFF),
                      onTap: _onItemTapped,
                    ),
                  );
          }
        }
    );
  }
}