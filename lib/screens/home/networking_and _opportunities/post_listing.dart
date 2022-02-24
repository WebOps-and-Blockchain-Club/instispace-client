import 'package:client/graphQL/auth.dart';
import 'package:client/models/commentclass.dart';
import 'package:client/screens/home/networking_and%20_opportunities/addpost.dart';
import 'package:client/widgets/Filters.dart';
import 'package:client/widgets/iconButtons.dart';
import 'package:client/widgets/search.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../models/post.dart';
import '../../../widgets/text.dart';
import 'package:client/widgets/loading screens.dart';
import 'post_card.dart';
import '../../../models/tag.dart';
import 'package:client/graphQL/netops.dart';

class Post_Listing extends StatefulWidget {
  const Post_Listing({Key? key}) : super(key: key);


  @override
  _Post_ListingState createState() => _Post_ListingState();
}

class _Post_ListingState extends State<Post_Listing> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String getNetops = netopsQuery().getNetops;
  String getTags = authQuery().getTags;
  String search = "";
  List<NetOpPost> posts = [];
  bool mostlikesvalue =false;
  bool isStarred =false;
  bool display = false;
  TextEditingController searchController = TextEditingController();
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
              body: Center(
                child: Column(
                  children: [
                    PageTitle('Netops', context),
                    Expanded(
                        child: ListView.separated(
                            itemBuilder: (context, index) => NewCardSkeleton(),
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
        };
        // print("filterIds:$selectedFilterIds");
        // print("$filterSettings");
        // print("isStarred:$isStarred");
        return Query(
            options: QueryOptions(
              document: gql(getNetops),
              variables: {"take":take,"lastNetopId":"","orderByLikes":mostlikesvalue,"filteringCondition":{"tags":selectedFilterIds,"isStared":isStarred}},
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
                    body: Center(
                      child: Column(
                        children: [
                          PageTitle('Netops', context),
                          Expanded(
                              child: ListView.separated(
                                  itemBuilder: (context, index) => NewCardSkeleton(),
                                  separatorBuilder: (context, index) => const SizedBox(height: 6,),
                                  itemCount: 5)
                          )
                        ],
                      ),
                    ),
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
                  variables: {"take":take,"lastNetopId":posts.last.id,"orderByLikes":mostlikesvalue,"filteringCondition":{"tags":selectedFilterIds,"isStared":isStarred}},
                  updateQuery: (previousResultData,fetchMoreResultData){
                    // print("previousResultData:$previousResultData");
                    // print("fetchMoreResultData:${fetchMoreResultData!["getNetops"]["total"]}");
                    // print("posts:$posts");
                    posts.clear();
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
                endDrawer: Drawer(
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
                floatingActionButton: FloatingActionButton(onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (BuildContext context)=> AddPost(refetchPosts: refetch,)));
                },
                  child: Icon(Icons.add),
                  backgroundColor: Color(0xFF5451FD),
                ),

                //Page
                body: ListView(
                  controller: scrollController,
                  children: [
                    PageTitle('Netops',context),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       Expanded(
                    //         flex: 6,
                    //         child: TextFormField(
                    //           controller: searchController,
                    //           // onChanged: (String value){
                    //           //   if(value.length>=3){
                    //           //
                    //           //   }
                    //           // },
                    //         ),
                    //       ),
                    //       IconButton(onPressed: (){
                    //         setState(() {
                    //           display = !display;
                    //           search=searchController.text;
                    //           // print("search String $search");
                    //         });
                    //         if(!display){
                    //           refetch!();
                    //         }
                    //       }, icon: Icon(Icons.search_outlined)),
                    //     ],
                    //   ),
                    // ),

                    Search(search: search, refetch: refetch, ScaffoldKey: _scaffoldKey, page: 'Netops', widget: Filters(mostLikeValues: mostlikesvalue, isStarred: isStarred, selectedFilterIds: selectedFilterIds, filterSettings: filterSettings, refetch: refetch,page: 'Netops',),),
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
