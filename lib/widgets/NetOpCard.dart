import 'package:client/graphQL/netops.dart';
import 'package:client/models/netopsClass.dart';
import 'package:client/models/tag.dart';
import 'package:client/widgets/expandDescription.dart';
import 'package:client/widgets/tagButtons.dart';
import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screens/home/Netops/netopsComments.dart';
import '../screens/home/Netops/editNetops.dart';
import 'package:client/widgets/marquee.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'addToCal.dart';
import 'package:share_plus/share_plus.dart';

Widget NetopsCard (

    ///Variables
    BuildContext context,
    Future<QueryResult?> Function()? refetch,
    bool isStarred,
    bool isLiked,
    int like_counter,
    DateTime createdTime,
    List<Tag> tags,
    String userId,
    String createdId,
    TextEditingController reportController,
    NetOpPost post,
    String page,
    ) {

  ///GraphQL
  String toggleStar = netopsQuery().toggleStar;
  String toggleLike = netopsQuery().toggleLike;
  String delete = netopsQuery().deleteNetop;
  String reportNetop = netopsQuery().reportNetop;

  ///Called Function difference
  String timeDifference = difference(createdTime);


  return  Card(
    clipBehavior: Clip.antiAlias,
    elevation: 4.0,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.5)
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [

        ///Title,Edit,Delete,Star Buttons Row
        Container(
          color: Color(0xFF42454D),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15,0,0,0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                ///Title
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: SizedBox(
                    width: (userId==createdId)
                        ? MediaQuery.of(context).size.width*0.4
                        : MediaQuery.of(context).size.width*0.68,
                    child: MarqueeWidget(
                      direction: Axis.horizontal,
                      child: Text(
                        capitalize(post.title),
                        style: TextStyle(
                          //Conditional Font Size
                          fontWeight: (userId==createdId)
                              ? FontWeight.w700
                              : FontWeight.bold,
                          //Conditional Font Size
                          fontSize: (userId==createdId)
                              ? 18
                              : 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                /// Edit, Delete, Star Buttons Row
                Row(
                  children: [

                    ///Edit Button
                    if(userId==createdId)
                      IconButton(
                        onPressed: (){
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (BuildContext context) => EditPost(post: post,refetchNetops: refetch)
                              )
                          );
                        },
                        icon: const Icon(Icons.edit_outlined),
                        color: Colors.white,
                      ),

                    ///Delete Button
                    if(userId==createdId)
                      Mutation(
                          options: MutationOptions(
                              document: gql(delete),
                              onCompleted: (result) {
                                print('result: $result[deleteNetop]');
                                refetch!();
                              }
                          ),
                          builder:(
                              RunMutation runMutation,
                              QueryResult? result,
                              ){
                            if (result!.hasException){
                              print(result.exception.toString());
                            }
                            if(result.isLoading){
                              return Center(
                                  child: LoadingAnimationWidget.threeRotatingDots(
                                    color: Colors.white,
                                    size: 20,
                                  ));
                            }
                            return IconButton(
                              onPressed: (){
                                runMutation({
                                  "netopId": post.id
                                });
                              },
                              icon: const Icon(Icons.delete_outline),
                              color: Colors.white,
                            );
                          }
                      ),

                    ///Star Button
                    Mutation(
                        options:MutationOptions(
                          document: gql(toggleStar),
                          onCompleted: (result) {
                            // print(result);
                            if(result["toggleStar"]){

                            }
                          },
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
                                "netopId" : post.id
                              });
                              isStarred = !isStarred;
                            },
                            icon: isStarred? const Icon(Icons.star): const Icon(Icons.star_border),
                            color: isStarred? Colors.white:Colors.white,
                          );
                        }
                    ),
                  ],
                )
              ],
            ),
          ),
        ),

        ///Image
        if(post.imgUrl != null)
          Padding(
            padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: Container(
              width: MediaQuery.of(context).size.width*0.6,
              child: Center(
                child: Image.network(post.imgUrl!,fit: BoxFit.contain,width: 400,),
              ),
            ),
          ),

        ///Description
        Padding(
          padding: const EdgeInsets.fromLTRB(18,15,18,0),
          child: DescriptionTextWidget(text: post.description),
        ),

        ///Tags Row
        if(tags.isNotEmpty)
          Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 8, 0),
            child: Wrap(
              children: tags.map((tag) =>
                  SizedBox(
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(0,0,2,0),
                        child: TagButtons(tag, context)
                    ),
                  )).toList(),
            ),
          ),

        ///Attachments Wrap
        if(post.attachment != null && post.attachment != '')
          Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 8, 0),
            child: Row(
              children: [
                Icon(Icons.attachment),
                Wrap(
                  children: tags.map((tag) =>
                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.5,
                        height: 20,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(2.0, 0.0, 2.0, 0.0),
                          child: ElevatedButton(
                            onPressed: () => {
                              launch('${post.attachment}')
                            },
                            child: Padding(
                              padding: EdgeInsets.all(3),
                              child: Text(
                                post.attachment!.split("/").last,
                                style: const TextStyle(
                                  color: Color(0xFF2B2E35),
                                  fontSize: 12.5, fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              // primary: const Color(0xFFDFDFDF),
                              primary: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              // side: BorderSide(color: Color(0xFF2B2E35)),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: 6),
                            ),
                          ),
                        ),
                      )).toList(),
                ),
              ],
            ),
          ),

        ///Call to Action Button
        if(post.linkName != null && post.linkToAction != null && post.linkToAction != '' && post.linkName != '')
          Padding(
            padding: const EdgeInsets.fromLTRB(15,10,15,0),
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width*0.9,
                height: 24,
                child: ElevatedButton(
                  onPressed: () {
                    launch('${post.linkToAction}');
                  },
                  child: Text(
                    post.linkName!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF42454D),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)
                    ),
                  ),
                ),
              ),
            ),
          ),

        ///Posted by
        Padding(
          padding: const EdgeInsets.fromLTRB(18,10,18,0),
          child: Text(
            'Posted by Anshul, $timeDifference',
            // ${post.createdByName}
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 10.0,
            ),
          ),
        ),

        ///Share, Set Reminder, Like, Comment, Report Buttons Row
        Padding(
          padding: const EdgeInsets.fromLTRB(10,0,10,10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ///Share Icon
              Ink(
                decoration: const ShapeDecoration(
                    color: Color(0xFFFFFFFF),
                    shape: CircleBorder(
                      side: BorderSide.none,
                    )
                ),
                height: MediaQuery.of(context).size.height*0.05,
                width: MediaQuery.of(context).size.width*0.1,
                child: Center(
                  child: IconButton(
                    onPressed: ()
                   async {
                     // bool isLoading =true;
                      // if(post.imgUrl != null){
                        // var res;
                        // final uri = Uri.parse(post.imgUrl!);
                        // await http.get(uri).then((value) {
                        //   if(isLoading){
                        //      CircularProgressIndicator();
                        //   }
                        //   res = value;
                        // }).whenComplete((){
                        //   isLoading = false;
                        // });
                        // print("http over");
                        // final bytes = res.bodyBytes;
                        // print("bytes : $bytes");
                        // final temp = await getTemporaryDirectory();
                        // print("temp over");
                        // final path = '${temp.path}/image.jpg';
                        // File(path).writeAsBytesSync(bytes);
                        // await Share.shareFiles([path],text: "${post.title} \n${post.description}");
                      // }
                      // else{
                        await Share.share("${post.title} \n${post.description}");
                      // }
                      print('shared');
                    },
                    icon: const Icon(Icons.share),
                    iconSize: 20,
                    color: Colors.grey,
                    // color: const Color(0xFF021096),
                  ),
                ),
              ),

              /// Set Reminder
              Ink(
                decoration: const ShapeDecoration(
                    color: Colors.white,
                    shape: CircleBorder(
                      side: BorderSide.none,
                    )
                ),
                height: MediaQuery.of(context).size.height*0.05,
                width: MediaQuery.of(context).size.width*0.1,
                child: Center(
                  child: IconButton(
                    onPressed: () =>
                    {
                    Add2Calendar.addEvent2Cal(
                    buildEvent(title: post.title, startDate: DateTime.now(), description: post.description, endDate: DateTime.parse(post.endTime), location: ""),
                    ),
                      print('remainder added')
                    },
                    icon: const Icon(Icons.access_alarm),
                    iconSize: 20,
                    color:Colors.grey,
                    // color: const Color(0xFF021096),
                  ),
                ),
              ),

              /// Like Button and Like Count
              Row(
                children: [
                  ///Like Icon
                  Mutation(
                      options:MutationOptions(
                          document: gql(toggleLike),
                          onCompleted: (result){
                            // print(result);
                            if(result['toggleLikeNetop']){
                              // refetch!();
                            }
                          }
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
                              color: Color(0xFFFFFF),
                              shape: CircleBorder(
                                side: BorderSide.none,
                              )
                          ),
                          height: MediaQuery.of(context).size.height*0.05,
                          width: MediaQuery.of(context).size.width*0.1,
                          child: Center(
                            child: IconButton(
                              onPressed: ()
                              {
                                runMutation({
                                  "netopId": post.id
                                });
                                isLiked = !isLiked;
                                if(isLiked){
                                  like_counter = like_counter+1;
                                }
                                else{
                                  like_counter = like_counter-1;
                                }
                                // print('is liked: ${isLiked}');
                              },
                              icon: const Icon(Icons.thumb_up),
                              iconSize: 20,
                              color: isLiked? const Color(0xFF42454D):Colors.grey,
                            ),
                          ),
                        );
                      }
                  ),

                  ///Like Count
                  Text(
                    "$like_counter",
                    style: const TextStyle(
                      color: Color(0xFF42454D),
                      fontWeight: FontWeight.w400,
                      fontSize: 10.0,
                    ),
                  ),
                ],
              ),

              ///Comment Button
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
                    if (result.isLoading) {
                      return Center(
                          child: LoadingAnimationWidget.threeRotatingDots(
                            color: Colors.white,
                            size: 20,
                          ));
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
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }
              ),

              ///Report Button
              Padding(
                padding: const EdgeInsets.fromLTRB(0,0,14,0),
                child: Ink(
                  decoration: const ShapeDecoration(
                      color: Colors.white,
                      shape: CircleBorder(
                        side: BorderSide.none,
                      )
                  ),
                  height: MediaQuery.of(context).size.height*0.05,
                  width: MediaQuery.of(context).size.width*0.1,
                  child: Center(
                    child: IconButton(
                      onPressed: () =>
                      {
                        showAlertDialog(context,reportController,reportNetop,post.id)
                      },
                      icon: const Icon(Icons.report),
                      iconSize: 20,
                      color:Colors.grey,
                      // color: const Color(0xFF021096),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}

showAlertDialog(BuildContext context,TextEditingController reportController,String reportNetop, String id) {

  // set up the buttons
  Widget cancelButton = ElevatedButton(
      onPressed:  () {
        Navigator.of(context).pop();
        reportController.clear();
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15,5,15,5),
        child: Text(
            "Cancel",
            style: TextStyle(
                color: Colors.white,
                fontSize: 15
            )
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: const Color(0xFF2B2E35),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        minimumSize: Size(50, 35),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)
        ),
      ));
  Widget continueButton = Mutation(
      options: MutationOptions(
          document: gql(reportNetop),
          onCompleted: (dynamic result) {
            print("result: ${result['reportNetop']}");
          }
      ),
      builder:(RunMutation runMutation,
          QueryResult? result,) {
        if (result!.hasException) {
          print(result.exception.toString());
        }
        if (result.isLoading) {
          return Center(
              child: LoadingAnimationWidget.threeRotatingDots(
                color: Colors.white,
                size: 20,
              ));
        }
        return ElevatedButton(
            onPressed: () {
              print("reported");
              print(reportController.text);
              runMutation({
                "description": reportController.text,
                "netopId": id,
              });
              Navigator.of(context).pop();
              reportController.clear();
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15,5,15,5),
              child: Text(
                "Report",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: const Color(0xFF2B2E35),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              minimumSize: Size(50, 35),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)
              ),
            )
        );
      }
  );

  Widget textField = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children : [
        const Padding(
          padding: EdgeInsets.fromLTRB(15,10,0,0),
          child: Text(
            "Report",
            style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w700
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
          child: Text(
            "Reason for reporting",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
          child: Container(
            width: 200,
            height: 150,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.5),
                border: Border.all(color: Colors.grey,width: 1)
            ),
            child: TextFormField(
              decoration: InputDecoration(
                  border: InputBorder.none
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: reportController,
            ),
          ),
        )
      ]
  );

  /// set up the AlertDialog
  AlertDialog alert = AlertDialog(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.5)
    ),
    actions: [
      textField,
      Padding(
        padding: const EdgeInsets.fromLTRB(0,0,0,10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            cancelButton,
            continueButton,
          ],
        ),
      )
    ],
  );

  /// show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

///function to calculate difference in time
String difference (DateTime postCreated) {
  DateTime now = DateTime.now();
  var difference = now.difference(postCreated).inHours;
  var format = 'hours';

  if(difference > 24){
    difference = now.difference(postCreated).inDays;
    format = 'days';
  }
  return "$difference $format ago";
}

///function to capitalize the first letter of the Title
String capitalize(String s) {
  if(s!="") {
    return s[0].toUpperCase() + s.substring(1);
  } else{
    return s;
  }
}
