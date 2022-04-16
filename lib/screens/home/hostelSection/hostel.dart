import 'package:client/graphQL/home.dart';
import 'package:client/screens/home/hostelSection/announcements/announcements.dart';
import 'package:client/screens/home/hostelSection/contacts/contacts.dart';
import 'package:flutter/material.dart';
import 'package:client/screens/home/hostelSection/amenities/amenities.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class HostelHome extends StatefulWidget {
  const HostelHome({Key? key}) : super(key: key);

  @override
  _HostelHomeState createState() => _HostelHomeState();
}

class _HostelHomeState extends State<HostelHome> {

  ///GraphQL
  String getMe = homeQuery().getMe;

  ///Variables
  int _selectedIndex = 1;
  String hostelName = "";

  ///Controllers
  PageController _pageController = PageController(initialPage: 1);

  ///List for Bottom Navigation Bar
  static const List<Widget> _widgetOptions = <Widget>[
    HostelAmenities(),
    Announcements(),
    Hostelcontacts(),
  ];

  ///Function to change index and hence navigate
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
        return Text(result.exception.toString());
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
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          backgroundColor: const Color(0xFF2B2E35),
          elevation: 0.0,
          automaticallyImplyLeading: true,
        ),

        ///PageView used for swiping feature
        body: PageView(
          controller: _pageController,
          onPageChanged: _onItemTapped,
          children: const [
            HostelAmenities(),
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
                index, duration: const Duration(milliseconds: 500),
                curve: Curves.ease);
          },
        ),
      );
    }
    );
  }
}