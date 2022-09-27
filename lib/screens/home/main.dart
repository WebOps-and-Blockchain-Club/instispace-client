import 'dart:typed_data';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;

import '../../models/user.dart';
import '../../main.dart';
import '../../services/auth.dart';
import '../../widgets/headers/drawer.dart';
import '../hostel/main.dart';
import '/widgets/helpers/navigate.dart';
import 'events/events.dart';
import 'main/home.dart';
import 'lost_and_found.dart/main.dart';
import 'netops/netops.dart';
import 'queries/main.dart';

class HomeWrapper extends StatefulWidget {
  final AuthService auth;
  final UserModel user;
  final Future<QueryResult<Object?>?> Function()? refetch;

  const HomeWrapper(
      {Key? key, required this.auth, required this.user, required this.refetch})
      : super(key: key);

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedIndex = 2;
  String? scrollTo;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  late String? fcmToken = "";

  Future<void> getToken() async {
    String? _fcmToken = await FirebaseMessaging.instance.getToken();
    setState(() {
      fcmToken = _fcmToken;
    });
  }

  Future<Uint8List> _getByteArrayFromUrl(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    return response.bodyBytes;
  }

  @override
  void initState() {
    getToken();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        BigPictureStyleInformation? bigPictureStyleInformation;
        if (message.data["image"] != null) {
          final ByteArrayAndroidBitmap bigPicture = ByteArrayAndroidBitmap(
              await _getByteArrayFromUrl(message.data["image"]));
          bigPictureStyleInformation = BigPictureStyleInformation(bigPicture,
              contentTitle: notification.title,
              htmlFormatContentTitle: true,
              summaryText: notification.body,
              htmlFormatSummaryText: true);
        }
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(channel.id, channel.name,
                  channelDescription: channel.description,
                  color: const Color(0xFF2F247B),
                  playSound: true,
                  icon: '@mipmap/ic_launcher',
                  styleInformation: bigPictureStyleInformation),
              iOS: const IOSNotificationDetails(
                sound: 'default.wav',
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
              ),
            ));
      }
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        setState(() {
          switch (message.data["route"]) {
            case "EVENT":
              _selectedIndex = 3;
              scrollTo = message.data["id"];
              break;
            case "NETOP":
              _selectedIndex = 4;
              scrollTo = message.data["id"];
              break;
            case "QUERY":
              _selectedIndex = 1;
              scrollTo = message.data["id"];
              break;
            case "LnF":
              _selectedIndex = 0;
              scrollTo = message.data["id"];
              break;
            case "HOSTEL":
              navigate(context, HostelWrapper(user: widget.user));
              break;
            default:
          }
        });
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      setState(() {
        switch (message.data["route"]) {
          case "EVENT":
            _selectedIndex = 3;
            scrollTo = message.data["id"];
            break;
          case "NETOP":
            _selectedIndex = 4;
            scrollTo = message.data["id"];
            break;
          case "QUERY":
            _selectedIndex = 1;
            scrollTo = message.data["id"];
            break;
          case "LnF":
            _selectedIndex = 0;
            scrollTo = message.data["id"];
            break;
          case "HOSTEL":
            navigate(context, HostelWrapper(user: widget.user));
            break;
          default:
        }
      });
    });

    super.initState();
  }

  Widget body(int index, AuthService auth, UserModel user, scaffoldKey) {
    switch (index) {
      case 0:
        return LostAndFoundPage(user: user, scaffoldKey: scaffoldKey);

      case 1:
        return QueriesPage(user: user, scaffoldKey: scaffoldKey);

      case 2:
        return HomePage(
            auth: auth,
            user: user,
            refetch: widget.refetch,
            scaffoldKey: scaffoldKey);

      case 3:
        return EventsPage(user: user, scaffoldKey: scaffoldKey);

      case 4:
        return NetopsPage(user: user, scaffoldKey: scaffoldKey);

      default:
        return HomePage(
            auth: widget.auth,
            user: user,
            refetch: widget.refetch,
            scaffoldKey: scaffoldKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(
          auth: widget.auth, user: widget.user, fcmToken: fcmToken!),
      body: Center(
        child: body(_selectedIndex, widget.auth, widget.user, _scaffoldKey),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.travel_explore),
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
        onTap: _onItemTapped,
      ),
    );
  }
}
