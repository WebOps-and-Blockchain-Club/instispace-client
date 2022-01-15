import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'add_announcements.dart';

class Announcements extends StatefulWidget {
  const Announcements({Key? key}) : super(key: key);

  @override
  _AnnouncementsState createState() => _AnnouncementsState();
}

var ScaffoldKey = GlobalKey<ScaffoldState>();

class _AnnouncementsState extends State<Announcements> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Announcements",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold
          ),
        ),
        elevation: 0.0,
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
              IconButton(
                  onPressed: () => ScaffoldKey.currentState?.openEndDrawer(),
                  icon: Icon(Icons.filter_alt_outlined)),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => AddAnnouncements()));
                  },
                  icon: Icon(Icons.add_box))
        ],
      ),
    );
  }
}
