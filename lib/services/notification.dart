import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';


class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Future<void> initState() async {
    super.initState();
    // prefs = await SharedPreferences.getInstance();
    // bool? isSwitchedNetops = prefs?.getBool('isSwitchedNetops');
    // print("isSwitchedNetops:$isSwitchedNetops");
  }
  SharedPreferences? prefs;
  List<String> notificationPref=[];
  bool isSwitchedNetops = false;
  bool isSwitchedLnF = false;
  bool isSwitchedEvents = false;
  bool isSwitchedQueries = false;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: const Text("Notification setting"),
        ),
        body: Column(
          children: [
            ListTile(
              leading: const Text('Netops'),
              trailing: Switch(
                value: isSwitchedNetops,
                onChanged: (value) async {
                  setState(() {
                    isSwitchedNetops = value;
                    print(isSwitchedNetops);
                    if(isSwitchedNetops){
                      notificationPref.add('Netops');
                    }
                    else{
                      notificationPref.remove('Netops');
                    }
                    print("notificationPrefs:$notificationPref");
                  });
                  prefs = await SharedPreferences.getInstance();
                  prefs?.setStringList('notificationPref', notificationPref );
                  prefs?.setBool('isSwitchedNetops', isSwitchedNetops);
                  var preference =prefs?.getStringList('notificationPref');
                  print("preference: $preference");
                },
                activeTrackColor: Colors.lightGreenAccent,
                activeColor: Colors.green,
              ),
            ),
            ListTile(
              leading: const Text('Lost and Found'),
              trailing: Switch(
                value: isSwitchedLnF,
                onChanged: (value) async {
                  setState(() {
                    isSwitchedLnF = value;
                    print(isSwitchedLnF);
                    if(isSwitchedLnF){
                      notificationPref.add('LnF');
                    }
                    else{
                      notificationPref.remove('LnF');
                    }
                    print("notificationPrefs:$notificationPref");
                  });
                  prefs = await SharedPreferences.getInstance();
                  prefs?.setStringList('notificationPref', notificationPref );
                  prefs?.setBool('isSwitchedLnF', isSwitchedLnF);
                  var preference =prefs?.getStringList('notificationPref');
                  print("preference: $preference");
                },
                activeTrackColor: Colors.lightGreenAccent,
                activeColor: Colors.green,
              ),
            ),
            ListTile(
              leading: const Text('Events'),
              trailing: Switch(
                value: isSwitchedEvents,
                onChanged: (value) async {
                  setState(() {
                    isSwitchedEvents = value;
                    print(isSwitchedEvents);
                    if(isSwitchedEvents){
                      notificationPref.add('Events');
                    }
                    else{
                      notificationPref.remove('Events');
                    }
                    print("notificationPrefs:$notificationPref");
                  });
                  prefs = await SharedPreferences.getInstance();
                  prefs?.setStringList('notificationPref', notificationPref );
                  prefs?.setBool('isSwitchedEvents', isSwitchedEvents);
                  var preference =prefs?.getStringList('notificationPref');
                  print("preference: $preference");
                },
                activeTrackColor: Colors.lightGreenAccent,
                activeColor: Colors.green,
              ),
            ),
            ListTile(
              leading:const Text('Queries'),
              trailing: Switch(
                value: isSwitchedQueries,
                onChanged: (value) async {
                  setState(() {
                    isSwitchedQueries = value;
                    print(isSwitchedQueries);
                    if(isSwitchedQueries){
                      notificationPref.add('Queries');
                    }
                    else{
                      notificationPref.remove('Queries');
                    }
                    print("notificationPrefs:$notificationPref");
                  });
                  prefs = await SharedPreferences.getInstance();
                  prefs?.setStringList('notificationPref', notificationPref );
                  prefs?.setBool('isSwitchedQueries', isSwitchedQueries);
                  var preference =prefs?.getStringList('notificationPref');
                  print("preference: $preference");
                },
                activeTrackColor: Colors.lightGreenAccent,
                activeColor: Colors.green,
              ),
            ),
          ],
        )
    );
  }
}




