import 'package:client/models/netopsClass.dart';
import 'package:client/models/tag.dart';
import 'package:client/models/eventsClass.dart';
import 'package:client/models/announcementsClass.dart';
import 'package:client/widgets/eventCard.dart';
import 'package:client/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:client/services/Auth.dart';
import 'package:provider/provider.dart';
import 'package:client/widgets/loadingScreens.dart';
import 'package:client/models/commentclass.dart';
import 'package:client/graphQL/home.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../widgets/NetOpCard.dart';
import '../../widgets/announcementCard.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const routeName = "/home";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  ///GraphQL
  late AuthService _auth;
  String getMe = homeQuery().getMe;
  String getMeHome = homeQuery().getMeHome;

  ///Variables
  var result;
  late String userName;
  late String userRole;
  late String userid;
  bool isAll = true;
  bool isAnnouncements = false;
  bool isEvents = false;
  bool isNetops = false;
  Map all = {};

  ///Controllers
  late TextEditingController reportController;
  late ScrollController scrollController;

  ///Keys
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _auth = Provider.of<AuthService>(context, listen: false);
    });
    scrollController = ScrollController();
    reportController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: gql(getMe),
        ),
        builder: (QueryResult result, {fetchMore, refetch}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }
          if (result.isLoading) {
            return Scaffold(
              body: Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.black,
                    size: 100),
              ),
            );
          }
          userRole = result.data!["getMe"]["role"];
          userid = result.data!["getMe"]["id"];

          ///Conditional Scaffold, one for Admin side and other for User side

          // if (userRole == "ADMIN" || userRole == "HAS" || userRole == "HOSTEL_SEC") {
          //   return Scaffold(
          //     appBar: AppBar(
          //       title: Text("Hey $userRole"),
          //       backgroundColor: const Color(0xFF5451FD),
          //       actions: [
          //         IconButton(
          //             onPressed: () {
          //               _auth.clearAuth();
          //             },
          //             icon: const Icon(Icons.logout)),
          //         IconButton(
          //             onPressed: (){
          //               Navigator.of(context).push(MaterialPageRoute(
          //                   builder: (BuildContext context) => const searchUser()));
          //             },
          //             icon: const Icon(Icons.search_outlined)),
          //       ],
          //     ),
          //     body: ListView(
          //         children: [Column(
          //           crossAxisAlignment: CrossAxisAlignment.center,
          //           children: [
          //             Container(
          //               height: 500,
          //               child: Column(
          //                 children: [
          //                   const Text(
          //                     "HOMEPAGE !!!",
          //                     style: TextStyle(
          //                       fontWeight: FontWeight.bold,
          //                       color: Colors.black,
          //                       fontSize: 20,
          //                     ),
          //                   ),
          //                   ElevatedButton(
          //                       onPressed: () {
          //                         Navigator.of(context).push(MaterialPageRoute(
          //                             builder: (BuildContext context) => CreateHostel()
          //                         ));
          //                       },
          //                       child: const Text("Create New Hostel")),
          //                   ElevatedButton(
          //                       onPressed: () {
          //                         Navigator.of(context).push(MaterialPageRoute(
          //                             builder: (BuildContext context) => const CreateHostelAmenity()
          //                         ));
          //                       },
          //                       child: const Text("Create Hostel Amenity")),
          //                   ElevatedButton(
          //                       onPressed: () {
          //                         Navigator.of(context).push(MaterialPageRoute(
          //                             builder: (BuildContext context) => const CreateHostelContact()
          //                         ));
          //                       },
          //                       child: const Text("Create Hostel Contact"))
          //                 ],
          //               ),
          //             ),
          //           ],
          //         ),
          //         ]
          //     ),
          //   );
          // }
          // else {
          if(userRole != 'ADMIN') {
            userName = result.data!["getMe"]["name"];
          }
          else{
            userName = "$userRole";
          }
            return Query(
                options: QueryOptions(
                  document: gql(getMeHome),
                ),
                builder: (QueryResult result, {fetchMore, refetch}) {
                  if (result.hasException) {
                    return Text(result.exception.toString());
                  }

                  ///Loading screen
                  if (result.isLoading) {
                    return Scaffold(
                      body: Center(
                        child: Expanded(
                            child: ListView.separated(
                                itemBuilder: (context, index) =>
                                    const NewCardSkeleton(),
                                separatorBuilder: (context,
                                    index) => const SizedBox(height: 6,),
                                itemCount: 5)
                        ),
                      ),
                    );
                  }
                  var data = result.data!["getMe"]["getHome"];

                  ///If all announcements, events and netops are empty
                  if (data["announcements"].isEmpty &&
                      data ["events"].isEmpty && data["netops"].isEmpty) {
                    return Scaffold(
                      body: Center(
                        child: Column(
                          children: [
                            PageTitle('Welcome ${userName
                            .split(" ")
                            .first}!!', context),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0,250,0,0),
                              child: Container(
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'No Posts Yet !!',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 30,
                                        fontWeight: FontWeight.w600
                                    ),
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  else {
                    all.clear();
                    for (var i = 0; i < data["announcements"].length; i++) {
                      List<String> hostelIds = [];
                      List<String> hostelNames = [];
                      for(var j = 0; j < data["announcements"][i]['hostels'].length; j++) {
                        hostelIds.add(data["announcements"][i]["hostels"][j]["id"]);
                        hostelNames.add(data["announcements"][i]["hostels"][j]["name"]);
                      }
                      all.putIfAbsent(Announcement(
                        title: data["announcements"][i]["title"],
                        hostelIds: hostelIds,
                        description: data["announcements"][i]["description"],
                        endTime: data["announcements"][i]["endTime"],
                        id: data["announcements"][i]["id"],
                        images: data["announcements"][i]["images"],
                        createdByUserId: data["announcements"][i]["user"]["id"],
                        hostelNames: hostelNames,
                      ),
                              () => "announcement");
                    }
                    for (var i = 0; i < data["events"].length; i++) {
                      List<Tag> tags = [];
                      for (var k = 0; k <
                          data["events"][i]["tags"].length; k++) {
                        // print("Tag_name: ${netopList[i]["tags"][k]["title"]}, category: ${netopList[i]["tags"][k]["category"]}");
                        tags.add(
                          Tag(
                            Tag_name: data["events"][i]["tags"][k]["title"],
                            category: data["events"][i]["tags"][k]["category"],
                            id: data["events"][i]["tags"][k]["id"],
                          ),
                        );
                      }

                      List<String> imageUrls = [];
                      if (data['events'][i]["photo"] != null && result
                          .data!['getMe']['getHome']['events'][i]["photo"] !=
                          "") {
                        imageUrls = data['events'][i]["photo"].split(" AND ");
                      }

                      all.putIfAbsent(eventsPost(
                        title: data["events"][i]["title"],
                        tags: tags,
                        id: data["events"][i]["id"],
                        createdById: result
                            .data!['getMe']['getHome']['events'][i]['createdBy']['id'],
                        // createdByName: result.data!['getMe']['getHome']['events'][i]['createdBy']['name'],
                        createdByName: '',
                        likeCount: data['events'][i]['likeCount'],
                        imgUrl: imageUrls,
                        linkName: data['events'][i]['linkName'],
                        description: data['events'][i]['content'],
                        linkToAction: data['events'][i]['linkToAction'],
                        time: data["events"][i]["time"],
                        location: data["events"][i]["location"],
                        isLiked: data["events"][i]["isLiked"],
                        isStarred: data["events"][i]["isStared"],
                        createdAt: DateTime.parse(
                            data["events"][i]["createdAt"]),
                      ),
                            () => "event",
                      );
                    }

                    for (var i = 0; i <
                        result.data!["getMe"]["getHome"]["netops"]
                            .length; i++) {
                      List<Tag> tags = [];
                      List<Comment> comments = [];
                      for (var k = 0; k <
                          result.data!["getMe"]["getHome"]["netops"][i]["tags"]
                              .length; k++) {
                        // print("Tag_name: ${netopList[i]["tags"][k]["title"]}, category: ${netopList[i]["tags"][k]["category"]}");
                        tags.add(
                          Tag(
                            Tag_name: result
                                .data!["getMe"]["getHome"]["netops"][i]["tags"][k]["title"],
                            category: result
                                .data!["getMe"]["getHome"]["netops"][i]["tags"][k]["category"],
                            id: result
                                .data!["getMe"]["getHome"]["netops"][i]["tags"][k]["id"],
                          ),
                        );
                      }
                      for (var j = 0; j < result
                          .data!['getMe']['getHome']['netops'][i]["comments"]
                          .length; j++) {
                        // print("message: ${netopList[i]["comments"][j]["content"]}, id: ${netopList[i]["comments"][j]["id"]}");
                        comments.add(
                            Comment(
                              message: result
                                  .data!['getMe']['getHome']['netops'][i]["comments"][j]["content"],
                              id: result
                                  .data!['getMe']['getHome']['netops'][i]["comments"][j]["id"],
                              name: "Name",
                              //ToDO comment name
                              // netopList[i]["comments"][j]["createdBy"]["name"]
                            )
                        );
                      }
                      all.putIfAbsent(NetOpPost(
                        title: result
                            .data!["getMe"]["getHome"]["netops"][i]["title"],
                        tags: tags,
                        id: result.data!["getMe"]["getHome"]["netops"][i]["id"],
                        createdByName: '',
                        comments: comments,
                        likeCount: result
                            .data!["getMe"]["getHome"]["netops"][i]["likeCount"],
                        endTime: result
                            .data!['getMe']['getHome']['netops'][i]['endTime'],
                        attachment: result
                            .data!["getMe"]["getHome"]["netops"][i]["attachments"],
                        imgUrl: result
                            .data!["getMe"]["getHome"]["netops"][i]["photo"],
                        linkToAction: result
                            .data!["getMe"]["getHome"]["netops"][i]["linkToAction"],
                        linkName: result
                            .data!["getMe"]["getHome"]["netops"][i]["linkName"],
                        description: result
                            .data!["getMe"]["getHome"]["netops"][i]["content"],
                        isLiked: data['netops'][i]['isLiked'],
                        isStarred: data['netops'][i]['isStared'],
                        createdAt: DateTime.parse(
                            data["netops"][i]["createdAt"]),
                        createdById: data["netops"][i]["createdBy"]["id"],
                      ),
                              () => "netop");
                    }


                    if (isNetops) {
                      all.clear();

                      ///If only netops is empty and netops filter is applied
                      if(data["netops"].isEmpty) {
                        return Scaffold(
                          backgroundColor: Color(0xFFDFDFDF),
                          body: Column(
                            children: [
                              PageTitle('Welcome ${userName
                                  .split(" ")
                                  .first}!!}', context),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(15,15,10,15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets
                                          .fromLTRB(
                                          0.0, 0.0, 6.0, 0.0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            isNetops = !isNetops;
                                            isAnnouncements = false;
                                            isEvents = false;
                                            isAll = !isAll;
                                          });
                                        },
                                        style: ElevatedButton
                                            .styleFrom(
                                          primary: isNetops ? Colors
                                              .white : Color(
                                              0xFF42454D),
                                          padding: const EdgeInsets
                                              .symmetric(vertical: 4,
                                              horizontal: 8),
                                          minimumSize: Size(50, 35),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius
                                                  .circular(20.0)
                                          ),
                                        ),
                                        child: Text("netops",
                                          style: TextStyle(
                                              fontWeight: FontWeight
                                                  .bold,
                                              color: isNetops ? Color(
                                                  0xFF42454D) : Colors
                                                  .white,
                                              fontSize: 15
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 0, 8),
                                      child: IconButton(
                                        onPressed: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (
                                                BuildContext context) {
                                              return homeFilters();
                                            },
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius
                                                  .vertical(
                                                  top: Radius.circular(10)
                                              ),
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.filter_alt_outlined,
                                          color: Color(0xFF42454D),),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0,250,0,0),
                                child: Container(
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'No netops yet !!',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 30,
                                          fontWeight: FontWeight.w600
                                      ),
                                      textAlign: TextAlign.center,
                                    )),
                              ),
                            ],
                          ),
                        );
                      }
                      else{
                        for (var i = 0; i <
                            result.data!["getMe"]["getHome"]["netops"]
                                .length; i++) {
                          List<Tag> tags = [];
                          List<Comment> comments = [];
                          for (var k = 0; k <
                              result.data!["getMe"]["getHome"]["netops"][i]["tags"]
                                  .length; k++) {
                            // print("Tag_name: ${netopList[i]["tags"][k]["title"]}, category: ${netopList[i]["tags"][k]["category"]}");
                            tags.add(
                              Tag(
                                Tag_name: result
                                    .data!["getMe"]["getHome"]["netops"][i]["tags"][k]["title"],
                                category: result
                                    .data!["getMe"]["getHome"]["netops"][i]["tags"][k]["category"],
                                id: result
                                    .data!["getMe"]["getHome"]["netops"][i]["tags"][k]["id"],
                              ),
                            );
                          }
                          for (var j = 0; j < result
                              .data!['getMe']['getHome']['netops'][i]["comments"]
                              .length; j++) {
                            // print("message: ${netopList[i]["comments"][j]["content"]}, id: ${netopList[i]["comments"][j]["id"]}");
                            comments.add(
                                Comment(
                                  message: result
                                      .data!['getMe']['getHome']['netops'][i]["comments"][j]["content"],
                                  id: result
                                      .data!['getMe']['getHome']['netops'][i]["comments"][j]["id"],
                                  name: "Name",
                                  //ToDO comment name
                                  // netopList[i]["comments"][j]["createdBy"]["name"]
                                )
                            );
                          }
                          all.putIfAbsent(NetOpPost(
                            title: result
                                .data!["getMe"]["getHome"]["netops"][i]["title"],
                            tags: tags,
                            id: result.data!["getMe"]["getHome"]["netops"][i]["id"],
                            createdByName: '',
                            comments: comments,
                            likeCount: result
                                .data!["getMe"]["getHome"]["netops"][i]["likeCount"],
                            endTime: result
                                .data!['getMe']['getHome']['netops'][i]['endTime'],
                            attachment: result
                                .data!["getMe"]["getHome"]["netops"][i]["attachments"],
                            imgUrl: result
                                .data!["getMe"]["getHome"]["netops"][i]["photo"],
                            linkToAction: result
                                .data!["getMe"]["getHome"]["netops"][i]["linkToAction"],
                            linkName: result
                                .data!["getMe"]["getHome"]["netops"][i]["linkName"],
                            description: result
                                .data!["getMe"]["getHome"]["netops"][i]["content"],
                            isLiked: data['netops'][i]['isLiked'],
                            isStarred: data['netops'][i]['isStared'],
                            createdAt: DateTime.parse(
                                data["netops"][i]["createdAt"]),
                            createdById: data["netops"][i]["createdBy"]["id"],
                          ),
                                  () => "netop");
                        }
                      }

                    }
                    if (isEvents) {
                      all.clear();

                      ///If only events is empty and events filter is applied
                      if(data["events"].isEmpty) {
                        return Scaffold(
                          backgroundColor: Color(0xFFDFDFDF),
                          body: Column(
                            children: [
                              PageTitle('Welcome ${userName
                                  .split(" ")
                                  .first}!!}', context),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(15,15,10,15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets
                                          .fromLTRB(
                                          0.0, 0.0, 6.0, 0.0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            isEvents = !isEvents;
                                            isAnnouncements = false;
                                            isNetops = false;
                                            isAll = !isAll;
                                          });
                                        },
                                        style: ElevatedButton
                                            .styleFrom(
                                          primary: isEvents ? Colors
                                              .white : Color(
                                              0xFF42454D),
                                          padding: const EdgeInsets
                                              .symmetric(vertical: 4,
                                              horizontal: 8),
                                          minimumSize: Size(50, 35),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius
                                                  .circular(20.0)
                                          ),
                                        ),
                                        child: Text("Events",
                                          style: TextStyle(
                                              fontWeight: FontWeight
                                                  .bold,
                                              color: isEvents ? Color(
                                                  0xFF42454D) : Colors
                                                  .white,
                                              fontSize: 15
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 0, 8),
                                      child: IconButton(
                                        onPressed: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (
                                                BuildContext context) {
                                              return homeFilters();
                                            },
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius
                                                  .vertical(
                                                  top: Radius.circular(10)
                                              ),
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.filter_alt_outlined,
                                          color: Color(0xFF42454D),),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0,250,0,0),
                                child: Container(
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'No events yet !!',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 30,
                                          fontWeight: FontWeight.w600
                                      ),
                                      textAlign: TextAlign.center,
                                    )),
                              ),
                            ],
                          ),
                        );
                      }
                      else {
                        for (var i = 0; i <
                            result.data!["getMe"]["getHome"]["events"]
                                .length; i++) {
                          List<Tag> tags = [];
                          for (var k = 0; k < result
                              .data!["getMe"]["getHome"]["events"][i]["tags"]
                              .length; k++) {
                            // print("Tag_name: ${netopList[i]["tags"][k]["title"]}, category: ${netopList[i]["tags"][k]["category"]}");
                            tags.add(
                              Tag(
                                Tag_name: result
                                    .data!["getMe"]["getHome"]["events"][i]["tags"][k]["title"],
                                category: result
                                    .data!["getMe"]["getHome"]["events"][i]["tags"][k]["category"],
                                id: result
                                    .data!["getMe"]["getHome"]["events"][i]["tags"][k]["id"],
                              ),
                            );
                          }

                          List<String> imageUrls = [];
                          if (result
                              .data!['getMe']['getHome']['events'][i]["photo"] !=
                              null && result
                              .data!['getMe']['getHome']['events'][i]["photo"] !=
                              "") {
                            imageUrls = result
                                .data!['getMe']['getHome']['events'][i]["photo"]
                                .split(" AND ");
                          }

                          all.putIfAbsent(eventsPost(
                            title: result
                                .data!["getMe"]["getHome"]["events"][i]["title"],
                            tags: tags,
                            id: result
                                .data!["getMe"]["getHome"]["events"][i]["id"],
                            createdById: result
                                .data!['getMe']['getHome']['events'][i]['createdBy']['id'],
                            // createdByName: result.data!['getMe']['getHome']['events'][i]['createdBy']['name'],
                            createdByName: '',
                            likeCount: result
                                .data!['getMe']['getHome']['events'][i]['likeCount'],
                            imgUrl: imageUrls,
                            linkName: result
                                .data!['getMe']['getHome']['events'][i]['linkName'],
                            description: result
                                .data!['getMe']['getHome']['events'][i]['content'],
                            linkToAction: result
                                .data!['getMe']['getHome']['events'][i]['linkToAction'],
                            time: result
                                .data!["getMe"]["getHome"]["events"][i]["time"],
                            location: result
                                .data!["getMe"]["getHome"]["events"][i]["location"],
                            isLiked: result
                                .data!["getMe"]["getHome"]["events"][i]["isLiked"],
                            isStarred: result
                                .data!["getMe"]["getHome"]["events"][i]["isStared"],
                            createdAt: DateTime.parse(
                                data["events"][i]["createdAt"]),
                          ),
                                () => "event",
                          );
                        }
                      }
                    }
                    if (isAnnouncements) {

                      all.clear();


                      ///If only announcements is empty and ammouncements filter is applied
                      if(data["announcements"].isEmpty)
                        {
                          return Scaffold(
                            backgroundColor: Color(0xFFDFDFDF),
                            body: Column(
                              children: [
                                PageTitle('Welcome ${userName
                                    .split(" ")
                                    .first}!!}', context),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(15,15,10,15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets
                                            .fromLTRB(
                                            0.0, 0.0, 6.0, 0.0),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              isAnnouncements = !isAnnouncements;
                                              isEvents = false;
                                              isNetops = false;
                                              isAll = !isAll;
                                            });
                                          },
                                          style: ElevatedButton
                                              .styleFrom(
                                            primary: isAnnouncements ? Colors
                                                .white : Color(
                                                0xFF42454D),
                                            padding: const EdgeInsets
                                                .symmetric(vertical: 4,
                                                horizontal: 8),
                                            minimumSize: Size(50, 35),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius
                                                    .circular(20.0)
                                            ),
                                          ),
                                          child: Text("announcements",
                                            style: TextStyle(
                                                fontWeight: FontWeight
                                                    .bold,
                                                color: isAnnouncements ? Color(
                                                    0xFF42454D) : Colors
                                                    .white,
                                                fontSize: 15
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 8),
                                        child: IconButton(
                                          onPressed: () {
                                            showModalBottomSheet(
                                              context: context,
                                              builder: (
                                                  BuildContext context) {
                                                return homeFilters();
                                              },
                                              shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius
                                                    .vertical(
                                                    top: Radius.circular(10)
                                                ),
                                              ),
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.filter_alt_outlined,
                                            color: Color(0xFF42454D),),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0,250,0,0),
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: const Text(
                                        'No announcements yet !!',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 30,
                                            fontWeight: FontWeight.w600
                                        ),
                                        textAlign: TextAlign.center,
                                      )),
                                ),
                              ],
                            ),
                          );
                        }
                      else {
                        for (var i = 0; i <
                            result.data!["getMe"]["getHome"]["announcements"]
                                .length; i++) {
                          List<String> hostelIds = [];
                          List<String> hostelNames = [];
                          for(var j = 0; j < data["announcements"][i]['hostels'].length; j++) {
                            hostelIds.add(data["announcements"][i]["hostels"][j]["id"]);
                            hostelNames.add(data["announcements"][i]["hostels"][j]["name"]);
                          }
                          all.putIfAbsent(Announcement(
                              title: result
                                  .data!["getMe"]["getHome"]["announcements"][i]["title"],
                              hostelIds: hostelIds,
                              description: result
                                  .data!["getMe"]["getHome"]["announcements"][i]["description"],
                              endTime: '',
                              id: result
                                  .data!["getMe"]["getHome"]["announcements"][i]["id"],
                              images: result
                                  .data!["getMe"]["getHome"]["announcements"][i]["images"],
                              createdByUserId: '',
                            hostelNames: hostelNames
                          ),
                                  () => "announcement");
                        }
                      }
                    }
                    if (isAnnouncements == true || isEvents == true ||
                        isNetops == true) {
                      isAll = false;
                    }


                    return Scaffold(
                      key: _scaffoldKey,
                      backgroundColor: Color(0xFFDFDFDF),
                      body: ListView(
                          children: [
                            PageTitle('Welcome ${userName
                                .split(" ")
                                .first}!!', context),
                            Column(
                              children: [
                               ///Filters
                                SizedBox(
                                  height: MediaQuery
                                      .of(context)
                                      .size
                                      .height * 0.07,
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width * 0.9,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0.0, 15, 5, 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        //Selected
                                        Row(
                                          children: [

                                            ///If "all" filter is applied
                                            if(isAll)
                                              Padding(
                                                padding: const EdgeInsets
                                                    .fromLTRB(
                                                    0.0, 0.0, 6.0, 0.0),
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      isAnnouncements = false;
                                                      isEvents = false;
                                                      isNetops = false;
                                                      isAll = true;
                                                    });
                                                  },
                                                  style: ElevatedButton
                                                      .styleFrom(
                                                    primary: isAll ? Colors
                                                        .white : Color(
                                                        0xFF42454D),
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 4,
                                                        horizontal: 8),
                                                    minimumSize: Size(50, 35),
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius
                                                            .circular(20.0)
                                                    ),
                                                  ),
                                                  child: Text("All",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight
                                                            .bold,
                                                        // color: isAll? Colors.white:Color(0xFF42454D),
                                                        color: isAll ? Color(
                                                            0xFF42454D) : Colors
                                                            .white,
                                                        fontSize: 15
                                                    ),
                                                  ),
                                                ),
                                              ),

                                            ///If "Announcements" is applied
                                            if(isAnnouncements)
                                              Padding(
                                                padding: const EdgeInsets
                                                    .fromLTRB(
                                                    0.0, 0.0, 6.0, 0.0),
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      isAnnouncements =
                                                      !isAnnouncements;
                                                      isEvents = false;
                                                      isNetops = false;
                                                      isAll = !isAll;
                                                    });
                                                  },
                                                  style: ElevatedButton
                                                      .styleFrom(
                                                    primary: isAnnouncements
                                                        ? Colors.white
                                                        : Color(0xFF42454D),
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 4,
                                                        horizontal: 8),
                                                    minimumSize: Size(50, 35),
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius
                                                            .circular(20.0)
                                                    ),
                                                  ),
                                                  child: Text("announcements",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight
                                                            .bold,
                                                        color: isAnnouncements
                                                            ? Color(0xFF42454D)
                                                            : Colors.white,
                                                        fontSize: 15
                                                    ),
                                                  ),
                                                ),
                                              ),

                                            ///If "Events" is applied

                                            if(isEvents)
                                              Padding(
                                                padding: const EdgeInsets
                                                    .fromLTRB(
                                                    0.0, 0.0, 6.0, 0.0),
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      isEvents = !isEvents;
                                                      isAnnouncements = false;
                                                      isNetops = false;
                                                      isAll = !isAll;
                                                    });
                                                  },
                                                  style: ElevatedButton
                                                      .styleFrom(
                                                    primary: isEvents ? Colors
                                                        .white : Color(
                                                        0xFF42454D),
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 4,
                                                        horizontal: 8),
                                                    minimumSize: Size(50, 35),
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius
                                                            .circular(20.0)
                                                    ),
                                                  ),
                                                  child: Text("events",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight
                                                            .bold,
                                                        color: isEvents ? Color(
                                                            0xFF42454D) : Colors
                                                            .white,
                                                        fontSize: 15
                                                    ),
                                                  ),
                                                ),
                                              ),

                                            ///If "Netops" is applied
                                            if(isNetops)
                                              Padding(
                                                padding: const EdgeInsets
                                                    .fromLTRB(
                                                    0.0, 0.0, 6.0, 0.0),
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      isNetops = !isNetops;
                                                      isEvents = false;
                                                      isAnnouncements = false;
                                                      isAll = !isAll;
                                                    });
                                                  },
                                                  style: ElevatedButton
                                                      .styleFrom(
                                                    primary: isNetops ? Colors
                                                        .white : Color(
                                                        0xFF42454D),
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 4,
                                                        horizontal: 8),
                                                    minimumSize: Size(50, 35),
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius
                                                            .circular(20.0)
                                                    ),
                                                  ),
                                                  child: Text("Netops",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight
                                                            .bold,
                                                        color: isNetops ? Color(
                                                            0xFF42454D) : Colors
                                                            .white,
                                                        fontSize: 15
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),

                                        ///Filter button to open bottomSheet
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 8),
                                          child: IconButton(
                                            onPressed: () {
                                              showModalBottomSheet(
                                                context: context,
                                                builder: (
                                                    BuildContext context) {
                                                  return homeFilters();
                                                },
                                                shape: const RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .vertical(
                                                      top: Radius.circular(10)
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.filter_alt_outlined,
                                              color: Color(0xFF42454D),),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                ),

                                ///Listing of posts
                                RefreshIndicator(
                                  color: const Color(0xFF2B2E35),
                                  onRefresh: () {
                                    return refetch!();
                                  },
                                  child: ListView(
                                      shrinkWrap: true,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              12, 5, 12, 5),
                                          child: Column(
                                            children: all.keys.map((e) =>
                                                cardFunction(all[e], e, refetch,
                                                    userRole, userid)
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

                    );
                  }
                }
            );
          // }
        }
    );
  }


  ///Function to call category wise cards
  Widget cardFunction (String category, post, Future<QueryResult?> Function()? refetch,userRole,userid){
    if(category == "event"){
      return EventsCard(context, refetch,post.isStarred,post.isLiked,post.likeCount,post.createdAt, post.tags, post, userid,userRole, post.createdById);
    }
    else if(category == "netop"){
      return NetopsCard(context, refetch, post.isStarred,post.isLiked,post.likeCount,post.createdAt, post.tags, userid, post.createdById, reportController, post,'homePage');
    }
    else if(category == "announcement"){
      // return AnnouncementHomeCard(announcements: post);
      return AnnouncementsCards(context,userRole,userid,refetch,post,null);
    }
    return Container();
  }

  ///Widget of Bottom Sheet
  Widget homeFilters () {
    return ListView(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30)
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0,20,0,0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Filter By',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),

              ///All Selected
              Padding(
                padding: const EdgeInsets.fromLTRB(15,20,15,0),
                child: Wrap(
                  children: [
                    Padding(
                    padding: const EdgeInsets.fromLTRB(0,0,10,10),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isAnnouncements = false;
                          isEvents = false;
                          isNetops = false;
                          isAll = true;
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: isAll? const Color(0xFF42454D):const Color(0xFFDFDFDF),
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        minimumSize: const Size(50, 35),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)
                        ),
                      ),
                      child: Text("All",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isAll? Colors.white:const Color(0xFF42454D),
                            fontSize: 15
                        ),
                      ),
                    ),
                  ),
                    ///Events Selected
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,0,10,10),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isEvents = !isEvents;
                            isAnnouncements =  false;
                            isNetops = false;
                            isAll = !isAll;
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: isEvents? const Color(0xFF42454D):const Color(0xFFDFDFDF),
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          minimumSize: const Size(50, 35),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)
                          ),
                        ),
                        child: Text("events",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isEvents? Colors.white:const Color(0xFF42454D),
                              fontSize: 15
                          ),
                        ),
                      ),
                    ),

                    ///Netop Selected
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,0,10,10),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isNetops = !isNetops;
                            isEvents = false;
                            isAnnouncements = false;
                            isAll = !isAll;
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: isNetops? const Color(0xFF42454D):const Color(0xFFDFDFDF),
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          minimumSize: const Size(50, 35),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)
                          ),
                        ),
                        child: Text("netops",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isNetops? Colors.white:const Color(0xFF42454D),
                              fontSize: 15
                          ),
                        ),
                      ),
                    ),

                    ///Announcements Selected
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,0,10,0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isAnnouncements = !isAnnouncements;
                            isEvents = false;
                            isNetops = false;
                            isAll = !isAll;
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: isAnnouncements? const Color(0xFF42454D):const Color(0xFFDFDFDF),
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          minimumSize: const Size(50, 35),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)
                          ),
                        ),
                        child: Text("announcements",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isAnnouncements? Colors.white:const Color(0xFF42454D),
                              fontSize: 15
                          ),
                        ),
                      ),
                    ),
                  ]
                ),
              ),
            ],
      ),
          ),
        ),
    ]
    );
  }
}