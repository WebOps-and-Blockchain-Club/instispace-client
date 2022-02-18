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
  Widget build(BuildContext context) {
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