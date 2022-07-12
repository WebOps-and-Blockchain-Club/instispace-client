import 'package:client/graphQL/auth.dart';
import 'package:client/main.dart';
import 'package:client/screens/home/Admin/feedback.dart';
import 'package:client/screens/home/Admin/report.dart';
import 'package:client/screens/home/searchUser.dart';
import 'package:client/screens/home/updateProfile/basicInfo.dart';
import 'package:client/screens/home/userPage.dart';
import 'package:client/services/notification.dart';
import 'package:client/themes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:client/services/Auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:client/screens/home/events/events.dart';
import 'package:client/screens/home/queries/query.dart';
import 'package:client/screens/home/Admin/createHostel.dart';
import 'package:client/screens/home/Admin/createSuperUsers.dart';
import 'package:client/screens/login/createTag.dart';
import 'package:provider/provider.dart';
import 'Admin/updateRole.dart';
import 'package:client/screens/home/hostelSection/hostel.dart';
import 'feedbackTypePages/about_us.dart';
import 'feedbackTypePages/contact_us.dart';
import 'feedbackTypePages/feedback.dart';
import 'home.dart';
import 'lostAndFound/LF.dart';
import 'package:client/screens/home/netops/netops.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class mainHome extends StatefulWidget {
  const mainHome({Key? key}) : super(key: key);
  static const routeName = "/home";

  @override
  _mainHomeState createState() => _mainHomeState();
}

class _mainHomeState extends State<mainHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  ///GraphQL
  String logOut = authQuery().logOut;

  ///Variables
  AuthService _auth = AuthService();
  int _selectedIndex = 2;
  late String userRole;

  /// For Bottom Navigation Bar
  static const List<Widget> _widgetOptions = <Widget>[
    LNFListing(),
    QueryHome(),
    HomePage(),
    EventsPage(),
    Post_Listing(),
  ];

  ///To set the value of index on which page the user is
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _auth = Provider.of<AuthService>(context, listen: false);
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("notification:${message.notification}");
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
      print('A new onMessageOpenedApp event was published');
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
    _sharedPreference();
  }

  void _sharedPreference() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs!.getString('role')!;
      print("userRole : $userRole");
    });
  }

  SharedPreferences? prefs;

  late String fcmToken;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  @override
  Widget build(BuildContext context) {
    _firebaseMessaging.getToken().then((token) {
      fcmToken = token!;
      // print("fcmtoken:$token");
    });
    final Color appBarContentColor = Themes.appBarContentColor(context);
    return Scaffold(
      key: _scaffoldKey,
      // appBar: AppBar(
      //   // shadowColor: Colors.purple[],
      //   // leading: Icon(
      //   //   Icons.menu_sharp,
      //   //   color: Colors.white,
      //   // ),
      //   backgroundColor: Colors.purple[50],
      //   // backgroundColor: Color.fromARGB(255, 128, 97, 198),
      //   titleSpacing: 0,
      //   elevation: 0,
      //   centerTitle: true,

      //   leading: Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     child: ElevatedButton(
      //         onPressed: (() => _scaffoldKey.currentState!.openDrawer()),
      //         style: ElevatedButton.styleFrom(
      //             primary: Colors.white,
      //             // padding:
      //             //     const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      //             textStyle: const TextStyle(
      //                 fontSize: 30, fontWeight: FontWeight.bold)),
      //         child: Container(
      //             decoration: BoxDecoration(
      //                 borderRadius: BorderRadius.circular(50),
      //                 color: Colors.white),
      //             child: const Icon(
      //               Icons.menu,
      //               color: Color(0xFF2f247b),
      //             ))),
      //   ),

      //   ///AppName and logo
      //   title: Text(
      //     "EVENTS",
      //     style: TextStyle(
      //         color: Color(0xFF2f247b),
      //         fontSize: 21,
      //         fontWeight: FontWeight.w900,
      //         letterSpacing: 1),
      //   ),
      //   // title: Row(
      //   //   children: const [
      //   //     // CircleAvatar(
      //   //     //     backgroundColor: Colors.transparent,
      //   //     //     radius: 18,
      //   //     //     backgroundImage:
      //   //     //         AssetImage('assets/InstiSpace_logo-black.png')),
      //   //     Padding(
      //   //       padding: EdgeInsets.fromLTRB(8.0, 0.0, 0, 0),
      //   //       child: Text(
      //   //         "InstiSpace",
      //   //         style:
      //   //             TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      //   //       ),
      //   //     ),
      //   //   ],
      //   // ),
      //   // toolbarHeight: MediaQuery.of(context).size.height * 0.09,
      //   actions: [
      //     ///Notifications Button
      //     // IconButton(
      //     //     onPressed: () {
      //     //       Navigator.of(context).push(MaterialPageRoute(
      //     //           builder: (BuildContext context) => const Notifications()));
      //     //     },
      //     //     icon: const Icon(
      //     //       Icons.notifications,
      //     //       color: Colors.black,
      //     //     )),

      //     ///Hostel Section Button
      //     IconButton(
      //       onPressed: () {
      //         Navigator.of(context).push(MaterialPageRoute(
      //             builder: (BuildContext context) => const HostelHome()));
      //       },
      //       icon: const Icon(
      //         Icons.account_balance,
      //         color: Color(0xFF2f247b),
      //       ),
      //       iconSize: 22.0,
      //     )
      //   ],
      // ),

      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),

      ///SideBar (Hamburger)
      drawer: Drawer(
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(2, 10, 0, 10),

                    /// AppName and logo
                    child: Row(
                      children: const [
                        CircleAvatar(
                            radius: 20,
                            backgroundImage:
                                AssetImage('assets/ic_launcher - Copy.png')),
                        Padding(
                          padding: EdgeInsets.fromLTRB(8.0, 0.0, 0, 0),
                          child: Text(
                            "InstiSpace",
                            style: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                ///My Profile Button
                ListTile(
                  leading: const Icon(Icons.account_circle_outlined),
                  horizontalTitleGap: 0,
                  title: const Text("My Profile"),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => UserPage()));
                  },
                ),

                ///Update Profile Button
                ListTile(
                  leading: const Icon(Icons.edit),
                  horizontalTitleGap: 0,
                  title: const Text("Edit Profile"),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => BasicInfo()));
                  },
                ),

                ///My Hostel Button
                if (userRole == 'USER' || userRole == 'MODERATOR')
                  ListTile(
                    leading: const Icon(Icons.account_balance),
                    horizontalTitleGap: 0,
                    title: const Text("My Hostel"),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => HostelHome()));
                    },
                  ),

                ///Search User Button
                ListTile(
                  leading: const Icon(Icons.search_outlined),
                  horizontalTitleGap: 0,
                  title: const Text("Search User"),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => const searchUser()));
                  },
                ),

                ///Create Hostel
                if (userRole == 'ADMIN' || userRole == 'HAS')
                  ListTile(
                    leading: const Icon(Icons.account_balance_outlined),
                    horizontalTitleGap: 0,
                    title: const Text("Create Hostel"),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => CreateHostel()));
                    },
                  ),

                ///Create Tag
                if (userRole == 'ADMIN' ||
                    userRole == "HAS" ||
                    userRole == "SECRETORY")
                  ListTile(
                    leading: const Icon(Icons.add_outlined),
                    horizontalTitleGap: 0,
                    title: const Text('Create Tag'),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => CreateTag()));
                    },
                  ),

                ///Create Account
                if (userRole == "ADMIN" ||
                    userRole == "HAS" ||
                    userRole == "SECRETORY")
                  ListTile(
                    leading: const Icon(Icons.addchart_outlined),
                    horizontalTitleGap: 0,
                    title: const Text('Create Accounts'),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              CreateSuperUsers()));
                    },
                  ),

                ///Update Role
                if (userRole == "ADMIN" ||
                    userRole == "HAS" ||
                    userRole == "SECRETORY" ||
                    userRole == "HOSTEL_SEC" ||
                    userRole == "LEADS")
                  ListTile(
                    leading: const Icon(Icons.upgrade),
                    horizontalTitleGap: 0,
                    title: const Text('Update Role'),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => UpdateRole()));
                    },
                  ),

                ///About us Page Button
                if (userRole == "USER" || userRole == "MODERATOR")
                  ListTile(
                    leading: const Icon(Icons.alternate_email),
                    horizontalTitleGap: 0,
                    title: const Text("About Us"),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => AboutUs()));
                    },
                  ),

                ///Contact Us Page Button
                if (userRole == "USER" || userRole == 'MODERATOR')
                  ListTile(
                    leading: const Icon(Icons.contact_page_outlined),
                    horizontalTitleGap: 0,
                    title: const Text("Contact Us"),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => ContactUs()));
                    },
                  ),

                ///Feedback Page Button
                if (userRole == "USER" || userRole == 'MODERATOR')
                  ListTile(
                    leading: const Icon(Icons.feedback_outlined),
                    horizontalTitleGap: 0,
                    title: const Text("Feedback"),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => FeedBack()));
                    },
                  ),

                ///Feedbacks sheet for Admin
                if (userRole == "ADMIN" || userRole == 'HAS')
                  ListTile(
                    leading: const Icon(Icons.feedback_outlined),
                    horizontalTitleGap: 0,
                    title: const Text("Feedbacks"),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => FeedbackPage()));
                    },
                  ),

                ///reported list
                if (userRole == "ADMIN" || userRole == 'HAS')
                  ListTile(
                    leading: const Icon(Icons.account_circle_outlined),
                    horizontalTitleGap: 0,
                    title: const Text("Reported"),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => Reported()));
                    },
                  ),

                /// Logout Button
                Mutation(
                  options: MutationOptions(
                      document: gql(logOut),
                      onCompleted: (result) async {
                        print("logout result:$result");
                        if (result?["logout"] == true) {
                          await _auth.clearAuth();
                          await _auth.clearMe();
                        }
                      }),
                  builder: (RunMutation runMutation, QueryResult? result) {
                    if (result!.hasException) {
                      print(result.exception.toString());
                    }
                    return ListTile(
                      leading: const Icon(Icons.logout),
                      horizontalTitleGap: 0,
                      title: const Text("Logout"),
                      onTap: () {
                        print("fcmToken logout : $fcmToken");
                        runMutation({
                          "fcmToken": fcmToken,
                        });
                      },
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),

      ///Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Color(0xFF2f247b),
        selectedItemColor: Colors.purple[400],
        type: BottomNavigationBarType.fixed,
        // // type: BottomNavigationBarType.fixed,
        // // selectedItemColor: Colors.white,
        // selectedIconTheme: const IconThemeData(color: Colors.white),
        // unselectedItemColor: Color.fromARGB(255, 255, 209, 221),
        backgroundColor: Colors.purple[50],
        // backgroundColor: Color(0xFF8061C6),

        // backgroundColor: Color.fromARGB(255, 83, 52, 157),
        currentIndex: _selectedIndex,
        // // iconSize: 24,
        // // unselectedFontSize: 13,
        // // selectedFontSize: 13,
        // // elevation: 5,
        items: const <BottomNavigationBarItem>[
          //L&F Button
          BottomNavigationBarItem(
            icon: Icon(Icons.local_grocery_store),
            label: 'L&F',
            // backgroundColor: Color(0xFF2B2E35),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.query_stats_rounded),
            label: 'Queries',
            // backgroundColor: Color(0xFF2B2E35),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            // backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
            // backgroundColor: Color(0xFF2B2E35),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.connect_without_contact_sharp),
            label: 'NetOps',
            // backgroundColor: Color(0xFF2B2E35),
          ),
        ],
        showUnselectedLabels: true,
        // elevation: 1000,
        onTap: _onItemTapped,
      ),
    );
  }
}
