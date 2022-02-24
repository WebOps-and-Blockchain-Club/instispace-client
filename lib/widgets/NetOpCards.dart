import 'package:carousel_slider/carousel_slider.dart';
import 'package:client/models/post.dart';
import 'package:client/widgets/tagButtons.dart';
import 'package:client/widgets/titles.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';

import '../models/tag.dart';
import '../screens/home/networking_and _opportunities/comments.dart';
import '../screens/home/networking_and _opportunities/editpost.dart';

Widget cards (
    BuildContext context,
    String toggleStar,
    String toggleLike,
    var likeCount,
    Future<QueryResult?> Function()? refetch,
    Future<QueryResult?> Function()? refetchPosts,
    bool isStared,
    List<Tag> tags,
    String delete,
    TextEditingController reportController,
    String reportNetop,


    String title,
    String description,
    String? imgUrl,
    String? linkToAction,
    int? like_counter,
    String? endTime,
    String? id,
    String? attachment,
    String? linkName,
    String? userId,
    String? createdId,


String? location,
List<String>? imgURL,
String time,
    bool isLiked,


    NetOpPost? post,
    String cardType,
    String page
    ) {

  String month = '';
  String date = time.split("-").last.split("T").first;
  String year = time.split("-").first;
  if (cardType == 'Event')
    {
      if(time.split("-")[1] == "01") {month = "JAN";}
      if(time.split("-")[1] == "02") {month = "FEB";}
      if(time.split("-")[1] == "03") {month = "MARCH";}
      if(time.split("-")[1] == "04") {month = "APRIL";}
      if(time.split("-")[1] == "05") {month = "MAY";}
      if(time.split("-")[1] == "06") {month = "JUNE";}
      if(time.split("-")[1] == "07") {month = "JULY";}
      if(time.split("-")[1] == "08") {month = "AUG";}
      if(time.split("-")[1] == "09") {month = "SEPT";}
      if(time.split("-")[1] == "10") {month = "OCT";}
      if(time.split("-")[1] == "11") {month = "NOV";}
      if(time.split("-")[1] == "12") {month = "DEC";}

    }
  return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 5.0,
      color: const Color(0xFF808CFF),
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
                          child: SubHeading(title)
                      ),

                      if (cardType == 'Event' || cardType == 'Netop')
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

                            if (cardType == "Netop") {
                              return IconButton(
                                onPressed: () {
                                  runMutation({
                                    "toggleStarNetopId": id
                                  });
                                  refetch!();
                                },
                                icon: isStared
                                    ? const Icon(Icons.star)
                                    : const Icon(Icons.star_border),
                                color: isStared ? Colors.amber : Colors.white,
                              );
                            }
                            else {
                              return IconButton(
                                onPressed: () {
                                  runMutation({
                                    "eventId": id
                                  });
                                  refetch!();
                                },
                                icon: isStared
                                    ? const Icon(Icons.star)
                                    : const Icon(Icons.star_border),
                                color: isStared ? Colors.amber : Colors.white,
                              );
                            }
                          }
                      ),
                    ],
                  ),

                  //Images
                  // if (cardType == 'Netop')
                  if(imgUrl==null)
                    Text(
                      description.length > 250
                          ? description.substring(
                          0, 250) + '...'
                          : description,
                      style: const TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                  // if(cardType == 'Netop')
                  if(imgUrl !=null)
                    SizedBox(
                        width: 400.0,
                        child: Image.network(
                            imgUrl,
                            height: 150.0)
                    ),

                  // if (cardType == 'Announcement' || cardType == 'Event' || cardType == 'L&F')
                  // if(imgURL == null)
                  //                     Text(
                  //                       description.length > 250
                  //                           ? description.substring(
                  //                           0, 250) + '...'
                  //                           : description,
                  //                       style: const TextStyle(
                  //                         fontSize: 15.0,
                  //                       ),
                  //                     ),
                  // if (cardType == 'Announcement' || cardType == 'Event' || cardType == 'L&F')
                  //                   if(imgURL != null)
                  //                     CarouselSlider(
                  //                       items: imgURL.map((item) => Container(
                  //                         child: Center(
                  //                           child: Image.network(item,fit: BoxFit.cover,width: 400,),
                  //                         ),
                  //                       )
                  //                       ).toList(),
                  //                       options: CarouselOptions(
                  //                         enableInfiniteScroll: false,
                  //                       ),
                  //                     ),

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
                                      }, icon: const Icon(Icons.share),
                                        iconSize: 20,
                                        color:const Color(0xFF021096),),
                                    ),
                                  ),
                                  const SizedBox(width: 5,),

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
                                        icon: const Icon(Icons.access_alarm),
                                        iconSize: 20,
                                        color: const Color(0xFF021096),),
                                    ),
                                  ),
                                  const SizedBox(width: 5,),

                                  if (cardType == 'Netop')
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
                                                            post!,)),
                                              ),
                                              print('commented'),
                                            }, icon: const Icon(Icons.comment),
                                              iconSize: 20,
                                              color: const Color(0xFF021096),),
                                          ),
                                        );
                                      }
                                  ),
                                  const SizedBox(width: 5,),

                                  if (cardType == 'Netop')
                                  Row(
                                    children: [
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
                                                  icon: const Icon(Icons.thumb_up),
                                                  iconSize: 20,
                                                  color: const Color(0xFF021096),
                                                ),
                                              ),
                                            );
                                          }
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 10.0),
                                        child: Text(
                                          "$likeCount likes",
                                          style: const TextStyle(
                                            color: Color(0xFFFFFFFF),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  if (cardType == "Event")
                                    Row(
                                      children: [
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
                                                height: MediaQuery.of(context).size.height*0.05,
                                                width: MediaQuery.of(context).size.width*0.1,
                                                child: Center(
                                                  child: IconButton(
                                                    onPressed: ()
                                                    {
                                                      runMutation({
                                                        "eventId": id
                                                      });
                                                      refetch!();
                                                      print('is liked');
                                                    },
                                                    icon: const Icon(Icons.thumb_up),
                                                    iconSize: 20,
                                                    color: isLiked? Colors.blue:Colors.grey,
                                                  ),
                                                ),
                                              );
                                            }
                                        ),
                                        //Like Count
                                        Container(
                                          margin: const EdgeInsets.only(left: 10.0),
                                          child: Text(
                                            "$likeCount likes",
                                            style: const TextStyle(
                                              color: Color(0xFFFFFFFF),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )

                                ],
                              ),
                            ),

                            // Button Row
                            if (page == 'postListing')
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
                                                builder: (BuildContext context)=> EditPost(post: post!,refetchPosts: refetchPosts,)));
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
                                                  "eventId": id
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
                                      return showAlertDialog(context,reportController,reportNetop,post!);
                                    },
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        if (page == 'eventsListing')
                          Container(
                            height: MediaQuery.of(context).size.height*0.15,
                            width: MediaQuery.of(context).size.width*.25,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD3D8FF),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Text(
                                      location!,
                                      style: const TextStyle(
                                        color: Color(0xFF808CFF),
                                        fontWeight: FontWeight.w900,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 3,),
                                  Center(
                                    child: Text(
                                      "$date $month $year",
                                      style: const TextStyle(
                                        color: Color(0xFF808CFF),
                                        fontWeight: FontWeight.w900,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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

showAlertDialog(BuildContext context,TextEditingController reportController, String reportNetop, NetOpPost post) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("Cancel"),
    onPressed: () {
      Navigator.of(context).pop();
      reportController.clear();
    },
  );
  Widget continueButton = Mutation(
      options: MutationOptions(
          document: gql(reportNetop)
      ),
      builder: (RunMutation runMutation,
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
              "reportNetopNetopId": post.id,
            });
            Navigator.of(context).pop();
            reportController.clear();
          },
          child: Text("report"),
        );
      }
  );

  Widget textField = TextFormField(
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