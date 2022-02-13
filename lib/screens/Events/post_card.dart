import 'package:client/graphQL/events.dart';
import 'package:client/models/tag.dart';
import 'package:client/screens/Events/editEvent.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'post.dart';
import 'singlepost.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final num index;
  final Future<QueryResult?> Function()? refetchPosts;
  PostCard({required this.post,required this.index,required this.refetchPosts});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  String toggleLike = eventsQuery().toggleLike;
  String toggleStar=eventsQuery().toggleStar;
  String deleteEvent=eventsQuery().deleteEvent;
  String getEvent = eventsQuery().getEvent;
  late String createdId;
  late String userId;
  late bool isLiked;
  late bool isStarred;
  String month = '';
  String date = '';
  String year = '';

  @override
  Widget build(BuildContext context) {
    List<Tag>tags = widget.post.tags;
    DateTime dateTime = DateTime.parse(widget.post.time);
    var likeCount;
    return Query(
        options: QueryOptions(
            document: gql(getEvent),
          variables: {"eventId":widget.post.id},
        ),
        builder: (QueryResult result, {fetchMore, refetch}){
          if (result.hasException) {
            print(result.exception.toString());
            return Text(result.exception.toString());
          }
          if(result.isLoading){
            return Card(
                clipBehavior: Clip.antiAlias,
                elevation: 5.0,
                color: Color(0xFF5451FD),
                child: SizedBox(
                  height: 60,
                  width: 20,
                )
            );
          }
          likeCount=result.data!["getEvent"]["likeCount"];
          isLiked=result.data!["getEvent"]["isLiked"];
          isStarred=result.data!["getEvent"]["isStared"];
          createdId=result.data!["getEvent"]["createdBy"]["id"];
          userId=result.data!["getMe"]["id"];
          if(widget.post.time.split("-")[1] == "01") {month = "JAN";}
          if(widget.post.time.split("-")[1] == "02") {month = "FEB";}
          if(widget.post.time.split("-")[1] == "03") {month = "MARCH";}
          if(widget.post.time.split("-")[1] == "04") {month = "APRIL";}
          if(widget.post.time.split("-")[1] == "05") {month = "MAY";}
          if(widget.post.time.split("-")[1] == "06") {month = "JUNE";}
          if(widget.post.time.split("-")[1] == "07") {month = "JULY";}
          if(widget.post.time.split("-")[1] == "08") {month = "AUG";}
          if(widget.post.time.split("-")[1] == "09") {month = "SEPT";}
          if(widget.post.time.split("-")[1] == "10") {month = "OCT";}
          if(widget.post.time.split("-")[1] == "11") {month = "NOV";}
          if(widget.post.time.split("-")[1] == "12") {month = "DEC";}
          date = widget.post.time.split("-").last.split("T").first;
          year = widget.post.time.split("-").first;

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
                      child: SinglePost(post: widget.post,isStarred: isStarred,refetch: refetch,)),
                  collapsed: Card(
                      clipBehavior: Clip.antiAlias,
                      elevation: 5.0,
                      color: Color(0xFF808CFF),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12.0, 0.0, 0, 0),
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
                                      Text(
                                        widget.post.title,
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
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
                                                  "eventId":widget.post.id
                                                });
                                                refetch!();
                                              },
                                              icon: isStarred?Icon(Icons.star):Icon(Icons.star_border),
                                              color: isStarred? Colors.amber:Colors.grey,
                                            );
                                          }
                                      ),
                                    ],
                                  ),
                                  //Images & Alt Text
                                  if(widget.post.imgUrl.isEmpty)
                                    Text(
                                      widget.post.description.length > 250
                                          ? widget.post.description.substring(
                                          0, 250) + '...'
                                          : widget.post.description,
                                      style: TextStyle(
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  if(widget.post.imgUrl.isNotEmpty)
                                    CarouselSlider(
                                      items: widget.post.imgUrl.map((item) => Container(
                                        child: Center(
                                          child: Image.network(item,fit: BoxFit.cover,width: 400,),
                                        ),
                                      )
                                      ).toList(),
                                      options: CarouselOptions(
                                        enableInfiniteScroll: false,
                                      ),
                                    ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  //Row for Tags, Icons, Container
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0.0,0.0,12.0,0.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            //Tags Row
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                                                  child: SizedBox(
                                                    width: 200,
                                                    height: 20,
                                                    child: ListView(
                                                      scrollDirection: Axis.horizontal,
                                                      children: tags.map((tag) =>
                                                          SizedBox(
                                                            child: Padding(
                                                              padding: const EdgeInsets.fromLTRB(2.0, 0.0, 2.0, 0.0),
                                                              child: ElevatedButton(
                                                                  onPressed: () => {},
                                                                  child: Text(
                                                                    tag.Tag_name,
                                                                    style: TextStyle(
                                                                        color: Color(0xFF021096),
                                                                        fontSize: 12.5,
                                                                        fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),
                                                                  style: ElevatedButton.styleFrom(
                                                                      primary: Color(0xFFFFFFFF),
                                                                      padding: EdgeInsets.symmetric(
                                                                          vertical: 2,
                                                                          horizontal: 6),
                                                                  ),
                                                                  ),
                                                            ),
                                                          )).toList(),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            //Icons Row
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(2, 10, 0, 0),
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
                                                      child: IconButton(
                                                        onPressed: () =>
                                                        {
                                                          print(dateTime.toString().split(" ").first),
                                                          print(dateTime.toString().split(" ").last.split(".").first),
                                                          print(widget.post.location),
                                                          print('shared')
                                                        },
                                                        icon: Icon(Icons.share),
                                                        iconSize: 20,
                                                        color: Color(0xFF021096),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 5,),
                                                  //Reminder Icon
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
                                                      child: IconButton(
                                                          onPressed: () =>
                                                          {
                                                            print('remainder added')
                                                          },
                                                          icon: Icon(Icons.access_alarm),
                                                          iconSize: 20,
                                                          color: Color(0xFF021096),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 5,),
                                                  //Like Icon
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
                                                  //Like Count
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
                                            ),],
                                        ),
                                        //Location & Date
                                        Container(
                                          height: 65,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFD3D8FF),
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  widget.post.location,
                                                  style: TextStyle(
                                                    color: Color(0xFF808CFF),
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                SizedBox(height: 3,),
                                                Text(
                                                  "$date $month $year",
                                                  style: TextStyle(
                                                    color: Color(0xFF808CFF),
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  //Edit & Delete buttons
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
                                                fontWeight: FontWeight.w500,
                                              ),),
                                            onPressed: (){
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext context)=> EditPostEvents(post: widget.post,refetchPosts: widget.refetchPosts,)));
                                            },
                                          ),
                                        ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      if(userId==createdId)
                                        Mutation(
                                            options: MutationOptions(
                                                document: gql(deleteEvent)
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
                                    ],
                                  ),
                                ],
                              ),
                            ]
                        ),
                      )
                  ),
                  builder: (_, collapsed, expanded) =>
                      Expandable(
                        collapsed: collapsed, expanded: expanded,)
              ),
            ),
            // ),
          );
          // return Padding(
          //   padding: const EdgeInsets.fromLTRB(5.0,0.0,5.0,5.0),
          //   child: Card(
          //     color: Color(0xFFF9F6F2),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.stretch,
          //       children: [
          //         Image.network(widget.post.imgUrl!,height: 200.0),
          //         SizedBox(
          //           height: 6.0,
          //         ),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Padding(
          //               padding: const EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 5.0),
          //               child: Text(
          //                 widget.post.title,
          //                 style: TextStyle(
          //                   color: Colors.black,
          //                   fontSize: 30.0,
          //                 ),
          //               ),
          //             ),
          //             Row(
          //               children: [
          //                 Mutation(
          //                     options:MutationOptions(
          //                         document: gql(toggleLike)
          //                     ),
          //                     builder: (
          //                         RunMutation runMutation,
          //                         QueryResult? result,
          //                         ){
          //                       if (result!.hasException){
          //                         print(result.exception.toString());
          //                       }
          //                       return IconButton(
          //                         onPressed: (){
          //                           runMutation({
          //                             "eventId":widget.post.id
          //                           });
          //                           refetch!();
          //                           print("isLiked:$isLiked");
          //                         },
          //                         icon: Icon(Icons.thumb_up),
          //                         color: isLiked? Colors.blue:Colors.grey,
          //                       );
          //                     }
          //                 ),
          //                 IconButton(onPressed: () => {}, icon: Icon(Icons.access_alarm)),
          //                 IconButton(onPressed: () => {}, icon: Icon(Icons.share))
          //               ],
          //             )
          //           ],
          //         ),
          //         SizedBox(
          //           height: 6.0,
          //         ),
          //         Padding(
          //           padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
          //           child: Flexible(
          //             child: Text(
          //               widget.post.description,
          //               overflow: TextOverflow.ellipsis,
          //               // trimLines: 2,
          //               // trimMode: TrimMode.Line,
          //               // trimCollapsedText: "Read More",
          //               // trimExpandedText: "Read Less",
          //               style: TextStyle(
          //                 color: Colors.black,
          //                 fontSize: 15.0,
          //               ),
          //             ),
          //           ),
          //         ),
          //         SizedBox(
          //           height: 10.0,
          //         ),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Padding(
          //               padding: const EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 5.0),
          //               child: Text(
          //                 widget.post.location,
          //                 style: TextStyle(
          //                   color: Colors.black,
          //                   fontSize: 15.0,
          //                 ),
          //               ),
          //             ),
          //             SizedBox(
          //               height: 6.0,
          //             ),
          //             Text("24 Dec | 15:00",
          //               style: TextStyle(
          //                 color: Colors.black,
          //                 fontSize: 15.0,
          //               ),),
          //           ],
          //         ),
          //         SizedBox(
          //           height: 10.0,
          //         ),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.start,
          //           children: [
          //             Padding(
          //               padding: const EdgeInsets.fromLTRB(2.0,0.0,0.0,0.0),
          //               child: ElevatedButton(
          //                 onPressed: () {},
          //                 child: Text("Tag 1",
          //                   style: TextStyle(
          //                       color: Colors.white
          //                   ),),
          //               ),
          //             ),
          //             Padding(
          //               padding: const EdgeInsets.fromLTRB(2.0,0.0,0.0,0.0),
          //               child: ElevatedButton(
          //                 onPressed: () {},
          //                 child: Text("Tag 2",
          //                   style: TextStyle(
          //                       color: Colors.white
          //                   ),),
          //               ),
          //             ),
          //             Padding(
          //               padding: const EdgeInsets.fromLTRB(2.0,0.0,0.0,0.0),
          //               child: ElevatedButton(
          //                 onPressed: () {},
          //                 child: Text("Tag 3",
          //                   style: TextStyle(
          //                       color: Colors.white
          //                   ),),
          //               ),
          //             )
          //           ],
          //         ),
          //         ButtonBar(
          //           alignment: MainAxisAlignment.start,
          //           children: [
          //             TextButton(
          //                 onPressed: () => {
          //                   Navigator.push(
          //                     context,
          //                     MaterialPageRoute(builder: (context) => SinglePost(post:widget.post)),
          //                   ),
          //                 },
          //                 child: Text(
          //                   'More Details',
          //                 )
          //             ),
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // );
        }
    );
  }
}