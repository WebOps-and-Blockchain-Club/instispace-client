import 'package:client/models/commentclass.dart';
import 'package:client/screens/home/networking_and%20_opportunities/addpost.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../models/post.dart';
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
  List<Post> posts = [
  ];
  var A2Zvalue = false;
  var Z2Avalue =false;
  var Earliestvalue = false;
  var latervalue =false;
  var mostlikesvalue =false;
  Map<String, bool> values = {
    'workshop': false,
    'por': false,
    'startup':false,
    'internship' :false,
  };
   List <String> ? selectedTags;
   bool isStarred =false;
  String filteringCondition="""
  {
  "tags":\$selectedTags,
  isStared:\$isStarred,
  }
  """;
  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(getNetops),
        variables: {"skip":0,"take":10,"orderByLikes":mostlikesvalue},
      ),
      builder: (QueryResult result, {fetchMore, refetch}){
        if (result.hasException) {
          print(result.exception.toString());
          return Text(result.exception.toString());
        }
        if (result.isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        var data=result.data!["getNetops"];
        var netopList= data["netopList"];
        // print("${result.data}");
        posts.clear();
        for(var i=0;i<data["total"];i++){
          List<Comment> comments=[];
          List<Tag> tags=[];
          for(var j=0;j<netopList[i]["comments"].length;j++){
            // print("message: ${netopList[i]["comments"][j]["content"]}, id: ${netopList[i]["comments"][j]["id"]}");
            comments.add(
                Comment(
                    message: netopList[i]["comments"][j]["content"],
                    id: netopList[i]["comments"][j]["id"])
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
          posts.add(Post(
            title: netopList[i]["title"],
            comments:comments,
            description: netopList[i]["content"],
            like_counter: netopList[i]["likeCount"],
            tags: tags,
            endTime: netopList[i]["endTime"],
            linktoaction:"",
            imgUrl: "",
            id:netopList[i]["id"],
          )
          );
        };
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          endDrawer: new Drawer(
            child: SafeArea(
              child: ListView(
                  primary: false,
                  children: [
                    Column(
                      children: [
                        Text('Filter'),
                        SizedBox(
                          height: 400.0,
                          child: ListView(
                            children: values.keys.map((String key) {
                              return new CheckboxListTile(
                                title: new Text(key),
                                activeColor: Colors.blue,
                                value: values[key],
                                onChanged: (bool? value) {
                                  setState(() {
                                    values[key] = value!;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ),
                        Text('Sort'),
                        CheckboxListTile(
                            title: Text('Earliest to later'),
                            value: Earliestvalue,
                            onChanged:(bool? value){
                              setState(() {
                                Earliestvalue=value!;
                              });
                            }
                        ),
                        CheckboxListTile(
                            title: Text('Later to Earliest'),
                            value: latervalue,
                            onChanged:(bool? value){
                              setState(() {
                                latervalue=value!;
                              });
                            }
                        ),
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
                            title: Text('A to Z'),
                            value: A2Zvalue,
                            onChanged:(bool? value){
                              setState(() {
                                A2Zvalue=value!;
                              });
                            }
                        ),
                        CheckboxListTile(
                            title: Text('Z to A'),
                            value: Z2Avalue,
                            onChanged:(bool? value){
                              setState(() {
                                Z2Avalue=value!;
                              });
                            }
                        ),
                      ],
                    ),
                  ]
              ),
            ),
          ),
          appBar: AppBar(
            title: const Text('All Posts'),
            backgroundColor: Color(0xFFE6CCA9),
            actions: [
              IconButton(
                  onPressed: () => _scaffoldKey.currentState!.openEndDrawer(),
                  icon: Icon(Icons.filter_alt_outlined)),
              IconButton(
                  onPressed: () => {
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (BuildContext context)=> AddPost())),
                  },
                  iconSize: 35.0,
                  icon: Icon(Icons.add_box)),
            ],
          ),
          body: ListView(
            children: [
              Column(
                children: posts
                    .map((post) => PostCard(
                  post: post,
                ))
                    .toList(),
              )
            ],
          ),
        );
      }
    );
  }
}
