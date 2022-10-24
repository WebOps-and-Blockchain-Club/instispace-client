import 'package:client/screens/hostel/contact/main.dart';
import 'package:flutter/material.dart';

import 'announcement/main.dart';
import 'amenities/main.dart';
import '../../models/user.dart';
import '../../widgets/button/icon_button.dart';
import '../../widgets/headers/main.dart';

class HostelWrapper extends StatefulWidget {
  final UserModel user;

  const HostelWrapper({Key? key, required this.user}) : super(key: key);

  @override
  State<HostelWrapper> createState() => _HostelWrapperState();
}

class _HostelWrapperState extends State<HostelWrapper> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: CustomAppBar(
              title: widget.user.hostelName ?? widget.user.role!,
              leading: CustomIconButton(
                icon: Icons.arrow_back,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )),
          automaticallyImplyLeading: false),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          AmenitiesPage(user: widget.user),
          AnnouncementsPage(user: widget.user),
          ContactsPage(user: widget.user),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Amenities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            label: 'Announcements',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'Contacts',
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}
