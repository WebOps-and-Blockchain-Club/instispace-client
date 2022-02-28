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
import 'Hostel_Section/home.dart';
import 'feedback_type_pages/about_us.dart';
import 'feedback_type_pages/contact_us.dart';
import 'feedback_type_pages/feedback.dart';
import 'home.dart';
import 'package:bottom_drawer/bottom_drawer.dart';
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
            //User UI
            return Scaffold(
              appBar: AppBar(
                backgroundColor: const Color(0xFF2B2E35),
                titleSpacing: 0,
                // backgroundColor: Colors.white,
                title: Row(
                  children: const [
                    CircleAvatar(
                        radius: 18,
                        backgroundImage: NetworkImage('https://pbs.twimg.com/profile_images/1459179322854367232/Zj38Rken_400x400.jpg')
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(8.0,0.0,0,0),
                      child: Text("InstiSpace",style: TextStyle(color: Colors.white),),
                    ),
                  ],
                ),
                actions: [
                  // IconButton(onPressed: (){
                  //   Navigator.of(context).push(MaterialPageRoute(
                  //       builder: (BuildContext context) => const searchUser()));
                  // },
                  //     icon: const Icon(Icons.search_outlined,color: Colors.white,)),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.notifications,color: Colors.white,)
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => const HostelHome()));
                    },
                    icon: const Icon(Icons.account_balance,color: Colors.white,),
                    iconSize: 22.0,
                  )
                ],
                elevation: 0.0,
              ),
              body: Center(
                child: _widgetOptions.elementAt(_selectedIndex),
              ),
              drawer: Drawer(
                child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(2, 10, 0, 10),
                            child: Row(
                              children: const [
                                CircleAvatar(
                                    radius: 20,
                                    backgroundImage: NetworkImage('https://pbs.twimg.com/profile_images/1459179322854367232/Zj38Rken_400x400.jpg')
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(8.0,0.0,0,0),
                                  child: Text("InstiSpace",
                                    style: TextStyle(
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black
                                    ),),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.account_circle_outlined),
                          horizontalTitleGap: 0,
                          title: const Text("My Profile"),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) => UserPage()));
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.vpn_key_sharp),
                          horizontalTitleGap: 0,
                          title: const Text("Update Password"),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) => UserPage()));
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.account_balance),
                          horizontalTitleGap: 0,
                          title: const Text("My Hostel"),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) => HostelHome()));
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.search_outlined),
                          horizontalTitleGap: 0,
                          title: const Text("Search User"),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) => const searchUser()));
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.alternate_email),
                          horizontalTitleGap: 0,
                          title: const Text("About Us"),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) => AboutUs()));
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.contact_page_outlined),
                          horizontalTitleGap: 0,
                          title: const Text("Contact Us"),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) => ContactUs()));
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.feedback_outlined),
                          horizontalTitleGap: 0,
                          title: const Text("Feedback"),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) => FeedBack()));
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.logout),
                          horizontalTitleGap: 0,
                          title: const Text("Logout"),
                          onTap: () {
                            _auth.clearAuth();
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
              bottomNavigationBar: BottomNavigationBar(
                      type: BottomNavigationBarType.fixed,
                      unselectedItemColor: Colors.grey,
                      selectedItemColor: const Color(0xFFFFFFFF),
                      backgroundColor: const Color(0xFF2B2E35),
                      currentIndex: _selectedIndex,

                      iconSize: 24,
                      unselectedFontSize: 12,
                      selectedFontSize: 13,

                      items: const <BottomNavigationBarItem>[
                        //L&F Button
                        BottomNavigationBarItem(
                          icon: Icon(Icons.local_grocery_store),
                          label: 'L&F',
                          backgroundColor: Color(0xFF2B2E35),
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.query_stats_rounded),
                          label: 'Queries',
                          backgroundColor: Color(0xFF2B2E35),
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.home),
                          label: 'Home',
                          backgroundColor: Color(0xFF2B2E35),
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.event),
                          label: 'Events',
                          backgroundColor: Color(0xFF2B2E35),
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.connect_without_contact_sharp),
                          label: 'Net Ops',
                          backgroundColor: Color(0xFF2B2E35),
                        ),
                      ],

                      showUnselectedLabels: true,
                      elevation: 0.0,
                      onTap: _onItemTapped,
                    ),
                  );
  }
}