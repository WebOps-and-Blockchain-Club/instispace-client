import 'package:client/graphQL/auth.dart';
import 'package:client/models/commentclass.dart';
import 'package:client/screens/home/Netops/addNetops.dart';
import 'package:client/widgets/filters.dart';
import 'package:client/widgets/search.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/netopsClass.dart';
import '../../../widgets/text.dart';
import 'package:client/widgets/loadingScreens.dart';
import '../../../models/tag.dart';
import 'package:client/graphQL/netops.dart';
import 'package:client/widgets/NetOpCard.dart';
import 'package:http/http.dart' as http;


class Post_Listing extends StatefulWidget {
  const Post_Listing({Key? key}) : super(key: key);


  @override
  _Post_ListingState createState() => _Post_ListingState();
}

class _Post_ListingState extends State<Post_Listing> {

  ///GraphQL
  String getNetops = netopsQuery().getNetops;
  String getTags = authQuery().getTags;

  ///Variables
  String search = "";
  List<NetOpPost> posts = [];
  bool mostlikesvalue =false;
  bool isStarred =false;
  bool display = false;
  Map<Tag,bool> filterSettings={};
  List<String>selectedFilterIds=[];
  late int total;
  int take=10;
  var bytes;

  ///Controllers
  ScrollController scrollController =ScrollController();
  TextEditingController reportController =TextEditingController();
  TextEditingController searchController = TextEditingController();

  ///Keys
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String userId="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _sharedPreference();
  }
  SharedPreferences? prefs;
  void _sharedPreference()async{
    prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs!.getString('id')!;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
            document: gql(getTags)
        ),
        builder:(QueryResult result, {fetchMore, refetch}){
          filterSettings.clear();
          if (result.hasException) {
            return Text(result.exception.toString());
          }
          if(result.isLoading){
            return Scaffold(
              body: Center(
                child: Column(
                  children: [
                    PageTitle('Netops', context),
                    Expanded(
                        child: ListView.separated(
                            itemBuilder: (context, index) => const NewCardSkeleton(),
                            separatorBuilder: (context, index) => const SizedBox(height: 6,),
                            itemCount: 5)
                    )
                  ],
                ),
              ),
            );
          }
          var tagData = result.data!["getTags"];
          for(var i=0;i<tagData.length;i++ ){
            filterSettings.putIfAbsent(
                Tag(
                  category: tagData[i]["category"],
                  id: tagData[i]["id"],
                  Tag_name: tagData[i]["title"],
                ), () => false);
          }
          return Query(
              options: QueryOptions(
                document: gql(getNetops),
                variables: {"take":take,"lastNetopId":"","orderByLikes":mostlikesvalue,"filteringCondition":{"tags": selectedFilterIds,"isStared":isStarred},"search": search},
              ),
              builder: (QueryResult result, {fetchMore, refetch}){
                if (result.hasException) {
                  return Text(result.exception.toString());
                }
                if(posts.isEmpty) {
                  if (result.isLoading) {
                    return Scaffold(
                      body: Center(
                        child: Column(
                          children: [
                            PageTitle('Netops', context),
                            Expanded(
                                child: ListView.separated(
                                    itemBuilder: (context, index) => const NewCardSkeleton(),
                                    separatorBuilder: (context, index) => const SizedBox(height: 6,),
                                    itemCount: 5)
                            )
                          ],
                        ),
                      ),
                    );
                  }
                }

                if (result.data!["getNetops"]["netopList"] == null || result.data!["getNetops"]["netopList"].isEmpty){
                  return Scaffold(
                    body: Center(
                      child: Column(
                        children: [
                          PageTitle('Netops', context),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0,250,0,0),
                            child: Container(
                                alignment: Alignment.center,
                                child: const Text(
                                  'No Netops Yet !!',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600
                                  ),
                                  textAlign: TextAlign.center,
                                )
                            ),
                          ),
                        ],
                      ),
                    ),
                    floatingActionButton: FloatingActionButton(onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  AddPost(refetchPosts: refetch,)));
                    },
                      child: const Icon(Icons.add),
                      backgroundColor: const Color(0xFFFF0000),
                    ),
                  );
                }
                else {
                  var data = result.data!["getNetops"];
                  var netopList = data["netopList"];
                  posts.clear();
                  for (var i = 0; i < result.data!["getNetops"]["netopList"].length; i++) {
                    List<Comment> comments = [];
                    List<Tag> tags = [];
                    for (var j = 0; j < netopList[i]["comments"].length; j++) {
                      // print("message: ${netopList[i]["comments"][j]["content"]}, id: ${netopList[i]["comments"][j]["id"]}");
                      comments.add(
                          Comment(
                            message: netopList[i]["comments"][j]["content"],
                            id: netopList[i]["comments"][j]["id"],
                            name: "Name",
                            //ToDO comment name
                            // netopList[i]["comments"][j]["createdBy"]["name"]
                          )
                      );
                    }
                    for (var k = 0; k < netopList[i]["tags"].length; k++) {
                      tags.add(
                        Tag(
                          Tag_name: netopList[i]["tags"][k]["title"],
                          category: netopList[i]["tags"][k]["category"],
                          id: netopList[i]["tags"][k]["id"],
                        ),
                      );
                    }
                    posts.add(NetOpPost(
                      title: netopList[i]["title"],
                      comments: comments,
                      description: netopList[i]["content"],
                      likeCount: netopList[i]["likeCount"],
                      tags: tags,
                      endTime: netopList[i]["endTime"],
                      createdByName: '',
                      linkToAction: netopList[i]["linkToAction"],
                      linkName: netopList[i]["linkName"],
                      imgUrl: netopList[i]["photo"],
                      attachment: netopList[i]["attachments"],
                      id: netopList[i]["id"],
                      isLiked: netopList[i]['isLiked'],
                      isStarred: netopList[i]['isStared'],
                      createdById: netopList[i]["createdBy"]["id"],
                      createdAt: DateTime.parse(netopList[i]["createdAt"]),
                    )
                    );
                  }
                  total = data["total"];
                  FetchMoreOptions opts = FetchMoreOptions(
                      variables: {
                        "take": take,
                        "lastNetopId": posts.last.id,
                        "orderByLikes": mostlikesvalue,
                        "filteringCondition": {
                          "tags": selectedFilterIds,
                          "isStared": isStarred
                        },
                        "search": search
                      },
                      updateQuery: (previousResultData, fetchMoreResultData) {
                        posts.clear();
                        final List<dynamic> repos = [
                          ...previousResultData!['getNetops']['netopList'] as List<dynamic>,
                          ...fetchMoreResultData!['getNetops']['netopList'] as List<dynamic>
                        ];
                        fetchMoreResultData['getNetops']['netopList'] = repos;
                        return fetchMoreResultData;
                      }
                      );
                  scrollController.addListener(() async {
                    var triggerFetchMoreSize =
                        0.99 * scrollController.position.maxScrollExtent;
                    if (scrollController.position.pixels >
                        triggerFetchMoreSize && total > posts.length) {
                      await fetchMore!(opts);
                      scrollController.jumpTo(triggerFetchMoreSize);
                    }
                  }
                  );

                  return Scaffold(

                    key: _scaffoldKey,

                    backgroundColor: Color(0xFFDFDFDF),

                    ///Floating Action Button
                    floatingActionButton: FloatingActionButton(onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  AddPost(refetchPosts: refetch,)));
                      },
                      child: const Icon(Icons.add),
                      backgroundColor: const Color(0xFFFF0000),
                    ),

                    ///Page
                    body: RefreshIndicator(
                      onRefresh: () {
                        return refetch!();
                      },
                      child: ListView(
                          children: [
                            Column(
                              children: [
                                ///Heading
                                PageTitle('Netops', context),

                                ///Search bar and filter button
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.06,
                                    width: MediaQuery.of(context).size.width * 1,
                                    child: Search(
                                      search: search,
                                      refetch: refetch,
                                      ScaffoldKey: _scaffoldKey,
                                      page: 'netops',
                                      callback: (String val) {
                                        setState(() {
                                          search = val;
                                        }
                                        );
                                        },
                                      widget: Filters(
                                        mostLikeValues: mostlikesvalue,
                                        isStarred: isStarred,
                                        selectedFilterIds: selectedFilterIds,
                                        filterSettings: filterSettings,
                                        refetch: refetch,
                                        page: 'netops',
                                        callback: (bool val) {
                                          setState(() {
                                            isStarred = val;
                                          });
                                          },
                                      ),
                                    ),
                                  ),
                                ),

                                ///Listing of netops cards
                                ListView(
                                    controller: scrollController,
                                    shrinkWrap: true,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                        child: Column(
                                          children: posts
                                              .map((post) =>
                                              NetopsCard(
                                                  context,
                                                  refetch,
                                                  post.isStarred,
                                                  post.isLiked,
                                                  post.likeCount,
                                                  post.createdAt,
                                                  post.tags,
                                                  userId,
                                                  post.createdById,
                                                  reportController,
                                                  post,
                                                  'NetopsSection'))
                                              .toList(),
                                        ),
                                      ),
                                    ]
                                ),
                                if(result.isLoading)
                                  const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.lightBlueAccent,)
                                  ),
                              ],
                            ),
                          ]
                      ),
                    ),
                  );
                }

              }
          );
        }
    );

  }
}


