import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../services/auth.dart';
import '../../models/user.dart';
import '../../models/post.dart';
import '../../graphQL/events.dart';
import '../../widgets/button/icon_button.dart';
import '../../widgets/card/main.dart';
import '../../widgets/headers/main.dart';
import 'hostelSection/hostel.dart';

class HomePage extends StatefulWidget {
  final AuthService auth;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const HomePage({Key? key, required this.auth, required this.scaffoldKey})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final AuthService auth = widget.auth;
    final List<HomeModel>? home = auth.user?.toHomeModel();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: RefreshIndicator(
            onRefresh: () => auth.clearUser(),
            child: NestedScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return CustomAppBar(
                        title: "InstiSpace",
                        leading: CustomIconButton(
                            icon: Icons.menu,
                            onPressed: () => {
                                  widget.scaffoldKey.currentState!.openDrawer()
                                }),
                        action: CustomIconButton(
                            icon: Icons.account_balance_outlined,
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const HostelHome()))),
                      );
                    }, childCount: 1),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Header(
                            title: "Hi ${auth.user!.name}",
                            subTitle: "Get InstiSpace feeds here"),
                      );
                    }, childCount: 1),
                  ),
                ];
              },
              body: RefreshIndicator(
                onRefresh: () => auth.clearUser(),
                child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: (home == null || home.isEmpty)
                        ? const Text("No Posts")
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: home.length,
                            itemBuilder: (context, index) => Section(
                                title: home[index].title,
                                posts: home[index].posts))),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          auth.logout();
        },
        child: const Icon(Icons.logout),
      ),
    );
  }
}

class Section extends StatefulWidget {
  final String title;
  final List<PostModel> posts;
  final Future<QueryResult<Object?>?> Function()? refetch;
  const Section(
      {Key? key, required this.title, required this.posts, this.refetch})
      : super(key: key);

  @override
  State<Section> createState() => _SectionState();
}

class _SectionState extends State<Section> {
  bool isMinimized = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: InkWell(
            onTap: () => setState(() {
              isMinimized = !isMinimized;
            }),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                isMinimized
                    ? const Icon(Icons.arrow_drop_down)
                    : const Icon(Icons.arrow_drop_up)
              ],
            ),
          ),
        ),
        if (!isMinimized)
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.posts.length,
                  itemBuilder: (context, index) {
                    return PostCard(
                      post: widget.posts[index],
                      refetch: widget.refetch,
                      deleteMutationDocument: EventGQL().delete,
                    );
                  }),
            ),
          ),
      ],
    );
  }
}

/*
// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);
//   static const routeName = "/home";

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   ///GraphQL
//   // AuthService _auth = AuthService();
//   String getMeHome = homeQuery().getMeHome;

//   ///Variables

//   String userName = "";
//   String userRole = "";
//   String userid = "";
//   bool isAll = true;
//   bool isAnnouncements = false;
//   bool isEvents = false;
//   bool isNetops = false;
//   Map all = {};

//   ///Controllers
//   late ScrollController scrollController;

//   ///Keys
//   final _scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
//     //   _auth = Provider.of<AuthService>(context, listen: false);
//     // });
//     scrollController = ScrollController();
//     _sharedPreference();
//   }

//   SharedPreferences? prefs;
//   void _sharedPreference() async {
//     prefs = await SharedPreferences.getInstance();
//     // print("prefs home : $prefs");
//     setState(() {
//       userName = prefs!.getString('name')!;
//       userRole = prefs!.getString("role")!;
//       userid = prefs!.getString('id')!;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Query(
//         options: QueryOptions(
//           document: gql(getMeHome),
//         ),
//         builder: (QueryResult result, {fetchMore, refetch}) {
//           if (result.hasException) {
//             return Text(result.exception.toString());
//           }

//           ///Loading screen
//           if (result.isLoading) {
//             return Scaffold(
//               body: Center(
//                 child: Expanded(
//                     child: ListView.separated(
//                         itemBuilder: (context, index) =>
//                             const NewCardSkeleton(),
//                         separatorBuilder: (context, index) => const SizedBox(
//                               height: 6,
//                             ),
//                         itemCount: 5)),
//               ),
//             );
//           }
//           var data = result.data!["getMe"]["getHome"];

//           ///If all announcements, events and netops are empty
//           if (data["announcements"].isEmpty &&
//               data["events"].isEmpty &&
//               data["netops"].isEmpty) {
//             return Scaffold(
//               body: RefreshIndicator(
//                 color: const Color(0xFF2B2E35),
//                 onRefresh: () {
//                   return refetch!();
//                 },
//                 child: Center(
//                   child: Column(
//                     children: [
//                       PageTitle(
//                           'Welcome ${userName.split(" ").first}!', context),
//                       Padding(
//                         padding: const EdgeInsets.fromLTRB(0, 250, 0, 0),
//                         child: Container(
//                             alignment: Alignment.center,
//                             child: const Text(
//                               'No Posts Yet!',
//                               style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 30,
//                                   fontWeight: FontWeight.w600),
//                               textAlign: TextAlign.center,
//                             )),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           } else {
//             all.clear();
//             for (var i = 0; i < data["announcements"].length; i++) {
//               List<String> hostelIds = [];
//               List<String> hostelNames = [];
//               for (var j = 0;
//                   j < data["announcements"][i]['hostels'].length;
//                   j++) {
//                 hostelIds.add(data["announcements"][i]["hostels"][j]["id"]);
//                 hostelNames.add(data["announcements"][i]["hostels"][j]["name"]);
//               }
//               all.putIfAbsent(
//                   Announcement(
//                     title: data["announcements"][i]["title"],
//                     hostelIds: hostelIds,
//                     description: data["announcements"][i]["description"],
//                     endTime: data["announcements"][i]["endTime"],
//                     id: data["announcements"][i]["id"],
//                     images: data["announcements"][i]["images"],
//                     createdByUserId: data["announcements"][i]["user"]["id"],
//                     hostelNames: hostelNames,
//                   ),
//                   () => "announcement");
//             }
//             for (var i = 0; i < data["events"].length; i++) {
//               List<Tag> tags = [];
//               for (var k = 0; k < data["events"][i]["tags"].length; k++) {
//                 // print("Tag_name: ${netopList[i]["tags"][k]["title"]}, category: ${netopList[i]["tags"][k]["category"]}");
//                 tags.add(
//                   Tag(
//                     Tag_name: data["events"][i]["tags"][k]["title"],
//                     category: data["events"][i]["tags"][k]["category"],
//                     id: data["events"][i]["tags"][k]["id"],
//                   ),
//                 );
//               }

//               List<String> imageUrls = [];
//               if (data['events'][i]["photo"] != null &&
//                   result.data!['getMe']['getHome']['events'][i]["photo"] !=
//                       "") {
//                 imageUrls = data['events'][i]["photo"].split(" AND ");
//               }

//               all.putIfAbsent(
//                 eventsPost(
//                   title: data["events"][i]["title"],
//                   tags: tags,
//                   id: data["events"][i]["id"],
//                   createdById: result.data!['getMe']['getHome']['events'][i]
//                       ['createdBy']['id'],
//                   createdByName: result.data!['getMe']['getHome']['events'][i]
//                       ['createdBy']['name'],
//                   likeCount: data['events'][i]['likeCount'],
//                   imgUrl: imageUrls,
//                   linkName: data['events'][i]['linkName'],
//                   description: data['events'][i]['content'],
//                   linkToAction: data['events'][i]['linkToAction'],
//                   time: data["events"][i]["time"],
//                   location: data["events"][i]["location"],
//                   isLiked: data["events"][i]["isLiked"],
//                   isStarred: data["events"][i]["isStared"],
//                   createdAt: DateTime.parse(data["events"][i]["createdAt"]),
//                 ),
//                 () => "event",
//               );
//             }

//             for (var i = 0;
//                 i < result.data!["getMe"]["getHome"]["netops"].length;
//                 i++) {
//               List<Tag> tags = [];
//               List<Comment> comments = [];
//               for (var k = 0;
//                   k <
//                       result.data!["getMe"]["getHome"]["netops"][i]["tags"]
//                           .length;
//                   k++) {
//                 // print("Tag_name: ${netopList[i]["tags"][k]["title"]}, category: ${netopList[i]["tags"][k]["category"]}");
//                 tags.add(
//                   Tag(
//                     Tag_name: result.data!["getMe"]["getHome"]["netops"][i]
//                         ["tags"][k]["title"],
//                     category: result.data!["getMe"]["getHome"]["netops"][i]
//                         ["tags"][k]["category"],
//                     id: result.data!["getMe"]["getHome"]["netops"][i]["tags"][k]
//                         ["id"],
//                   ),
//                 );
//               }
//               List<String> imageUrls = [];
//               if (result.data!["getMe"]["getHome"]['netops'][i]["photo"] !=
//                       null &&
//                   result.data!['getMe']['getHome']['netops'][i]["photo"] !=
//                       "") {
//                 imageUrls = data['netops'][i]["photo"].split(" AND ");
//               }
//               all.putIfAbsent(
//                   NetOpPost(
//                     commentCount: result.data!["getMe"]["getHome"]["netops"][i]
//                         ["commentCount"],
//                     title: result.data!["getMe"]["getHome"]["netops"][i]
//                         ["title"],
//                     tags: tags,
//                     id: result.data!["getMe"]["getHome"]["netops"][i]["id"],
//                     createdByName: '',
//                     likeCount: result.data!["getMe"]["getHome"]["netops"][i]
//                         ["likeCount"],
//                     endTime: result.data!['getMe']['getHome']['netops'][i]
//                         ['endTime'],
//                     attachment: result.data!["getMe"]["getHome"]["netops"][i]
//                         ["attachments"],
//                     imgUrl: imageUrls,
//                     linkToAction: result.data!["getMe"]["getHome"]["netops"][i]
//                         ["linkToAction"],
//                     linkName: result.data!["getMe"]["getHome"]["netops"][i]
//                         ["linkName"],
//                     description: result.data!["getMe"]["getHome"]["netops"][i]
//                         ["content"],
//                     isLiked: data['netops'][i]['isLiked'],
//                     isStarred: data['netops'][i]['isStared'],
//                     createdAt: DateTime.parse(data["netops"][i]["createdAt"]),
//                     createdById: data["netops"][i]["createdBy"]["id"],
//                   ),
//                   () => "netop");
//             }

//             if (isNetops) {
//               all.clear();

//               ///If only netops is empty and netops filter is applied
//               if (data["netops"].isEmpty) {
//                 return Scaffold(
//                   // backgroundColor: Color(0xFFDFDFDF),
//                   body: RefreshIndicator(
//                     color: const Color(0xFF2B2E35),
//                     onRefresh: () {
//                       return refetch!();
//                     },
//                     child: Column(
//                       children: [
//                         PageTitle(
//                             'Welcome ${userName.split(" ").first}!', context),
//                         Padding(
//                           padding: const EdgeInsets.fromLTRB(15, 15, 10, 15),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.fromLTRB(
//                                     0.0, 0.0, 6.0, 0.0),
//                                 child: ElevatedButton(
//                                   onPressed: () {
//                                     setState(() {
//                                       isNetops = !isNetops;
//                                       isAnnouncements = false;
//                                       isEvents = false;
//                                       isAll = !isAll;
//                                     });
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     primary: isNetops
//                                         ? Colors.white
//                                         : Color(0xFF42454D),
//                                     padding: const EdgeInsets.symmetric(
//                                         vertical: 4, horizontal: 8),
//                                     minimumSize: Size(50, 35),
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(20.0)),
//                                   ),
//                                   child: Text(
//                                     "netops",
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         color: isNetops
//                                             ? Color(0xFF42454D)
//                                             : Colors.white,
//                                         fontSize: 15),
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
//                                 child: IconButton(
//                                   onPressed: () {
//                                     showModalBottomSheet(
//                                       context: context,
//                                       builder: (BuildContext context) {
//                                         return homeFilters();
//                                       },
//                                       shape: const RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.vertical(
//                                             top: Radius.circular(10)),
//                                       ),
//                                     );
//                                   },
//                                   icon: const Icon(Icons.filter_alt_outlined,
//                                       color: Color(0xFF42454D)),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.fromLTRB(0, 250, 0, 0),
//                           child: Container(
//                               alignment: Alignment.center,
//                               child: const Text(
//                                 'No netops yet !!',
//                                 style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 30,
//                                     fontWeight: FontWeight.w600),
//                                 textAlign: TextAlign.center,
//                               )),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               } else {
//                 for (var i = 0;
//                     i < result.data!["getMe"]["getHome"]["netops"].length;
//                     i++) {
//                   List<Tag> tags = [];
//                   List<Comment> comments = [];
//                   for (var k = 0;
//                       k <
//                           result.data!["getMe"]["getHome"]["netops"][i]["tags"]
//                               .length;
//                       k++) {
//                     // print("Tag_name: ${netopList[i]["tags"][k]["title"]}, category: ${netopList[i]["tags"][k]["category"]}");
//                     tags.add(
//                       Tag(
//                         Tag_name: result.data!["getMe"]["getHome"]["netops"][i]
//                             ["tags"][k]["title"],
//                         category: result.data!["getMe"]["getHome"]["netops"][i]
//                             ["tags"][k]["category"],
//                         id: result.data!["getMe"]["getHome"]["netops"][i]
//                             ["tags"][k]["id"],
//                       ),
//                     );
//                   }
//                   List<String> imageUrls = [];
//                   if (result.data!["getMe"]["getHome"]['netops'][i]["photo"] !=
//                           null &&
//                       result.data!['getMe']['getHome']['netops'][i]["photo"] !=
//                           "") {
//                     imageUrls = data['netops'][i]["photo"].split(" AND ");
//                   }
//                   all.putIfAbsent(
//                       NetOpPost(
//                         commentCount: result.data!["getMe"]["getHome"]["netops"]
//                             [i]["commentCount"],
//                         title: result.data!["getMe"]["getHome"]["netops"][i]
//                             ["title"],
//                         tags: tags,
//                         id: result.data!["getMe"]["getHome"]["netops"][i]["id"],
//                         createdByName: '',
//                         likeCount: result.data!["getMe"]["getHome"]["netops"][i]
//                             ["likeCount"],
//                         endTime: result.data!['getMe']['getHome']['netops'][i]
//                             ['endTime'],
//                         attachment: result.data!["getMe"]["getHome"]["netops"]
//                             [i]["attachments"],
//                         imgUrl: imageUrls,
//                         linkToAction: result.data!["getMe"]["getHome"]["netops"]
//                             [i]["linkToAction"],
//                         linkName: result.data!["getMe"]["getHome"]["netops"][i]
//                             ["linkName"],
//                         description: result.data!["getMe"]["getHome"]["netops"]
//                             [i]["content"],
//                         isLiked: data['netops'][i]['isLiked'],
//                         isStarred: data['netops'][i]['isStared'],
//                         createdAt:
//                             DateTime.parse(data["netops"][i]["createdAt"]),
//                         createdById: data["netops"][i]["createdBy"]["id"],
//                       ),
//                       () => "netop");
//                 }
//               }
//             }
//             if (isEvents) {
//               all.clear();

//               ///If only events is empty and events filter is applied
//               if (data["events"].isEmpty) {
//                 return Scaffold(
//                   // backgroundColor: Color(0xFFDFDFDF),
//                   body: RefreshIndicator(
//                     color: const Color(0xFF2B2E35),
//                     onRefresh: () {
//                       return refetch!();
//                     },
//                     child: Column(
//                       children: [
//                         PageTitle(
//                             'Welcome ${userName.split(" ").first}!', context),
//                         Padding(
//                           padding: const EdgeInsets.fromLTRB(15, 15, 10, 15),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.fromLTRB(
//                                     0.0, 0.0, 6.0, 0.0),
//                                 child: ElevatedButton(
//                                   onPressed: () {
//                                     setState(() {
//                                       isEvents = !isEvents;
//                                       isAnnouncements = false;
//                                       isNetops = false;
//                                       isAll = !isAll;
//                                     });
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     primary: isEvents
//                                         ? Colors.white
//                                         : Color(0xFF42454D),
//                                     padding: const EdgeInsets.symmetric(
//                                         vertical: 4, horizontal: 8),
//                                     minimumSize: Size(50, 35),
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(20.0)),
//                                   ),
//                                   child: Text(
//                                     "Events",
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         color: isEvents
//                                             ? Color(0xFF42454D)
//                                             : Colors.white,
//                                         fontSize: 15),
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
//                                 child: IconButton(
//                                   onPressed: () {
//                                     showModalBottomSheet(
//                                       context: context,
//                                       builder: (BuildContext context) {
//                                         return homeFilters();
//                                       },
//                                       shape: const RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.vertical(
//                                             top: Radius.circular(10)),
//                                       ),
//                                     );
//                                   },
//                                   icon: const Icon(
//                                     Icons.filter_alt_outlined,
//                                     color: Color(0xFF42454D),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.fromLTRB(0, 250, 0, 0),
//                           child: Container(
//                               alignment: Alignment.center,
//                               child: const Text(
//                                 'No events yet !!',
//                                 style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 30,
//                                     fontWeight: FontWeight.w600),
//                                 textAlign: TextAlign.center,
//                               )),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               } else {
//                 for (var i = 0;
//                     i < result.data!["getMe"]["getHome"]["events"].length;
//                     i++) {
//                   List<Tag> tags = [];
//                   for (var k = 0;
//                       k <
//                           result.data!["getMe"]["getHome"]["events"][i]["tags"]
//                               .length;
//                       k++) {
//                     // print("Tag_name: ${netopList[i]["tags"][k]["title"]}, category: ${netopList[i]["tags"][k]["category"]}");
//                     tags.add(
//                       Tag(
//                         Tag_name: result.data!["getMe"]["getHome"]["events"][i]
//                             ["tags"][k]["title"],
//                         category: result.data!["getMe"]["getHome"]["events"][i]
//                             ["tags"][k]["category"],
//                         id: result.data!["getMe"]["getHome"]["events"][i]
//                             ["tags"][k]["id"],
//                       ),
//                     );
//                   }

//                   List<String> imageUrls = [];
//                   if (result.data!['getMe']['getHome']['events'][i]["photo"] !=
//                           null &&
//                       result.data!['getMe']['getHome']['events'][i]["photo"] !=
//                           "") {
//                     imageUrls = result.data!['getMe']['getHome']['events'][i]
//                             ["photo"]
//                         .split(" AND ");
//                   }

//                   all.putIfAbsent(
//                     eventsPost(
//                       title: result.data!["getMe"]["getHome"]["events"][i]
//                           ["title"],
//                       tags: tags,
//                       id: result.data!["getMe"]["getHome"]["events"][i]["id"],
//                       createdById: result.data!['getMe']['getHome']['events'][i]
//                           ['createdBy']['id'],
//                       // createdByName: result.data!['getMe']['getHome']['events'][i]['createdBy']['name'],
//                       createdByName: '',
//                       likeCount: result.data!['getMe']['getHome']['events'][i]
//                           ['likeCount'],
//                       imgUrl: imageUrls,
//                       linkName: result.data!['getMe']['getHome']['events'][i]
//                           ['linkName'],
//                       description: result.data!['getMe']['getHome']['events'][i]
//                           ['content'],
//                       linkToAction: result.data!['getMe']['getHome']['events']
//                           [i]['linkToAction'],
//                       time: result.data!["getMe"]["getHome"]["events"][i]
//                           ["time"],
//                       location: result.data!["getMe"]["getHome"]["events"][i]
//                           ["location"],
//                       isLiked: result.data!["getMe"]["getHome"]["events"][i]
//                           ["isLiked"],
//                       isStarred: result.data!["getMe"]["getHome"]["events"][i]
//                           ["isStared"],
//                       createdAt: DateTime.parse(data["events"][i]["createdAt"]),
//                     ),
//                     () => "event",
//                   );
//                 }
//               }
//             }
//             if (isAnnouncements) {
//               all.clear();

//               ///If only announcements is empty and ammouncements filter is applied
//               if (data["announcements"].isEmpty) {
//                 return Scaffold(
//                   // backgroundColor: Color(0xFFDFDFDF),
//                   body: RefreshIndicator(
//                     color: const Color(0xFF2B2E35),
//                     onRefresh: () {
//                       return refetch!();
//                     },
//                     child: Column(
//                       children: [
//                         PageTitle(
//                             'Welcome ${userName.split(" ").first}!', context),
//                         Padding(
//                           padding: const EdgeInsets.fromLTRB(15, 15, 10, 15),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.fromLTRB(
//                                     0.0, 0.0, 6.0, 0.0),
//                                 child: ElevatedButton(
//                                   onPressed: () {
//                                     setState(() {
//                                       isAnnouncements = !isAnnouncements;
//                                       isEvents = false;
//                                       isNetops = false;
//                                       isAll = !isAll;
//                                     });
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     primary: isAnnouncements
//                                         ? Colors.white
//                                         : Color(0xFF42454D),
//                                     padding: const EdgeInsets.symmetric(
//                                         vertical: 4, horizontal: 8),
//                                     minimumSize: Size(50, 35),
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(20.0)),
//                                   ),
//                                   child: Text(
//                                     "announcements",
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         color: isAnnouncements
//                                             ? Color(0xFF42454D)
//                                             : Colors.white,
//                                         fontSize: 15),
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
//                                 child: IconButton(
//                                   onPressed: () {
//                                     showModalBottomSheet(
//                                       context: context,
//                                       builder: (BuildContext context) {
//                                         return homeFilters();
//                                       },
//                                       shape: const RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.vertical(
//                                             top: Radius.circular(10)),
//                                       ),
//                                     );
//                                   },
//                                   icon: const Icon(
//                                     Icons.filter_alt_outlined,
//                                     color: Color(0xFF42454D),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.fromLTRB(0, 250, 0, 0),
//                           child: Container(
//                               alignment: Alignment.center,
//                               child: const Text(
//                                 'No announcements yet !!',
//                                 style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 30,
//                                     fontWeight: FontWeight.w600),
//                                 textAlign: TextAlign.center,
//                               )),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               } else {
//                 for (var i = 0;
//                     i <
//                         result
//                             .data!["getMe"]["getHome"]["announcements"].length;
//                     i++) {
//                   List<String> hostelIds = [];
//                   List<String> hostelNames = [];
//                   for (var j = 0;
//                       j < data["announcements"][i]['hostels'].length;
//                       j++) {
//                     hostelIds.add(data["announcements"][i]["hostels"][j]["id"]);
//                     hostelNames
//                         .add(data["announcements"][i]["hostels"][j]["name"]);
//                   }
//                   all.putIfAbsent(
//                       Announcement(
//                           title: result.data!["getMe"]["getHome"]
//                               ["announcements"][i]["title"],
//                           hostelIds: hostelIds,
//                           description: result.data!["getMe"]["getHome"]
//                               ["announcements"][i]["description"],
//                           endTime: '',
//                           id: result.data!["getMe"]["getHome"]["announcements"]
//                               [i]["id"],
//                           images: result.data!["getMe"]["getHome"]
//                               ["announcements"][i]["images"],
//                           createdByUserId: '',
//                           hostelNames: hostelNames),
//                       () => "announcement");
//                 }
//               }
//             }
//             if (isAnnouncements == true ||
//                 isEvents == true ||
//                 isNetops == true) {
//               isAll = false;
//             }

//             return Scaffold(
//               key: _scaffoldKey,
//               // backgroundColor: Color(0xFFDFDFDF),
//               body: RefreshIndicator(
//                 color: const Color(0xFF2B2E35),
//                 onRefresh: () {
//                   return refetch!();
//                 },
//                 child: ListView(children: [
//                   // PageTitle('Welcome ${userName
//                   //     .split(" ")
//                   //     .first}!', context),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 8.0, horizontal: 20.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Hi ${userName.split(" ").first}",
//                           style: TextStyle(
//                               color: Colors.indigo[900],
//                               // color: Color(0xFF32196C),
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         Text(
//                           "Get InstiSpace feeds here",
//                           style: TextStyle(
//                               color: Colors.indigo[500],
//                               // color: Color(0xFF5F53DD),
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500),
//                         )
//                       ],
//                     ),
//                   ),
//                   Column(
//                     children: [
//                       ///Filters
//                       SizedBox(
//                         // height: MediaQuery.of(context).size.height * 0.07,
//                         // width: MediaQuery.of(context).size.width * 0.9,
//                         child: Padding(
//                           padding: const EdgeInsets.fromLTRB(15.0, 15, 15, 10),
//                           child: Card(
//                             // margin: EdgeInsets.symmetric(horizontal: 8),
//                             elevation: 3.0,
//                             shape: const RoundedRectangleBorder(
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(4),
//                               ),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Icon(Icons.search),
//                                 ),
//                                 Expanded(
//                                   child: TextField(
//                                     decoration: InputDecoration(
//                                       border: InputBorder.none,
//                                       hintText: 'What are you looking for?',
//                                     ),
//                                     // onSubmitted: onSubmitted,
//                                     // controller: controller,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),

//                       ///Listing of posts
//                       RefreshIndicator(
//                         color: const Color(0xFF2B2E35),
//                         onRefresh: () {
//                           return refetch!();
//                         },
//                         child: ListView(
//                             shrinkWrap: true,
//                             controller: scrollController,
//                             children: [
//                               Padding(
//                                 padding:
//                                     const EdgeInsets.fromLTRB(12, 5, 12, 5),
//                                 child: Column(
//                                   children: all.keys
//                                       .map((e) => cardFunction(
//                                           all[e], e, refetch, userRole, userid))
//                                       .toList(),
//                                 ),
//                               )
//                             ]),
//                       ),
//                     ],
//                   ),
//                 ]),
//               ),
//             );
//           }
//         });
//   }

//   ///Function to call category wise cards
//   Widget cardFunction(String category, post,
//       Future<QueryResult?> Function()? refetch, userRole, userid) {
//     if (category == "event") {
//       return EventsCard(
//         refetch: refetch,
//         userId: userid,
//         post: post,
//         userRole: userRole,
//       );
//     } else if (category == "netop") {
//       return NetopsCard(
//           refetch: refetch, userId: userid, post: post, page: 'homePage');
//     } else if (category == "announcement") {
//       // return AnnouncementHomeCard(announcements: post);
//       return AnnouncementsCards(context, userRole, userid, refetch, post, null);
//     }
//     return Container();
//   }

//   ///Widget of Bottom Sheet
//   Widget homeFilters() {
//     return ListView(children: [
//       Container(
//         decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Center(
//                 child: Text(
//                   'Filter By',
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 24,
//                       fontWeight: FontWeight.w600),
//                 ),
//               ),

//               ///All Selected
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
//                 child: Wrap(children: [
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
//                     child: ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           isAnnouncements = false;
//                           isEvents = false;
//                           isNetops = false;
//                           isAll = true;
//                         });
//                         Navigator.pop(context);
//                       },
//                       style: ElevatedButton.styleFrom(
//                         primary: isAll
//                             ? const Color(0xFF42454D)
//                             : const Color(0xFFDFDFDF),
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 4, horizontal: 8),
//                         minimumSize: const Size(50, 35),
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20.0)),
//                       ),
//                       child: Text(
//                         "All",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color:
//                                 isAll ? Colors.white : const Color(0xFF42454D),
//                             fontSize: 15),
//                       ),
//                     ),
//                   ),

//                   ///Events Selected
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
//                     child: ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           isEvents = !isEvents;
//                           isAnnouncements = false;
//                           isNetops = false;
//                           isAll = !isAll;
//                         });
//                         Navigator.pop(context);
//                       },
//                       style: ElevatedButton.styleFrom(
//                         primary: isEvents
//                             ? const Color(0xFF42454D)
//                             : const Color(0xFFDFDFDF),
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 4, horizontal: 8),
//                         minimumSize: const Size(50, 35),
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20.0)),
//                       ),
//                       child: Text(
//                         "events",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: isEvents
//                                 ? Colors.white
//                                 : const Color(0xFF42454D),
//                             fontSize: 15),
//                       ),
//                     ),
//                   ),

//                   ///Netop Selected
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
//                     child: ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           isNetops = !isNetops;
//                           isEvents = false;
//                           isAnnouncements = false;
//                           isAll = !isAll;
//                         });
//                         Navigator.pop(context);
//                       },
//                       style: ElevatedButton.styleFrom(
//                         primary: isNetops
//                             ? const Color(0xFF42454D)
//                             : const Color(0xFFDFDFDF),
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 4, horizontal: 8),
//                         minimumSize: const Size(50, 35),
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20.0)),
//                       ),
//                       child: Text(
//                         "netops",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: isNetops
//                                 ? Colors.white
//                                 : const Color(0xFF42454D),
//                             fontSize: 15),
//                       ),
//                     ),
//                   ),

//                   ///Announcements Selected
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
//                     child: ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           isAnnouncements = !isAnnouncements;
//                           isEvents = false;
//                           isNetops = false;
//                           isAll = !isAll;
//                         });
//                         Navigator.pop(context);
//                       },
//                       style: ElevatedButton.styleFrom(
//                         primary: isAnnouncements
//                             ? const Color(0xFF42454D)
//                             : const Color(0xFFDFDFDF),
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 4, horizontal: 8),
//                         minimumSize: const Size(50, 35),
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20.0)),
//                       ),
//                       child: Text(
//                         "announcements",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: isAnnouncements
//                                 ? Colors.white
//                                 : const Color(0xFF42454D),
//                             fontSize: 15),
//                       ),
//                     ),
//                   ),
//                 ]),
//               ),
//             ],
//           ),
//         ),
//       ),
//     ]);
//   }
// }
*/
