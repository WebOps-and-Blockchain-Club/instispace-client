import 'package:client/graphQL/netops.dart';
import 'package:client/screens/home/networking_and%20_opportunities/editpost.dart';
import 'package:client/screens/home/networking_and%20_opportunities/singlepost.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../models/post.dart';
import '../../../models/tag.dart';
import 'package:client/screens/home/networking_and _opportunities/comments.dart';
import 'package:expandable/expandable.dart';



class PostCard extends StatefulWidget {
  final NetOpPost post;
  final Future<QueryResult?> Function()? refetchPosts;
  PostCard({required this.post,required this.refetchPosts});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  String reportNetop=netopsQuery().reportNetop;
  String toggleLike = netopsQuery().toggleLike;
  String toggleStar=netopsQuery().toggleStar;
  String deleteNetop=netopsQuery().deleteNetop;
  late bool isLiked;
  late bool isStarred;
  String getNetop= netopsQuery().getNetop;
  late String createdId;
  late String userId;
  TextEditingController reportController =TextEditingController();
  @override
  Widget build(BuildContext context) {
    List<Tag>tags = widget.post.tags;
    DateTime dateTime = DateTime.parse(widget.post.endTime);
    var likeCount;
          return Query(
              options: QueryOptions(
                document: gql(getNetop),
                variables: {"getNetopNetopId":widget.post.id},
              ),
              builder:(QueryResult result, {fetchMore, refetch}){
                if (result.hasException) {
                  print(result.exception.toString());
                  return Text(result.exception.toString());
                }
                if(result.isLoading){
                  return Card(
                      clipBehavior: Clip.antiAlias,
                      elevation: 5.0,
                      color: Color(0xFFF9F6F2),
                    child: SizedBox(
                      height: 60,
                      width: 20,
                    )
                  );
                }
                likeCount=result.data!["getNetop"]["likeCount"];
                isLiked=result.data!["getNetop"]["isLiked"];
                isStarred=result.data!["getNetop"]["isStared"];
                createdId=result.data!["getNetop"]["createdBy"]["id"];
                userId=result.data!["getMe"]["id"];
                // print("createdId:$createdId");
                // print("userID:$userId");
                return ExpandableNotifier(
                  child: ScrollOnExpand(
                    child: ExpandablePanel(
                        theme: ExpandableThemeData(
                          tapBodyToCollapse: true,
                          tapBodyToExpand: true,
                        ),

                        expanded: SizedBox(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * 1,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 1,
                            child: Single_Post(post: widget.post,isStarred: isStarred,refetch: refetch,)),

                        collapsed: Padding(
                          padding: const EdgeInsets.fromLTRB(2, 2, 2, 3),
                          child: Card(
                              clipBehavior: Clip.antiAlias,
                              elevation: 5.0,
                              color: Color(0xFF808CFF),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(12.0, 0.0, 0.0, 0.0),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          //Title & Star
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              //Title
                                              SizedBox(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width * 0.5,
                                                child: Text(
                                                  widget.post.title,
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),

                                              Mutation(
                                                  options:MutationOptions(
                                                      document: gql(toggleStar)
                                                  ),
                                                  builder: (
                                                      RunMutation runMutation,
                                                      QueryResult? result,
                                                      ){
                                                    if (result!.hasException){
                                                      print(result.exception.toString());
                                                    }
                                                    return IconButton(
                                                      onPressed: (){
                                                        runMutation({
                                                          "toggleStarNetopId":widget.post.id
                                                        });
                                                        refetch!();
                                                      },
                                                      icon: isStarred?Icon(Icons.star):Icon(Icons.star_border),
                                                      color: isStarred? Colors.amber:Colors.white,
                                                    );
                                                  }
                                              ),
                                            ],
                                          ),

                                          //Images
                                          if(widget.post.imgUrl==null)
                                            Text(
                                              widget.post.description.length > 250
                                                  ? widget.post.description.substring(
                                                  0, 250) + '...'
                                                  : widget.post.description,
                                              style: TextStyle(
                                                fontSize: 15.0,
                                              ),
                                            ),
                                          if(widget.post.imgUrl !=null)
                                            SizedBox(
                                                width: 400.0,
                                                child: Image.network(
                                                    widget.post.imgUrl!,
                                                    height: 150.0)
                                            ),

                                          //Rows for Tags, Icons
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(0, 5, 12, 5),
                                            child: Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    //Tags
                                                    Padding(
                                                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                                      child: SizedBox(
                                                        width: 200.0,
                                                        height: 20.0,
                                                        child: ListView(
                                                          scrollDirection: Axis.horizontal,
                                                          children: tags.map((tag) =>
                                                              SizedBox(
                                                                height: 25.0,
                                                                child: Padding(
                                                                  padding: const EdgeInsets.fromLTRB(2.0, 0.0, 2.0, 0.0),
                                                                  child: ElevatedButton(
                                                                      onPressed: () => {},
                                                                      style: ElevatedButton.styleFrom(
                                                                        primary: Color(0xFFFFFFFF),
                                                                        padding: EdgeInsets.symmetric(
                                                                            vertical: 2,
                                                                            horizontal: 6),
                                                                      ),
                                                                    child: Text(
                                                                      tag.Tag_name,
                                                                      style: TextStyle(
                                                                        color: Color(0xFF021096),
                                                                        fontSize: 12.5,
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                    ),),
                                                                ),
                                                              )).toList(),
                                                        ),
                                                      ),
                                                    ),

                                                    //Icons
                                                    Padding(
                                                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                                                      child: Row(
                                                        children: [
                                                          //Share Icon
                                                          Ink(
                                                            decoration: const ShapeDecoration(
                                                                color: Color(0xFFFFFFFF),
                                                                shape: CircleBorder(
                                                                  side: BorderSide.none,
                                                                )
                                                            ),
                                                            height: 36,
                                                            width: 36,
                                                            child: Center(
                                                              child: IconButton(onPressed: () =>
                                                              {
                                                                print(dateTime),
                                                                print('shared')
                                                              }, icon: Icon(Icons.share),
                                                                iconSize: 20,
                                                                color: Color(0xFF021096),),
                                                            ),
                                                          ),
                                                          SizedBox(width: 5,),

                                                          //Reminder
                                                          Ink(
                                                            decoration: const ShapeDecoration(
                                                                color: Colors.white,
                                                                shape: CircleBorder(
                                                                  side: BorderSide.none,
                                                                )
                                                            ),
                                                            height: 36,
                                                            width: 36,
                                                            child: Center(
                                                              child: IconButton(onPressed: () =>
                                                              {
                                                                print('remainder added')
                                                              },
                                                                icon: Icon(Icons.access_alarm),
                                                                iconSize: 20,
                                                                color: Color(0xFF021096),),
                                                            ),
                                                          ),
                                                          SizedBox(width: 5,),

                                                          Mutation(
                                                              options:MutationOptions(
                                                                  document: gql(toggleLike)
                                                              ),
                                                              builder: (
                                                                  RunMutation runMutation,
                                                                  QueryResult? result,
                                                                  ){
                                                                if (result!.hasException){
                                                                  print(result.exception.toString());
                                                                }
                                                                return Ink(
                                                                  decoration: const ShapeDecoration(
                                                                      color: Color(0xFFFFFFFF),
                                                                      shape: CircleBorder(
                                                                        side: BorderSide.none,
                                                                      )
                                                                  ),
                                                                  height: 36,
                                                                  width: 36,
                                                                  child: Center(
                                                                    child: IconButton(onPressed: () =>
                                                                    {
                                                                      Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                Comments(post: widget
                                                                                    .post,)),
                                                                      ),
                                                                      print('commented'),
                                                                    }, icon: Icon(Icons.comment),
                                                                      iconSize: 20,
                                                                      color: Color(0xFF021096),),
                                                                  ),
                                                                );
                                                              }
                                                          ),
                                                          SizedBox(width: 5,),

                                                          Mutation(
                                                              options:MutationOptions(
                                                                  document: gql(toggleLike)
                                                              ),
                                                              builder: (
                                                                  RunMutation runMutation,
                                                                  QueryResult? result,
                                                                  ){
                                                                if (result!.hasException){
                                                                  print(result.exception.toString());
                                                                }
                                                                return Ink(
                                                                  decoration: const ShapeDecoration(
                                                                      color: Color(0xFFFFFFFF),
                                                                      shape: CircleBorder(
                                                                        side: BorderSide.none,
                                                                      )
                                                                  ),
                                                                  height: 36,
                                                                  width: 36,
                                                                  child: Center(
                                                                    child: IconButton(
                                                                      onPressed: () =>
                                                                      {
                                                                        print('remainder added')
                                                                      },
                                                                      icon: Icon(Icons.thumb_up),
                                                                      iconSize: 20,
                                                                      color: Color(0xFF021096),
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                          ),

                                                          Container(
                                                            margin: EdgeInsets.only(left: 10.0),
                                                            child: Text(
                                                              "$likeCount likes",
                                                              style: TextStyle(
                                                                color: Color(0xFFFFFFFF),
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 16.0,
                                                              ),
                                                            ),
                                                          ),

                                                        ],
                                                      ),
                                                    ),

                                                    //Button Row
                                                    Row(
                                                      children: [
                                                        if(userId==createdId)
                                                          SizedBox(
                                                            width: 60,
                                                            child: ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                primary: Color(0xFF021096),
                                                                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                                                minimumSize: Size(35,25),
                                                              ),
                                                              child: Text('Edit',
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.bold,
                                                                ),),
                                                              onPressed: (){
                                                                Navigator.of(context).push(
                                                                    MaterialPageRoute(
                                                                        builder: (BuildContext context)=> EditPost(post: widget.post,refetchPosts: widget.refetchPosts,)));
                                                              },
                                                            ),
                                                          ),
                                                        SizedBox(width: 8,),

                                                        if(userId==createdId)
                                                          Mutation(
                                                              options: MutationOptions(
                                                                  document: gql(deleteNetop)
                                                              ),
                                                              builder:(
                                                                  RunMutation runMutation,
                                                                  QueryResult? result,
                                                                  ){
                                                                if (result!.hasException){
                                                                  print(result.exception.toString());
                                                                }
                                                                if(result.isLoading){
                                                                  return CircularProgressIndicator();
                                                                }
                                                                return SizedBox(
                                                                  width: 65,
                                                                  child: ElevatedButton(
                                                                      style: ElevatedButton.styleFrom(
                                                                        primary: Color(0xFF021096),
                                                                        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                                                        minimumSize: Size(35,25),
                                                                      ),
                                                                      onPressed: (){
                                                                        runMutation({
                                                                          "eventId":widget.post.id
                                                                        });
                                                                      },
                                                                      child: Text('Delete',
                                                                        style: TextStyle(
                                                                          color: Colors.white,
                                                                          fontSize: 14,
                                                                          fontWeight: FontWeight.w500,
                                                                        ),)
                                                                  ),
                                                                );
                                                              }
                                                          ),
                                                        SizedBox(width: 8,),

                                                        SizedBox(
                                                          child: ElevatedButton(
                                                            child: Text('Report',
                                                              style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w500,
                                                              ),),
                                                            style: ElevatedButton.styleFrom(
                                                              primary: Color(0xFF021096),
                                                              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                                              minimumSize: Size(35,25),
                                                            ),
                                                            onPressed: (){
                                                              return showAlertDialog(context);
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),

                                        ],
                                      ),
                                    ]
                                ),
                              )
                          ),
                        ),
                        builder: (_, collapsed, expanded) =>
                            Expandable(
                              collapsed: collapsed, expanded: expanded,)
                    ),
                  ),
                  // ),
                );
              }
          );
        }
  showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
        reportController.clear();
      },
    );
    Widget continueButton = Mutation(
      options: MutationOptions(
          document: gql(reportNetop)
      ),
      builder:(RunMutation runMutation,
          QueryResult? result,) {
        if (result!.hasException) {
          print(result.exception.toString());
        }
        return ElevatedButton(
          onPressed: () {
            print("reported");
            print(reportController.text);
            runMutation({
              "description": reportController.text,
              "reportNetopNetopId": widget.post.id,
            });
            Navigator.of(context).pop();
            reportController.clear();
          },
          child: Text("report"),
        );
      }
    );

     Widget textField =TextFormField(
      controller: reportController,
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text("reason for reporting"),
      actions: [
        textField,
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  }



