
import 'package:client/graphQL/auth.dart';
import 'package:client/graphQL/events.dart';
import 'package:client/models/tag.dart';
import 'package:client/screens/Events/addpost.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'post.dart';
import 'post_card.dart';

class EventsHome extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<EventsHome> {
  String getEvents = eventsQuery().getEvents;
  String getTags = authQuery().getTags;
  bool mostlikesvalue =false;
  bool isStarred =false;
  List<String>selectedFilterIds=[];
  int skip=0;
  int take=10;
  late int total;
  List<Post> posts =[];
  late String userRole;

  ScrollController scrollController =ScrollController();
  var ScaffoldKey = GlobalKey<ScaffoldState>();
  Map<Tag,bool> filterSettings={};
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
              appBar: AppBar(
                title: Text("All Events",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),
                ),
                backgroundColor: Color(0xFF5451FD),
              ),
              body: Center(
                child: CircularProgressIndicator(),
              )
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
        };
        return Query(
            options: QueryOptions(
              document: gql(getEvents),
              variables: {"skip":skip,"take":take,"orderByLikes":mostlikesvalue,"filteringCondition":{"tags":selectedFilterIds,"isStared":isStarred}},
            ),
            builder: (QueryResult result, { fetchMore, refetch }){
              if (result.hasException) {
                print(result.exception.toString());
                return Text(result.exception.toString());
              }
              if(posts.isEmpty) {
                if (result.isLoading) {
                  return Scaffold(
                      appBar: AppBar(
                        title: const Text('All Events'),
                        backgroundColor: Color(0xFF5451FD),
                      ),
                      body: Center(
                        child: CircularProgressIndicator(),
                      )
                  );
                }
              }
              print("resultData:${result}");
              var data=result.data!["getEvents"];
              var eventList= data["list"];
              print("${result.data!["getMe"]}");
              userRole=result.data!["getMe"]["role"];
              // print("${result.data}");
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
                posts.add(Post(
                  createdById: eventList[i]["id"],
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
                )
                );
              };
              total=data["total"];
              FetchMoreOptions opts =FetchMoreOptions(
                  variables: {"skip":skip+10,"take":take,"orderByLikes":mostlikesvalue,"filteringConditions":{"tags":selectedFilterIds,"isStared":isStarred}},
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
                appBar: AppBar(
                  title: Text("All Events",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),),
                  actions: [
                    IconButton(onPressed: () =>
                        ScaffoldKey.currentState?.openEndDrawer(),
                        icon: Icon(Icons.filter_alt_outlined)
                    ),
                    if(userRole=="ADMIN")
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (BuildContext context)=> AddPostEvents(refetchPosts: refetch,)));
                        }, icon: Icon(Icons.add_box))
                  ],
                  backgroundColor: Color(0xFF5451FD),
                ),
                backgroundColor: Color(0xFFF7F7F7),
                body: SafeArea(
                  child: ListView(
                    controller: scrollController,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                        child: Column(children: posts
                          .map((post) => PostCard(
                          refetchPosts: refetch,
                        post: post,
                        index: posts.indexOf(post),
                    ))
                          .toList(),
                    ),
                      ),
                      if(result.isLoading)
                        Center(
                            child: CircularProgressIndicator(color: Colors.yellow,)
                        ),
                    ],
                  ),
                ),
                endDrawer: new Drawer(
                    child: StatefulBuilder(
                      builder: (BuildContext context,StateSetter setState){
                        return SafeArea(
                          child: ListView(
                              primary: false,
                              children: [
                                Column(
                                  children: [
                                    Text('Filter'),
                                    SizedBox(
                                      height: 400.0,
                                      child: ListView(
                                        children: filterSettings.keys.map((key)=>
                                            CheckboxListTile(
                                              value: filterSettings[key],
                                              onChanged:(bool? value){
                                                setState(() {
                                                  filterSettings[key]=value!;
                                                });
                                              },
                                              title: Text(key.Tag_name),
                                            )
                                        ).toList(),
                                      ),
                                    ),
                                    Text('Sort'),
                                    CheckboxListTile(
                                        title: Text('most liked'),
                                        value: mostlikesvalue,
                                        onChanged:(bool? value){
                                          setState(() {
                                            mostlikesvalue=value!;
                                          });
                                        }
                                    ),
                                    CheckboxListTile(
                                        title: Text("Starred"),
                                        value: isStarred,
                                        onChanged:(bool? value){
                                          setState(() {
                                            isStarred=value!;
                                          });
                                        }
                                    ),
                                    ElevatedButton(
                                        onPressed: (){
                                          selectedFilterIds.clear();
                                          filterSettings.forEach((key, value) {
                                            if(value){
                                              selectedFilterIds.add(key.id);
                                            }
                                          });
                                          // print("selectedFilterIds:$selectedFilterIds");
                                          refetch!();
                                        },
                                        child: Text('Apply'))
                                  ],
                                ),
                              ]
                          ),
                        );
                      },
                    )
                ),
              );
            }
        );
      },
    );
  }
}
