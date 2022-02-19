import 'package:client/screens/home/Announcements/home.dart';
import 'package:client/screens/home/Hostel_Section/hostel_contacts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:client/screens/home/hostel_profile.dart';
import 'package:provider/provider.dart';

class HostelHome extends StatefulWidget {
  const HostelHome({Key? key}) : super(key: key);

  @override
  _HostelHomeState createState() => _HostelHomeState();
}

class _HostelHomeState extends State<HostelHome> {
  int _selectedIndex = 1;
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
            //User UI
            return Scaffold(

              body: PageView(
                controller: _pageController,
                onPageChanged: _onItemTapped,
                children: [
                  HostelProfile(),
                  Announcements(),
                  Hostelcontacts()
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.shifting,
                // backgroundColor: Color(0xFF5451FD),
                currentIndex: _selectedIndex,
                items: const <BottomNavigationBarItem>[

                  //L&F Button
                  BottomNavigationBarItem(
                    icon: Icon(Icons.category),
                    label: 'Hostel Ammenities',
                    backgroundColor: Color(0xFF5451FD),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.announcement),
                    label: 'Announcements',
                    backgroundColor: Color(0xFF5451FD),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.contacts),
                    label: 'Hostel Contacts',
                    backgroundColor: Color(0xFF5451FD),
                  ),
                ],
                selectedItemColor: Color(0xFFFFFFFF),
                showUnselectedLabels: true,
                onTap: (index) {
                  _pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
                },
              ),
            );
  }
}