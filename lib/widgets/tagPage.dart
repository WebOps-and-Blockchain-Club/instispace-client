import 'package:client/graphQL/home.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/netopsClass.dart';
import '../models/tag.dart';
import 'NetOpCard.dart';
import 'eventCard.dart';
import 'loadingScreens.dart';
import 'text.dart';
import '../models/eventsClass.dart';

class TagPage extends StatefulWidget {
  final String tagId;
  final String tagName;
  TagPage({required this.tagId, required this.tagName});
  @override
  _TagPageState createState() => _TagPageState();
}

class _TagPageState extends State<TagPage> {
  ///GraphQL
  String getTag = homeQuery().getTag;

  ///variables
  Map all = {};
  String search = '';
  bool isStarred = false;
  late String userId;
  late String userRole;

  ///Keys
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ///Controllers
  TextEditingController reportController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _sharedPreference();
  }

  SharedPreferences? prefs;
  void _sharedPreference() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs!.getString('id')!;
      userRole = prefs!.getString('role')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: gql(getTag),
          variables: {"tag": widget.tagId},
        ),
        builder: (QueryResult result, {fetchMore, refetch}) {
          if (result.hasException) {
            print(result.exception.toString());
            return Text(result.exception.toString());
          }
          if (result.isLoading) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  widget.tagName,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                backgroundColor: const Color(0xFF2B2E35),
              ),
              body: Center(
                child: Column(
                  children: [
                    Expanded(
                        child: ListView.separated(
                            itemBuilder: (context, index) =>
                                const NewCardSkeleton(),
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                  height: 6,
                                ),
                            itemCount: 5))
                  ],
                ),
              ),
            );
          }

          var data = result.data!["getTag"];

          ///When empty
          if (result.data!["getTag"]["events"] == null ||
              result.data!["getTag"]["netops"].isEmpty) {
            return Scaffold(
              body: Center(
                child: Column(
                  children: [
                    PageTitle(widget.tagName, context),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 250, 0, 0),
                      child: Container(
                          alignment: Alignment.center,
                          child: const Text(
                            'No events & netops Yet !!',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          )),
                    ),
                  ],
                ),
              ),
            );
          } else {
            all.clear();
            for (var i = 0; i < data["events"].length; i++) {
              List<Tag> tags = [];
              for (var k = 0; k < data["events"][i]["tags"].length; k++) {
                // print("Tag_name: ${netopList[i]["tags"][k]["title"]}, category: ${netopList[i]["tags"][k]["category"]}");
                tags.add(
                  Tag(
                    Tag_name: data["events"][i]["tags"][k]["title"],
                    category: data["events"][i]["tags"][k]["category"],
                    id: data["events"][i]["tags"][k]["id"],
                  ),
                );
              }
              all.putIfAbsent(
                eventsPost(
                  title: data["events"][i]["title"],
                  tags: tags,
                  id: data["events"][i]["id"],
                  createdById: data["events"][i]["createdBy"]['id'],
                  createdByName: '',
                  likeCount: data["events"][i]["likeCount"],
                  imgUrl: [],
                  linkName: data["events"][i]["linkName"],
                  description: data["events"][i]["content"],
                  time: data["events"][i]["time"],
                  location: data["events"][i]["location"],
                  linkToAction: data["events"][i]["linkToAction"],
                  isLiked: data["events"][i]["isLiked"],
                  isStarred: data["events"][i]["isStared"],
                  createdAt: DateTime.parse(data["events"][i]["createdAt"]),
                ),
                () => "event",
              );
            }

            for (var i = 0; i < data["netops"].length; i++) {
              List<Tag> tags = [];
              for (var k = 0; k < data["netops"][i]["tags"].length; k++) {
                // print("Tag_name: ${netopList[i]["tags"][k]["title"]}, category: ${netopList[i]["tags"][k]["category"]}");
                tags.add(
                  Tag(
                    Tag_name: data["netops"][i]["tags"][k]["title"],
                    category: data["netops"][i]["tags"][k]["category"],
                    id: data["netops"][i]["tags"][k]["id"],
                  ),
                );
              }
              all.putIfAbsent(
                  NetOpPost(
                    title: result.data!["getTag"]["netops"][i]["title"],
                    tags: tags,
                    id: result.data!["getTag"]["netops"][i]["id"],
                    createdByName: '',
                    likeCount: data["netops"][i]["likeCount"],
                    endTime: data['netops'][i]['endTime'],
                    attachment: data['netops'][i]['attachments'],
                    imgUrl: data['netops'][i]['photo'],
                    linkToAction: data['netops'][i]['linkToAction'],
                    linkName: data['netops'][i]['linkName'],
                    description: data["netops"][i]["content"],
                    isLiked: data['netops'][i]['isLiked'],
                    isStarred: data['netops'][i]['isStared'],
                    createdById: data["netops"][i]["createdBy"]["id"],
                    createdAt: DateTime.parse(data["netops"][i]["createdAt"]),
                  ),
                  () => "netop");
            }
            return Scaffold(
              key: _scaffoldKey,

              appBar: AppBar(
                title: Text(
                  widget.tagName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                backgroundColor: Color(0xFF2B2E35),
                elevation: 0.0,
              ),

              ///background colour
              backgroundColor: Color(0xFFDFDFDF),

              body: ListView(children: [
                Column(
                  children: [
                    ///Listing of cards
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.9,
                      child: ListView(shrinkWrap: true, children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Column(
                            children: all.keys
                                .map((e) => cardFunction(
                                    all[e], e, refetch, userId, userRole))
                                .toList(),
                          ),
                        ),
                        if (result.isLoading)
                          const Center(
                              child: CircularProgressIndicator(
                            color: Colors.lightBlueAccent,
                          )),
                      ]),
                    ),
                  ],
                ),
              ]),
            );
          }
        });
  }

  ///widget to call different category if cards
  Widget cardFunction(String category, post, refetch, String userid, userRole) {
    if (category == "event") {
      return EventsCard(
        refetch: refetch,
        post: post,
        userId: userid,
        userRole: userRole,
      );
    } else if (category == "netop") {
      return NetopsCard(
        post: post,
        refetch: refetch,
        page: 'NetopsSection',
        userId: userid,
      );
    }
    return Container();
  }
}
