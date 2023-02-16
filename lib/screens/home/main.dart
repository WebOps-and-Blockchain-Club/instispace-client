import 'package:client/models/category.dart';
import 'package:client/utils/custom_icons.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/postModel.dart';
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
import 'feed/feed.dart';

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
      if (tappedIndex[tappedIndex.length - 1] == index) print(tappedIndex);
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
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0.0;
    print(isKeyboardOpen);
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
        //resizeToAvoidBottomInset: false,
        drawer: CustomDrawer(
            auth: widget.auth, user: widget.user, fcmToken: fcmToken!),
        body: IndexedStack(index: _selectedIndex, children: [
          HomePage(
              auth: widget.auth,
              user: widget.user,
              refetch: widget.refetch,
              scaffoldKey: _scaffoldKey),
          FeedPage(
            user: widget.user,
            scaffoldKey: _scaffoldKey,
            title: 'FEED',
          ),
          FeedPage(
            user: widget.user,
            scaffoldKey: _scaffoldKey,
            title: 'FORUM',
          ),
          EventsPage(user: widget.user, scaffoldKey: _scaffoldKey),
          NetopsPage(user: widget.user, scaffoldKey: _scaffoldKey),
        ]),
        bottomNavigationBar: isKeyboardOpen
            ? null
            : BottomNavigationBar(
                showUnselectedLabels: false,
                currentIndex: _selectedIndex,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(CustomIcons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(CustomIcons.feed),
                    label: 'Feed',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(CustomIcons.forums),
                    label: 'Forums',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(CustomIcons.academics),
                    label: 'Academics',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(CustomIcons.lost_and_found),
                    label: 'L&F',
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
