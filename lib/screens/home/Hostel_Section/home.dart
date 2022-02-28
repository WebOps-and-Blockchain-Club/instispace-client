import 'package:client/graphQL/home.dart';
import 'package:client/screens/home/Announcements/home.dart';
import 'package:client/screens/home/Hostel_Section/hostel_contacts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:client/screens/home/hostel_profile.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class HostelHome extends StatefulWidget {
  const HostelHome({Key? key}) : super(key: key);

  @override
  _HostelHomeState createState() => _HostelHomeState();
}

class _HostelHomeState extends State<HostelHome> {
  String getMe = homeQuery().getMe;
  int _selectedIndex = 1;
  String hostelName = "";
  PageController _pageController = PageController(initialPage: 1);

  static const List<Widget> _widgetOptions = <Widget>[
    HostelProfile(),
    Announcements(),
    Hostelcontacts(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
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

      String role = result.data!["getMe"]["role"];

      if (role != 'ADMIN') {
        hostelName = result.data!["getMe"]["hostel"]["name"];
      }
      //User UI
      return Scaffold(
        appBar: AppBar(
          title: Text("$hostelName Hostel",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,

            ),
          ),
          backgroundColor: Color(0xFF2B2E35),
          elevation: 0.0,
          automaticallyImplyLeading: true,
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: _onItemTapped,
          children: const [
            HostelProfile(),
            Announcements(),
            Hostelcontacts()
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF2B2E35),
          unselectedItemColor: Colors.grey,
          selectedItemColor: const Color(0xFFFFFFFF),
          currentIndex: _selectedIndex,

          iconSize: 24,
          selectedFontSize: 13,
          unselectedFontSize: 12,

          items: const <BottomNavigationBarItem>[
            //L&F Button
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'Amenities',
              backgroundColor: Color(0xFF2B2E35),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.announcement),
              label: 'Announcements',
              backgroundColor: Color(0xFF2B2E35),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.contacts),
              label: 'Contacts',
              backgroundColor: Color(0xFF2B2E35),
            ),
          ],

          showUnselectedLabels: true,
          elevation: 0.0,

          onTap: (index) {
            _pageController.animateToPage(
                index, duration: Duration(milliseconds: 500),
                curve: Curves.ease);
          },
        ),
      );
    }
    );
  }
}