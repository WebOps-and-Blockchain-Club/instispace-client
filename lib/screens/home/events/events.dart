import 'package:client/graphQL/auth.dart';
import 'package:client/graphQL/events.dart';
import 'package:client/models/tag.dart';
import 'package:client/screens/home/Events/addEvent.dart';
import 'package:client/widgets/eventCard.dart';
import 'package:client/widgets/search.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../widgets/text.dart';
import 'package:client/widgets/filters.dart';
import 'package:client/widgets/text.dart';
import 'package:client/widgets/loadingScreens.dart';
import '../../../models/eventsClass.dart';

class EventsHome extends StatefulWidget {
  const EventsHome({Key? key}) : super(key: key);


  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<EventsHome> {

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
      userRole = prefs!.getString('role')!;
      userid = prefs!.getString('id')!;
    });
  }

  ///GraphQL
  String getEvents = eventsQuery().getEvents;
  String getTags = authQuery().getTags;


  ///Variables
  bool mostlikesvalue =false;
  bool isStarred =false;
  List<String>selectedFilterIds=[];
  Map<Tag,bool> filterSettings={};
  int skip=0;
  int take=10;
  bool display = false;
  late int total;
  List<eventsPost> posts =[];
  String userRole ="";
  String userid = "";
  String search = "";


  ///Controllers
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController =ScrollController();


  ///Keys
  var ScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(getTags),
      ),
      builder: (QueryResult result, {fetchMore, refetch}){
        filterSettings.clear();
        if (result.hasException) {
          return Text(result.exception.toString());
        }
        if(result.isLoading){
          return Scaffold(
              body: Center(
                child: Column(
                  children: [
                    PageTitle('Events', context),
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
              document: gql(getEvents),
              variables: {"getEventsTake":take,"lastEventId": "","orderByLikes":mostlikesvalue,"filteringCondition":{"tags":selectedFilterIds,"isStared":isStarred},"search":search},
            ),
            builder: (QueryResult result, { fetchMore, refetch }){
              if (result.hasException) {
                return Text(result.exception.toString());
              }

              if(posts.isEmpty) {
                if (result.isLoading) {
                  return Scaffold(
                      body: Center(
                        child: Column(
                          children: [
                            PageTitle('Events', context),
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

              ///Screen if there is no Event
              if (result.data!["getEvents"]["list"] == null || result.data!["getEvents"]["list"].isEmpty){
                return Scaffold(
                  floatingActionButton: _getFAB(refetch),
                  body: Center(
                    child: Column(
                      children: [
                        PageTitle('Events', context),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0,250,0,0),
                          child: Container(
                            alignment: Alignment.center,
                              child: const Text(
                                'No Events Yet !!',
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

              else{
              var data=result.data!["getEvents"];
              var eventList= data["list"];

              posts.clear();
              for(var i=0;i<result.data!["getEvents"]["list"].length;i++){
                List<Tag> tags=[];
                for(var k=0;k<eventList[i]["tags"].length;k++){
                  // print("Tag_name: ${eventList[i]["tags"][k]["title"]}, category: ${eventList[i]["tags"][k]["category"]}");
                  tags.add(
                    Tag(
                      Tag_name: eventList[i]["tags"][k]["title"],
                      category: eventList[i]["tags"][k]["category"],
                      id: eventList[i]["tags"][k]["id"],
                    ),
                  );
                }
                List<String> imageUrls=[];
                if(eventList[i]["photo"]!=null && eventList[i]["photo"]!="")
                {imageUrls=eventList[i]["photo"].split(" AND ");}
                posts.add(eventsPost(
                  createdById: eventList[i]["createdBy"]["id"],
                  // createdByName: eventList[i]["name"],
                  createdByName: '',
                  linkName: eventList[i]["linkName"],
                  location: eventList[i]["location"],
                  title: eventList[i]["title"],
                  description: eventList[i]["content"],
                  likeCount: eventList[i]["likeCount"],
                  tags: tags,
                  time: eventList[i]["time"],
                  linkToAction:eventList[i]["linkToAction"],
                  imgUrl: imageUrls,
                  id:eventList[i]["id"],
                  isLiked: eventList[i]["isLiked"],
                  isStarred: eventList[i]["isStared"],
                  createdAt: DateTime.parse(eventList[i]["createdAt"]),
                )
                );
              }
              total=data["total"];
              FetchMoreOptions opts =FetchMoreOptions(
                  variables: {"getEventsTake":take,"lastEventId": posts.last.id,"orderByLikes":mostlikesvalue,"filteringCondition":{"tags":selectedFilterIds,"isStared":isStarred},"search": search},
                  updateQuery: (previousResultData,fetchMoreResultData){

                    final List<dynamic> repos = [
                      ...previousResultData!["getEvents"]["list"] as List<dynamic>,
                      ...fetchMoreResultData!["getEvents"]["list"] as List<dynamic>
                    ];
                    fetchMoreResultData["getEvents"]["list"] = repos;
                    return fetchMoreResultData;
                  }
              );
              scrollController.addListener(()async {
                var triggerFetchMoreSize =
                    0.99 * scrollController.position.maxScrollExtent;
                if (scrollController.position.pixels >
                    triggerFetchMoreSize && total>posts.length){
                  await fetchMore!(opts);
                  scrollController.jumpTo(triggerFetchMoreSize);
                }
              });


              return Scaffold(
                key: ScaffoldKey,
                backgroundColor: const Color(0xFFF7F7F7),
                floatingActionButton: _getFAB(refetch),
                body: SafeArea(
                  child: ListView(
                    controller: scrollController,
                    children: [

                      ///Heading
                      PageTitle('Events',context),
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.06,
                        width: MediaQuery.of(context).size.width*0.9,

                        ///Calling search bar + filter button
                        child: Search(
                            search: search,
                            refetch: refetch,
                            ScaffoldKey: ScaffoldKey,
                            page: 'events',
                            widget: Filters(refetch: refetch,
                              mostLikeValues: mostlikesvalue,
                              isStarred: isStarred,
                              filterSettings: filterSettings,
                              selectedFilterIds: selectedFilterIds,
                              page: 'events', callback: (bool val) { setState(() {
                                isStarred= val;
                              });},
                            ), callback: (val) {setState(() {
                          search = val;
                            });},
                        ),
                      ),

                      ///Listing all the events
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: RefreshIndicator(
                          onRefresh: () {
                            return refetch!();
                          },
                          color: const Color(0xFF2B2E35),
                          child: ListView(
                            shrinkWrap: true,
                            children: posts
                            .map((post) => EventsCard(context, refetch,post.isStarred,post.isLiked,post.likeCount,post.createdAt, post.tags, post, userid,userRole, post.createdById))
                            .toList(),
                    ),
                        ),
                      ),
                      if(result.isLoading)
                        const Center(
                            child: CircularProgressIndicator(color: Colors.yellow,)
                        ),
                    ],
                  ),
                ),
              );
            }
            }
        );
      },
    );
  }

  ///Widget for the floating action button
  Widget? _getFAB(Future<QueryResult?> Function()? refetch) {
    if(userRole=="ADMIN" || userRole == 'HAS' || userRole == 'SECRETORY' || userRole == 'HOSTEL_SEC' || userRole == 'LEADS' || userRole == 'MODERATOR'){
      return FloatingActionButton(onPressed: () {
        Navigator.of(context).push(
            MaterialPageRoute(
                builder: (BuildContext context)=> AddPostEvents(refetchPosts: refetch,)));
      },
        child: const Icon(Icons.add),
        backgroundColor: Colors.black,
      );
    }
    else {
      return null;
    }
  }
}
