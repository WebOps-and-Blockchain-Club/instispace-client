import 'package:client/graphQL/auth.dart';
import 'package:client/models/commentclass.dart';
import 'package:client/screens/home/networking_and%20_opportunities/addpost.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../models/post.dart';
import 'post_card.dart';
import '../../../models/tag.dart';
import 'package:client/graphQL/netops.dart';

class Post_Listing extends StatefulWidget {

  @override
  _Post_ListingState createState() => _Post_ListingState();
}

class _Post_ListingState extends State<Post_Listing> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String getNetops = netopsQuery().getNetops;
  String getTags = authQuery().getTags;
  List<NetOpPost> posts = [];

  bool mostlikesvalue =false;
  bool isStarred =false;

  Map<Tag,bool> filterSettings={};
  List<String>selectedFilterIds=[];
  int skip=0;
  int take=10;
  ScrollController scrollController =ScrollController();
  late int total;
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
              appBar: AppBar(
                title: const Text('All Posts'),
                backgroundColor: Color(0xFFE6CCA9),
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
        // print("filterIds:$selectedFilterIds");
        // print("$filterSettings");
        // print("isStarred:$isStarred");
        return Query(
            options: QueryOptions(
              document: gql(getNetops),
              variables: {"skip":skip,"take":take,"orderByLikes":mostlikesvalue,"filteringCondition":{"tags":selectedFilterIds,"isStared":isStarred}},
            ),
            builder: (QueryResult result, {fetchMore, refetch}){
              print("Query running");
              print("tags filter:${(selectedFilterIds.isEmpty || selectedFilterIds == [])? null:selectedFilterIds}");
              if (result.hasException) {
                print(result.exception.toString());
                return Text(result.exception.toString());
              }
              if(posts.isEmpty) {
                if (result.isLoading) {
                  return Scaffold(
                    appBar: AppBar(
                      title: const Text('All Posts'),
                      backgroundColor: Color(0xFFE6CCA9),
                    ),
                    body: Center(
                        child: CircularProgressIndicator(),
                  )
                  );
                }
              }
              print("filterCondition:$selectedFilterIds");
              var data=result.data!["getNetops"];
              var netopList= data["netopList"];
              // print("${result.data}");
              posts.clear();
              for(var i=0;i<result.data!["getNetops"]["netopList"].length;i++){
                List<Comment> comments=[];
                List<Tag> tags=[];
                for(var j=0;j<netopList[i]["comments"].length;j++){
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
                // print(comments);
                // print("${netopList[i]["tags"].length}");
                for(var k=0;k<netopList[i]["tags"].length;k++){
                  // print("Tag_name: ${netopList[i]["tags"][k]["title"]}, category: ${netopList[i]["tags"][k]["category"]}");
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
                  comments:comments,
                  description: netopList[i]["content"],
                  like_counter: netopList[i]["likeCount"],
                  tags: tags,
                  endTime: netopList[i]["endTime"],
                  linkToAction:netopList[i]["linkToAction"],
                  linkName: netopList[i]["linkName"],
                  imgUrl: netopList[i]["photo"],
                  attachment:netopList[i]["attachments"],
                  id:netopList[i]["id"],
                )
                );
              };
              total=data["total"];
              FetchMoreOptions opts =FetchMoreOptions(
                  variables: {"skip":skip,"take":take,"orderByLikes":mostlikesvalue,"filteringCondition":{"tags":selectedFilterIds,"isStared":isStarred}},
                  updateQuery: (previousResultData,fetchMoreResultData){
                    // print("previousResultData:$previousResultData");
                    // print("fetchMoreResultData:${fetchMoreResultData!["getNetops"]["total"]}");
                    // print("posts:$posts");
                    final List<dynamic> repos = [
                      ...previousResultData!['getNetops']['netopList'] as List<dynamic>,
                      ...fetchMoreResultData!['getNetops']['netopList'] as List<dynamic>
                    ];
                    fetchMoreResultData['getNetops']['netopList'] = repos;
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

              //UI
              return Scaffold(
                key: _scaffoldKey,
                backgroundColor: Colors.white,
                appBar: AppBar(
                  title: const Text('All Posts',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),),
                  backgroundColor: Color(0xFF5451FD),
                  actions: [
                    IconButton(
                        onPressed: () => _scaffoldKey.currentState!.openEndDrawer(),
                        icon: Icon(Icons.filter_alt_outlined)),
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (BuildContext context)=> AddPost(refetchPosts: refetch,)
                              )
                          );
                        },
                        iconSize: 30.0,
                        icon: Icon(Icons.add)),
                  ],
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
                                        print("selectedFilterIds:${(selectedFilterIds.isEmpty || selectedFilterIds == [])? null:selectedFilterIds}");
                                        Navigator.pop(context);
                                        posts.clear();
                                        print(posts);
                                        refetch!();
                                      },
                                      child: Text('Apply')
                                  )
                                ],
                              ),
                            ]
                        ),
                      );
                    },
                  )
                ),

                //Page
                body: ListView(
                  controller: scrollController,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
                      child: Column(
                        children: posts
                            .map((post) => PostCard(
                          refetchPosts: refetch,
                          post: post,
                        ))
                            .toList(),
                      ),
                    ),
                    if(result.isLoading)
                      Center(
                          child: CircularProgressIndicator(color: Colors.lightBlueAccent,)
                      ),
                  ],
                ),
              );
            }
        );
      }
    );
  }

}
