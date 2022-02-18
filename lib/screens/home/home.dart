import 'package:client/models/post.dart';
import 'package:client/models/tag.dart';
import 'package:client/screens/Events/home.dart';
import 'package:client/screens/Events/post.dart';
import 'package:client/screens/Login/createAmenity.dart';
import 'package:client/screens/Login/createHostelContacts.dart';
import 'package:client/screens/Login/createhostel.dart';
import 'package:client/screens/home/Announcements/Announcement.dart';
import 'package:client/screens/home/Announcements/home.dart';
import 'package:client/screens/home/Hostel_Section/home.dart';
import 'package:client/screens/home/Queries/home.dart';
import 'package:client/screens/home/feedback_type_pages/about_us.dart';
import 'package:client/screens/home/feedback_type_pages/contact_us.dart';
import 'package:client/screens/home/feedback_type_pages/feedback.dart';
import 'package:client/screens/home/homeCards.dart';
import 'package:client/screens/home/searchUser.dart';
import 'package:client/screens/home/userpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:client/services/Auth.dart';
import 'package:provider/provider.dart';
import 'package:client/screens/home/lost and found/home.dart';
import 'package:client/screens/home/networking_and _opportunities/post_listing.dart';
import 'package:client/graphQL/home.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const routeName = "/home";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AuthService _auth;
  String getMe = homeQuery().getMe;
  String getMeHome = homeQuery().getMeHome;

  var result;
  late String userName;
  late String userRole;
  bool isAll = true;
  bool isAnnouncements = false;
  bool isEvents = false;
  bool isNetops = false;
  Map all = {};

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _auth = Provider.of<AuthService>(context, listen: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: gql(getMe),
        ),
        builder: (QueryResult result, {fetchMore, refetch}) {
          if (result.hasException) {
            print(result.exception.toString());
          }
          if (result.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.blue[700],
              ),
            );
          }
          userRole = result.data!["getMe"]["role"];

          if (userRole == "ADMIN" || userRole == "HAS" || userRole == "HOSTEL_SEC") {
            return Scaffold(
              appBar: AppBar(
                title: Text("Hey ${userRole}"),
                backgroundColor: const Color(0xFF5451FD),
                actions: [
                  IconButton(
                      onPressed: () {
                        _auth.clearAuth();
                      },
                      icon: const Icon(Icons.logout)),
                  IconButton(
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => const searchUser()));
                      },
                      icon: const Icon(Icons.search_outlined)),
                ],
              ),
              body: ListView(
                  children: [Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 500,
                        child: Column(
                          children: [
                            const Text(
                              "HOMEPAGE !!!",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) => CreateHostel()
                                  ));
                                },
                                child: const Text("Create New Hostel")),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) => const CreateHostelAmenity()
                                  ));
                                },
                                child: const Text("Create Hostel Amenity")),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) => const CreateHostelContact()
                                  ));
                                },
                                child: const Text("Create Hostel Contact"))
                          ],
                        ),
                      ),
                    ],
                  ),
                  ]
              ),
            );
          }
          else {
            return Query(
                options: QueryOptions(
                  document: gql(getMeHome),
                ),
                builder: (QueryResult result, {fetchMore, refetch}) {
                  if (result.hasException) {
                    print(result.exception.toString());
                  }
                  if (result.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.blue[700],
                      ),
                    );
                  }
                  all.clear();
                  for(var i = 0; i < result.data!["getMe"]["getHome"]["announcements"].length; i++){
                    all.putIfAbsent(Announcement(
                        title: result.data!["getMe"]["getHome"]["announcements"][i]["title"],
                        hostelIds: [],
                        description: result.data!["getMe"]["getHome"]["announcements"][i]["description"],
                        endTime: '',
                        id: result.data!["getMe"]["getHome"]["announcements"][i]["id"],
                        images: result.data!["getMe"]["getHome"]["announcements"][i]["images"],
                        createdByUserId: ''
                    ),
                            () => "announcement");
                  }
                  for (var i = 0; i < result.data!["getMe"]["getHome"]["events"].length; i++) {
                    List<Tag> tags = [];
                    for(var k=0;k < result.data!["getMe"]["getHome"]["events"][i]["tags"].length;k++){
                      // print("Tag_name: ${netopList[i]["tags"][k]["title"]}, category: ${netopList[i]["tags"][k]["category"]}");
                      tags.add(
                        Tag(
                          Tag_name: result.data!["getMe"]["getHome"]["events"][i]["tags"][k]["title"],
                          category: result.data!["getMe"]["getHome"]["events"][i]["tags"][k]["category"],
                          id: result.data!["getMe"]["getHome"]["events"][i]["tags"][k]["id"],
                        ),
                      );
                    }
                    all.putIfAbsent(Post(
                      title: result.data!["getMe"]["getHome"]["events"][i]["title"],
                      tags: tags,
                      id: result.data!["getMe"]["getHome"]["events"][i]["id"], createdById: '',
                      likeCount: 0, imgUrl: [], linkName: '', description: '', linkToAction: '',
                      time: result.data!["getMe"]["getHome"]["events"][i]["time"],
                      location: result.data!["getMe"]["getHome"]["events"][i]["location"],
                      // location: result.data!["getMe"]["getHome"]["events"][i]["location"],
                    ),
                          () => "event",
                    );
                  }
                  if(isNetops) {
                    all.clear();
                  }
                  for (var i = 0; i < result.data!["getMe"]["getHome"]["netops"].length; i++) {
                    List<Tag> tags = [];
                    for(var k=0;k < result.data!["getMe"]["getHome"]["netops"][i]["tags"].length;k++){
                      // print("Tag_name: ${netopList[i]["tags"][k]["title"]}, category: ${netopList[i]["tags"][k]["category"]}");
                      tags.add(
                        Tag(
                          Tag_name: result.data!["getMe"]["getHome"]["netops"][i]["tags"][k]["title"],
                          category: result.data!["getMe"]["getHome"]["netops"][i]["tags"][k]["category"],
                          id: result.data!["getMe"]["getHome"]["netops"][i]["tags"][k]["id"],
                        ),
                      );
                    }
                    all.putIfAbsent(NetOpPost(
                      title: result.data!["getMe"]["getHome"]["netops"][i]["title"],
                      tags: tags,
                      id: result.data!["getMe"]["getHome"]["netops"][i]["id"], comments: [], like_counter: 0, endTime: '', attachment: null, imgUrl: null, linkToAction: null, linkName: null,
                      description: result.data!["getMe"]["getHome"]["netops"][i]["content"],
                    ),
                            ()=>"netop");
                  }
                  if(isEvents) {
                    all.clear();
                    for (var i = 0; i < result.data!["getMe"]["getHome"]["events"].length; i++) {
                      List<Tag> tags = [];
                      for(var k=0;k < result.data!["getMe"]["getHome"]["events"][i]["tags"].length;k++){
                        // print("Tag_name: ${netopList[i]["tags"][k]["title"]}, category: ${netopList[i]["tags"][k]["category"]}");
                        tags.add(
                          Tag(
                            Tag_name: result.data!["getMe"]["getHome"]["events"][i]["tags"][k]["title"],
                            category: result.data!["getMe"]["getHome"]["events"][i]["tags"][k]["category"],
                            id: result.data!["getMe"]["getHome"]["events"][i]["tags"][k]["id"],
                          ),
                        );
                      }
                      all.putIfAbsent(Post(
                        title: result.data!["getMe"]["getHome"]["events"][i]["title"],
                        tags: tags,
                        id: result.data!["getMe"]["getHome"]["events"][i]["id"], createdById: '',
                        likeCount: 0, imgUrl: [], linkName: '', description: '', linkToAction: '',
                        time: result.data!["getMe"]["getHome"]["events"][i]["time"],
                        location: result.data!["getMe"]["getHome"]["events"][i]["location"],
                        // location: result.data!["getMe"]["getHome"]["events"][i]["location"],
                      ),
                            () => "event",
                      );
                    }
                  }
                  if (isAnnouncements) {
                    all.clear();
                    for(var i = 0; i < result.data!["getMe"]["getHome"]["announcements"].length; i++){
                      all.putIfAbsent(Announcement(
                          title: result.data!["getMe"]["getHome"]["announcements"][i]["title"],
                          hostelIds: [],
                          description: result.data!["getMe"]["getHome"]["announcements"][i]["description"],
                          endTime: '',
                          id: result.data!["getMe"]["getHome"]["announcements"][i]["id"],
                          images: result.data!["getMe"]["getHome"]["announcements"][i]["images"],
                          createdByUserId: ''
                      ),
                              () => "announcement");
                    }
                  }
                  if( isAnnouncements == true || isEvents == true || isNetops == true ) {
                    isAll = false;
                  }
                  userName = result.data!["getMe"]["name"];

                  //User UI
                  return Scaffold(
                    key: _scaffoldKey,
                    appBar: AppBar(
                      backgroundColor: const Color(0xFF5451FD),
                      title: Row(
                        children: const [
                          CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage('https://pbs.twimg.com/profile_images/1459179322854367232/Zj38Rken_400x400.jpg')
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(8.0,0.0,0,0),
                            child: Text("InstiVerse", style: TextStyle(fontSize: 30.0),),
                          ),
                        ],
                      ),
                      actions: [
                        IconButton(onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => const searchUser()));
                        },
                            icon: const Icon(Icons.search_outlined)),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.notifications)
                        ),
                        IconButton(
                            onPressed: () {
                             _scaffoldKey.currentState?.openEndDrawer();
                            },
                            icon: const Icon(Icons.menu),
                          iconSize: 22.0,
                        )
                      ],
                    ),
                    body: ListView(
                      children: [Column(
                        children: [
                          //Selectors
                          SizedBox(
                            height: MediaQuery.of(context).size.height*0.07,
                            width: MediaQuery.of(context).size.width*0.9,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0.0, 15, 5, 10),
                              child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    //Selectors
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        //All Selected
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(0.0,0.0,6.0,0.0),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                isAnnouncements = false;
                                                isEvents = false;
                                                isNetops = false;
                                                isAll = true;
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: isAll? const Color(0xFF6B7AFF):Colors.white,
                                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                              minimumSize: Size(50, 35),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20.0)
                                              ),
                                                side: BorderSide(color: Color(0xFF6B7AFF)),
                                            ),
                                            child: Text("All",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: isAll? Colors.white:Color(0xFF6B7AFF),
                                                  fontSize: 15
                                              ),
                                            ),
                                          ),
                                        ),

                                        //Announcements Selected
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(0.0,0.0,6.0,0.0),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                isAnnouncements = !isAnnouncements;
                                                isEvents = false;
                                                isNetops = false;
                                                isAll = !isAll;
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                                primary: isAnnouncements? const Color(0xFF6B7AFF):Colors.white,
                                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                                minimumSize: Size(50, 35),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20.0)
                                                ),
                                              side: BorderSide(color: Color(0xFF6B7AFF))
                                            ),
                                            child: Text("Announcements",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: isAnnouncements? Colors.white:Color(0xFF6B7AFF),
                                                  fontSize: 15
                                              ),
                                            ),
                                          ),
                                        ),

                                        //Events Selected
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(0.0,0.0,6.0,0.0),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                isEvents = !isEvents;
                                                isAnnouncements =  false;
                                                isNetops = false;
                                                isAll = !isAll;
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                                primary: isEvents? const Color(0xFF6B7AFF):Colors.white,
                                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                                minimumSize: Size(50, 35),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20.0)
                                                ),
                                              side: BorderSide(color: Color(0xFF6B7AFF))
                                            ),
                                            child: Text("Events",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: isEvents? Colors.white:Color(0xFF6B7AFF),
                                                  fontSize: 15
                                              ),
                                            ),
                                          ),
                                        ),

                                        //Netop Selected
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(0.0,0.0,6.0,0.0),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                isNetops = !isNetops;
                                                isEvents = false;
                                                isAnnouncements = false;
                                                isAll = !isAll;
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                                primary: isNetops? const Color(0xFF6B7AFF):Colors.white,
                                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                                minimumSize: Size(50, 35),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20.0)
                                                ),
                                              side: BorderSide(color: Color(0xFF6B7AFF))
                                            ),
                                            child: Text("Netops",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: isNetops? Colors.white:Color(0xFF6B7AFF),
                                                  fontSize: 15
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]
                              ),
                            ),
                          ),

                          //Feed
                          SizedBox(
                            height: MediaQuery.of(context).size.height*0.8,
                            child: ListView(
                                children :[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(12, 5, 12, 5),
                                    child: Column(
                                      children: all.keys.map((e) => cardFunction(all[e],e)
                                      ).toList(),
                                    ),
                                  )
                                ]
                            ),
                          ),
                        ],
                      ),
                    ]
                    ),
                    endDrawer: Drawer(
                    child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Container(
                          child: ListView(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: const [
                                    CircleAvatar(
                                        radius: 20,
                                        backgroundImage: NetworkImage('https://pbs.twimg.com/profile_images/1459179322854367232/Zj38Rken_400x400.jpg')
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(8.0,0.0,0,0),
                                      child: Text("InstiVerse", style: TextStyle(fontSize: 30.0),),
                                    ),
                                  ],
                                ),
                              ),
                              ListTile(
                                leading: const Icon(Icons.account_circle_outlined),
                                title: const Text("My Profile"),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) => UserPage()));
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.vpn_key_sharp),
                                title: const Text("Update Password"),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) => UserPage()));
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.account_balance),
                                title: const Text("My Hostel"),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) => HostelHome()));
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.alternate_email),
                                title: const Text("About Us"),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) => AboutUs()));
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.contact_page_outlined),
                                title: const Text("Contact Us"),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) => ContactUs()));
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.feedback),
                                title: const Text("Feedback"),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) => FeedBack()));
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.logout),
                                title: const Text("Logout"),
                                onTap: () {
                                  _auth.clearAuth();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  );
                }
            );
          }
        }
    );
  }
  Widget cardFunction (String category, post){
    if(category == "event"){
      return EventsHomeCard(events: post);
    }
    else if(category == "netop"){
      return NetOpHomeCard(netops: post);
    }
    else if(category == "announcement"){
      return AnnouncementHomeCard(announcements: post);
    }
    return Container();
  }

}