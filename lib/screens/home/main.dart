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
import '../super_user/reported_posts.dart';
import '../hostel/main.dart';
import '/widgets/helpers/navigate.dart';
import 'events/events.dart';
import 'events/event.dart';
import 'netops/netop.dart';
import 'queries/query.dart';
import 'main/home.dart';
import 'lost_and_found.dart/main.dart';
import 'lost_and_found.dart/lost_and_found.dart';
import 'netops/netops.dart';
import 'queries/main.dart';

class HomeWrapper extends StatefulWidget {
  final AuthService auth;
  final UserModel user;
  final String? navigatePath;
  final Future<void> Function() refetch;

  const HomeWrapper(
      {Key? key,
      required this.auth,
      required this.user,
      required this.refetch,
      required this.navigatePath})
      : super(key: key);

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final LocalNotificationService service = LocalNotificationService();

  List<int> tappedIndex = [2];

  void _onItemTapped(int index) {
    setState(() {
      tappedIndex = [...tappedIndex, index];
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

    if (widget.navigatePath != null && widget.navigatePath!.isNotEmpty) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => navigateToPath(widget.navigatePath!));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _selectedIndex = tappedIndex.last;
    return WillPopScope(
      onWillPop: () async {
        if (tappedIndex.length == 1) {
          return true;
        } else {
          setState(() {
            tappedIndex.removeLast();
          });
          return false;
        }
      },
      child: Scaffold(
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
      ),
    );
  }
  
  void navigateToPath(String path) {
    final type = path.split("/")[0].toLowerCase();
    final id = path.split("/")[1];

    if (type != "" && type.isNotEmpty && id != "" && id.isNotEmpty) {
      switch (type) {
        case "event":
          navigate(context, EventPage(id: id));
          break;
        case "netop":
          navigate(context, NetopPage(id: id));
          break;
        case "query":
          navigate(context, QueryPage(id: id));
          break;
        case "lostnfound":
          navigate(context, LostnFoundPage(id: id));
          break;
        case "hostel":
          navigate(context, HostelWrapper(user: widget.user));
          break;
        case "admin/reports":
          navigate(context, const ReportedPostPage());
          break;
        default:
      }
    }
  }
}
