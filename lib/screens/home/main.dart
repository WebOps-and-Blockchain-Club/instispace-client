import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../main.dart';
import '../../services/auth.dart';
import '../../widgets/headers/drawer.dart';
import 'events/events.dart';
import 'home.dart';
import 'lostAndFound/LF.dart';
import 'netops/netops.dart';
import 'queries/query.dart';

class HomeWrapper extends StatefulWidget {
  final AuthService auth;

  const HomeWrapper({Key? key, required this.auth}) : super(key: key);

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late String fcmToken;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
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
              iOS: const IOSNotificationDetails(
                sound: 'default.wav',
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
              ),
            ));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title!),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body!)],
                  ),
                ),
              );
            });
      }
    });
  }

  Widget body(int index, widget, scaffoldKey) {
    switch (index) {
      case 0:
        return const LNFListing();

      case 1:
        return const QueryHome();

      case 2:
        return HomePage(auth: widget.auth, scaffoldKey: scaffoldKey);

      case 3:
        return EventsPage(scaffoldKey: scaffoldKey);

      case 4:
        return const Post_Listing();

      default:
        return HomePage(auth: widget.auth, scaffoldKey: scaffoldKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    _firebaseMessaging.getToken().then((token) {
      fcmToken = token!;
    });
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      body: Center(
        child: body(_selectedIndex, widget, _scaffoldKey),
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: const Color(0xFF2f247b),
        selectedItemColor: Colors.purple[400],
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.purple[50],
        currentIndex: _selectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.local_grocery_store),
            label: 'L&F',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.query_stats_rounded),
            label: 'Queries',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.connect_without_contact_sharp),
            label: 'NetOps',
          ),
        ],
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}
