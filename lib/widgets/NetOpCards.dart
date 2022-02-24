import 'package:client/graphQL/netops.dart';
import 'package:client/models/post.dart';
import 'package:client/models/tag.dart';
import 'package:client/screens/home/Announcements/expand_description.dart';
import 'package:client/widgets/tagButtons.dart';
import 'package:client/widgets/titles.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';

import '../screens/home/networking_and _opportunities/comments.dart';
import '../screens/home/networking_and _opportunities/editpost.dart';

Widget NetopsCard (
    BuildContext context,
    Future<QueryResult?> Function()? refetch,
    Future<QueryResult?> Function()? refetchPosts,
    bool isStarred,
    List<Tag> tags,
    String userId,
    String createdId,
    TextEditingController reportController,
    NetOpPost post,
    String page,
    ) {
  String toggleStar = netopsQuery().toggleStar;
  String toggleLike = netopsQuery().toggleLike;
  String delete = netopsQuery().deleteNetop;
  String reportNetop = netopsQuery().reportNetop;
  return  Card(
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
                            child: SubHeading(post.title)
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
                                      "toggleStarNetopId":post.id
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
                      if(post.imgUrl==null)
                        DescriptionTextWidget(text: post.description),
                        // Text(
                        //   post.description.length > 250
                        //       ? post.description.substring(
                        //       0, 250) + '...'
                        //       : post.description,
                        //   style: TextStyle(
                        //     fontSize: 15.0,
                        //   ),
                        // ),
                      if(post.imgUrl !=null)
                        SizedBox(
                            width: 400.0,
                            child: Image.network(
                                post.imgUrl!,
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
                                              child: TagButtons(tag, context)
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
                                                            Comments(post:
                                                                post,)),
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
                                          "${post.like_counter} likes",
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
                                if (page == 'NetopsSection')
                                Row(
                                  children: [
                                    if(userId == createdId)
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
                                                    builder: (BuildContext context)=> EditPost(post: post,refetchPosts: refetchPosts,)));
                                          },
                                        ),
                                      ),
                                    SizedBox(width: 8,),

                                    if(userId==createdId)
                                      Mutation(
                                          options: MutationOptions(
                                              document: gql(delete)
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
                                                      "eventId":post.id
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
                                          return showAlertDialog(context,reportController,reportNetop,post.id);
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
      );
}

showAlertDialog(BuildContext context,TextEditingController reportController,String reportNetop, String id) {

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
            "reportNetopNetopId": id,
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