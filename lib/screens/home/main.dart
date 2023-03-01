import 'package:client/screens/academics/main.dart';
import 'package:client/screens/home/post/main.dart';
import 'package:client/utils/custom_icons.dart';
import 'package:client/widgets/home_app_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/category.dart';
import '../../models/user.dart';
import '../../services/auth.dart';
import '../../services/client.dart';
import '../../services/notification.dart';
import '../../widgets/headers/drawer.dart';
import '../../graphQL/auth.dart';
// import '../hostel/main.dart';
// import 'events/events.dart';
// import 'events/event.dart';
// import 'netops/netop.dart';
// import 'queries/query.dart';
import 'main/home.dart';
// import 'lost_and_found.dart/main.dart';
// import 'lost_and_found.dart/lost_and_found.dart';
// import 'netops/netops.dart';
// import 'queries/main.dart';
// import 'feed/feed.dart';

class HomeWrapper extends StatefulWidget {
  final AuthService auth;
  final UserModel user;
  // final String? navigatePath;
  // final Future<void> Function() refetch;

  const HomeWrapper({
    Key? key,
    required this.auth,
    required this.user,
    // required this.refetch,
    // required this.navigatePath,
  }) : super(key: key);

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final LocalNotificationService service = LocalNotificationService();

  List<int> tappedIndex = [0];
  List<int> loadedIndex = [];

  void _onItemTapped(int index) {
    setState(() {
      // if (tappedIndex[tappedIndex.length - 1] != index) print(tappedIndex);
      tappedIndex = [...tappedIndex, index];
      if (!loadedIndex.contains(index)) loadedIndex.add(index);
    });
  }

  late String? fcmToken = "";

  Future<void> getToken() async {
    String? _fcmToken = await FirebaseMessaging.instance.getToken();
    setState(() {
      fcmToken = _fcmToken;
    });
  }

  // final _bucket = PageStorageBucket();

  // var widgetList = (widget, _scaffoldKey, index) => [
  //       HomePage(
  //         key: PageStorageKey("HOME"),
  //         auth: widget.auth,
  //         user: widget.user,
  //         appBar: HomeAppBar(
  //           title: "",
  //           scaffoldKey: _scaffoldKey,
  //           photo: widget.auth.user?.photo ?? "",
  //         ),
  //       ),
  //       PostPage(
  //         key: PageStorageKey("FEED"),
  //         appBar: HomeAppBar(
  //           title: "Feed",
  //           scaffoldKey: _scaffoldKey,
  //           photo: widget.auth.user?.photo ?? "",
  //         ),
  //         categories: feedCategories,
  //       ),
  //       PostPage(
  //         key: PageStorageKey("FORUM"),
  //         appBar: HomeAppBar(
  //           title: "Forum",
  //           scaffoldKey: _scaffoldKey,
  //           photo: widget.auth.user?.photo ?? "",
  //         ),
  //         categories: forumCategories,
  //       ),
  //       AcademicWrapper(
  //         appBar: HomeAppBar(
  //             title: "Academics",
  //             scaffoldKey: _scaffoldKey,
  //             photo: widget.user.photo),
  //       ),
  //       // EventsPage(user: widget.user, scaffoldKey: _scaffoldKey),
  //       PostPage(
  //         key: PageStorageKey("LnF"),
  //         appBar: HomeAppBar(
  //           title: "Lost & Found",
  //           scaffoldKey: _scaffoldKey,
  //           photo: widget.auth.user?.photo ?? "",
  //         ),
  //         categories: lnfCategories,
  //       ),
  //     ][index];

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

    // if (widget.navigatePath != null && widget.navigatePath!.isNotEmpty) {
    //   WidgetsBinding.instance
    //       .addPostFrameCallback((_) => navigateToPath(widget.navigatePath!));
    // }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0.0;
    final _selectedIndex = tappedIndex.last;
    //TODO: Issue
    var screens = [
      _selectedIndex == 0
          ? HomePage(
              auth: widget.auth,
              user: widget.user,
              appBar: HomeAppBar(
                title: "",
                scaffoldKey: _scaffoldKey,
                user: widget.user,
              ),
            )
          : Container(),
      _selectedIndex == 1
          ? PostPage(
              appBar: HomeAppBar(
                title: "Feed",
                scaffoldKey: _scaffoldKey,
                user: widget.user,
              ),
              categories: feedCategories,
            )
          : Container(),
      _selectedIndex == 2
          ? PostPage(
              appBar: HomeAppBar(
                title: "Forum",
                scaffoldKey: _scaffoldKey,
                user: widget.user,
              ),
              categories: forumCategories,
            )
          : Container(),
      _selectedIndex == 3
          ? AcademicWrapper(
              appBar: HomeAppBar(
                  title: "Academics",
                  scaffoldKey: _scaffoldKey,
                  user: widget.user),
            )
          : Container(),
      _selectedIndex == 4
          ? PostPage(
              appBar: HomeAppBar(
                title: "Lost & Found",
                scaffoldKey: _scaffoldKey,
                user: widget.user,
              ),
              categories: lnfCategories,
            )
          : Container(),
    ];
    return WillPopScope(
      onWillPop: () async {
        print('==================Popupscope called');
        print(tappedIndex);
        if (tappedIndex.length == 1) {
          // if (!await Navigator.of(context).maybePop()) return true;
          print(true);
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
        resizeToAvoidBottomInset: false,
        drawer: CustomDrawer(
          auth: widget.auth,
          user: widget.user,
          fcmToken: fcmToken!,
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: screens,
        ),
        // PageStorage(
        //     bucket: _bucket,
        //     child: widgetList(widget, _scaffoldKey, _selectedIndex)),
        bottomNavigationBar: isKeyboardOpen
            ? null
            : BottomNavigationBar(
                showUnselectedLabels: false,
                showSelectedLabels: false,
                currentIndex: _selectedIndex,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(CustomIcons.home, size: 21),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(CustomIcons.feed, size: 21),
                    label: 'Feed',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(CustomIcons.forums, size: 21),
                    label: 'Forums',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(CustomIcons.academics, size: 21),
                    label: 'Academics',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(CustomIcons.lost_and_found, size: 21),
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
      // switch (type) {
      //   case "event":
      //     navigate(context, EventPage(id: id));
      //     break;
      //   case "netop":
      //     navigate(context, NetopPage(id: id));
      //     break;
      //   case "query":
      //     navigate(context, QueryPage(id: id));
      //     break;
      //   case "lostnfound":
      //     navigate(context, LostnFoundPage(id: id));
      //     break;
      //   case "hostel":
      //     navigate(context, HostelWrapper(user: widget.auth.user!));
      //     break;
      //   case "admin/reports":
      //     navigate(context, const ReportedPostPage());
      //     break;
      //   default:
      // }
    }
  }
}
