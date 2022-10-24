import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user.dart';
import '../../services/auth.dart';
import '../../services/client.dart';
import '../../services/notification.dart';
import '../../widgets/headers/drawer.dart';
import '../../graphQL/auth.dart';
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
  final LocalNotificationService service = LocalNotificationService();

  int _selectedIndex = 2;

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

  @override
  void initState() {
    getToken();

    FirebaseMessaging.onMessage.listen(service.showFirebaseNotification);

    FirebaseMessaging.instance.onTokenRefresh.listen((newFcmToken) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final _options = MutationOptions(
        document: gql(AuthGQL.updateFCMToken),
        variables: <String, dynamic>{
          'fcmToken': newFcmToken,
        },
      );
      graphQLClient(token).mutate(_options);
    });

    listenToNotification();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(
          auth: widget.auth, user: widget.user, fcmToken: fcmToken!),
      body: IndexedStack(index: _selectedIndex, children: [
        LostAndFoundPage(user: widget.user, scaffoldKey: _scaffoldKey),
        QueriesPage(user: widget.user, scaffoldKey: _scaffoldKey),
        HomePage(
            auth: widget.auth,
            user: widget.user,
            refetch: widget.refetch,
            scaffoldKey: _scaffoldKey),
        EventsPage(user: widget.user, scaffoldKey: _scaffoldKey),
        NetopsPage(user: widget.user, scaffoldKey: _scaffoldKey),
      ]),
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

  void listenToNotification() async {
    String? payload;
    service.onNotificationClick.stream.listen((String? _payload) {
      payload = _payload;
    });
    if (payload == null || payload!.isEmpty) {
      var details = await service.details();
      payload = details?.payload;
    }
    if (payload != null && payload!.isNotEmpty) {
      setState(() {
        switch (payload) {
          case "EVENT":
            _selectedIndex = 3;
            break;
          case "NETOP":
            _selectedIndex = 4;
            break;
          case "QUERY":
            _selectedIndex = 1;
            break;
          case "LnF":
            _selectedIndex = 0;
            break;
          case "HOSTEL":
            navigate(context, HostelWrapper(user: widget.user));
            break;
          default:
        }
      });
    }
  }
}
