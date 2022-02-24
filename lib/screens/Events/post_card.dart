import 'package:client/graphQL/events.dart';
import 'package:client/models/tag.dart';
import 'package:client/screens/Events/editEvent.dart';
import 'package:client/screens/tagPage.dart';
import 'package:client/widgets/NetOpCards.dart';
import 'package:client/widgets/eventCards.dart';
import 'package:client/widgets/tagButtons.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  TextEditingController reportController = TextEditingController();
  late String createdId;
  late String userId;
  late bool isLiked;
  late bool isStarred;
  String month = '';
  String date = '';
  String year = '';

  @override
  Widget build(BuildContext context) {
    var values = widget.post;
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
            return const Card(
                clipBehavior: Clip.antiAlias,
                elevation: 5.0,
                color: Color(0xFF5451FD),
                child: SizedBox(
                  height: 60,
                  width: 20,
                )
            );
          }
          print("tags: ${widget.post.tags}");
          likeCount=result.data!["getEvent"]["likeCount"];
          isLiked=result.data!["getEvent"]["isLiked"];
          isStarred=result.data!["getEvent"]["isStared"];
          createdId=result.data!["getEvent"]["createdBy"]["id"];
          userId=result.data!["getMe"]["id"];


          return ExpandableNotifier(
            child: ScrollOnExpand(
              child: ExpandablePanel(
                  theme: const ExpandableThemeData(
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

                  collapsed: Padding(
                    padding: const EdgeInsets.fromLTRB(2,2,2,3),
                    // child: Card(
                    //     clipBehavior: Clip.antiAlias,
                    //     elevation: 5.0,
                    //     color: const Color(0xFF808CFF),
                    //     child: SizedBox(
                    //       height: MediaQuery
                    //           .of(context)
                    //           .size
                    //           .height * 0.3,
                    //       width: MediaQuery
                    //           .of(context)
                    //           .size
                    //           .width * 1,
                    //       child: Padding(
                    //         padding: const EdgeInsets.fromLTRB(12.0, 0.0, 0, 0),
                    //         child: Column(
                    //             crossAxisAlignment: CrossAxisAlignment.stretch,
                    //             children: [
                    //               Column(
                    //                 crossAxisAlignment: CrossAxisAlignment.start,
                    //                 children: [
                    //                   //Title & Star
                    //                   Row(
                    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //                     children: [
                    //                       Text(
                    //                         widget.post.title,
                    //                         style: const TextStyle(
                    //                           fontSize: 20,
                    //                           color: Colors.black,
                    //                           fontWeight: FontWeight.w600,
                    //                         ),
                    //                       ),
                    //                       Mutation(
                    //                           options:MutationOptions(
                    //                               document: gql(toggleStar)
                    //                           ),
                    //                           builder: (
                    //                               RunMutation runMutation,
                    //                               QueryResult? result,
                    //                               ){
                    //                             if (result!.hasException){
                    //                               print(result.exception.toString());
                    //                             }
                    //                             return IconButton(
                    //                               onPressed: (){
                    //                                 runMutation({
                    //                                   "eventId":widget.post.id
                    //                                 });
                    //                                 refetch!();
                    //                               },
                    //                               icon: isStarred?const Icon(Icons.star):Icon(Icons.star_border),
                    //                               color: isStarred? Colors.amber:Colors.grey,
                    //                             );
                    //                           }
                    //                       ),
                    //                     ],
                    //                   ),
                    //                   //Images & Alt Text
                    //                   if(widget.post.imgUrl.isEmpty)
                    //                     Text(
                    //                       widget.post.description.length > 250
                    //                           ? widget.post.description.substring(
                    //                           0, 250) + '...'
                    //                           : widget.post.description,
                    //                       style: const TextStyle(
                    //                         fontSize: 15.0,
                    //                       ),
                    //                     ),
                    //                   if(widget.post.imgUrl.isNotEmpty)
                    //                     CarouselSlider(
                    //                       items: widget.post.imgUrl.map((item) => Container(
                    //                         child: Center(
                    //                           child: Image.network(item,fit: BoxFit.cover,width: 400,),
                    //                         ),
                    //                       )
                    //                       ).toList(),
                    //                       options: CarouselOptions(
                    //                         enableInfiniteScroll: false,
                    //                       ),
                    //                     ),
                    //                   const SizedBox(
                    //                     height: 10,
                    //                   ),
                    //                   //Row for Tags, Icons, Container
                    //                   Padding(
                    //                     padding: const EdgeInsets.fromLTRB(0.0,0.0,12.0,0.0),
                    //                     child: Row(
                    //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //                       children: [
                    //                         Column(
                    //                           crossAxisAlignment: CrossAxisAlignment.start,
                    //                           children: [
                    //                             //Tags Row
                    //                             Row(
                    //                               children: [
                    //                                 Padding(
                    //                                   padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                    //                                   child: SizedBox(
                    //                                     width: MediaQuery.of(context).size.width*0.5,
                    //                                     height: 20,
                    //                                     child: ListView(
                    //                                       scrollDirection: Axis.horizontal,
                    //                                       children: tags.map((tag) =>
                    //                                           SizedBox(
                    //                                             child: Padding(
                    //                                               padding: const EdgeInsets.fromLTRB(2.0, 0.0, 2.0, 0.0),
                    //                                               child: TagButtons(tag, context)
                    //                                             ),
                    //                                           )).toList(),
                    //                                     ),
                    //                                   ),
                    //                                 ),
                    //                               ],
                    //                             ),
                    //                             //Icons Row
                    //                             Padding(
                    //                               padding: const EdgeInsets.fromLTRB(2, 10, 0, 0),
                    //                               child: Row(
                    //                                 children: [
                    //                                   //Share Icon
                    //                                   Ink(
                    //                                     decoration: const ShapeDecoration(
                    //                                       color: Color(0xFFFFFFFF),
                    //                                       shape: CircleBorder(
                    //                                           side: BorderSide.none,
                    //                                           )
                    //                                       ),
                    //                                     height: MediaQuery.of(context).size.height*0.05,
                    //                                     width: MediaQuery.of(context).size.width*0.1,
                    //                                     child: Center(
                    //                                       child: IconButton(
                    //                                         onPressed: () =>
                    //                                         {
                    //                                           print(dateTime.toString().split(" ").first),
                    //                                           print(dateTime.toString().split(" ").last.split(".").first),
                    //                                           print(widget.post.location),
                    //                                           print('shared')
                    //                                         },
                    //                                         icon: const Icon(Icons.share),
                    //                                         iconSize: 20,
                    //                                         color: const Color(0xFF021096),
                    //                                       ),
                    //                                     ),
                    //                                   ),
                    //                                   const SizedBox(width: 5,),
                    //                                   //Reminder Icon
                    //                                   Ink(
                    //                                     decoration: const ShapeDecoration(
                    //                                         color: Colors.white,
                    //                                         shape: CircleBorder(
                    //                                           side: BorderSide.none,
                    //                                         )
                    //                                     ),
                    //                                     height: MediaQuery.of(context).size.height*0.05,
                    //                                     width: MediaQuery.of(context).size.width*0.1,
                    //                                     child: Center(
                    //                                       child: IconButton(
                    //                                           onPressed: () =>
                    //                                           {
                    //                                             print('remainder added')
                    //                                           },
                    //                                           icon: const Icon(Icons.access_alarm),
                    //                                           iconSize: 20,
                    //                                           color: const Color(0xFF021096),
                    //                                       ),
                    //                                     ),
                    //                                   ),
                    //                                   const SizedBox(width: 5,),
                    //                                   //Like Icon
                    //                                   Mutation(
                    //                                       options:MutationOptions(
                    //                                           document: gql(toggleLike)
                    //                                       ),
                    //                                       builder: (
                    //                                           RunMutation runMutation,
                    //                                           QueryResult? result,
                    //                                           ){
                    //                                         if (result!.hasException){
                    //                                           print(result.exception.toString());
                    //                                         }
                    //                                         return Ink(
                    //                                           decoration: const ShapeDecoration(
                    //                                               color: Color(0xFFFFFFFF),
                    //                                               shape: CircleBorder(
                    //                                                 side: BorderSide.none,
                    //                                               )
                    //                                           ),
                    //                                           height: MediaQuery.of(context).size.height*0.05,
                    //                                           width: MediaQuery.of(context).size.width*0.1,
                    //                                           child: Center(
                    //                                             child: IconButton(
                    //                                               onPressed: ()
                    //                                               {
                    //                                               runMutation({
                    //                                               "eventId":widget.post.id
                    //                                               });
                    //                                                 refetch!();
                    //                                                 print('is liked');
                    //                                               },
                    //                                               icon: const Icon(Icons.thumb_up),
                    //                                               iconSize: 20,
                    //                                               color: isLiked? Colors.blue:Colors.grey,
                    //                                             ),
                    //                                           ),
                    //                                         );
                    //                                       }
                    //                                   ),
                    //                                   //Like Count
                    //                                   Container(
                    //                                     margin: const EdgeInsets.only(left: 10.0),
                    //                                     child: Text(
                    //                                       "$likeCount likes",
                    //                                       style: const TextStyle(
                    //                                         color: Color(0xFFFFFFFF),
                    //                                         fontWeight: FontWeight.bold,
                    //                                         fontSize: 16.0,
                    //                                       ),
                    //                                     ),
                    //                                   ),
                    //                                 ],
                    //                               ),
                    //                             ),],
                    //                         ),
                    //                         //Location & Date
                    //                         Container(
                    //                           height: MediaQuery.of(context).size.height*0.15,
                    //                           width: MediaQuery.of(context).size.width*.25,
                    //                           decoration: BoxDecoration(
                    //                             color: const Color(0xFFD3D8FF),
                    //                             borderRadius: BorderRadius.circular(10.0),
                    //                           ),
                    //                           child: Center(
                    //                             child: Column(
                    //                               mainAxisAlignment: MainAxisAlignment.center,
                    //                               crossAxisAlignment: CrossAxisAlignment.center,
                    //                               children: [
                    //                                 Center(
                    //                                   child: Text(
                    //                                     widget.post.location,
                    //                                     style: const TextStyle(
                    //                                       color: Color(0xFF808CFF),
                    //                                       fontWeight: FontWeight.w900,
                    //                                       fontSize: 14,
                    //                                     ),
                    //                                   ),
                    //                                 ),
                    //                                 const SizedBox(height: 3,),
                    //                                 Center(
                    //                                   child: Text(
                    //                                     "$date $month $year",
                    //                                     style: const TextStyle(
                    //                                       color: Color(0xFF808CFF),
                    //                                       fontWeight: FontWeight.w900,
                    //                                       fontSize: 14,
                    //                                     ),
                    //                                   ),
                    //                                 ),
                    //                               ],
                    //                             ),
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                   //Edit & Delete buttons
                    //                   Row(
                    //                     children: [
                    //                       if(userId==createdId)
                    //                         SizedBox(
                    //                           width: 60,
                    //                           child: ElevatedButton(
                    //                             style: ElevatedButton.styleFrom(
                    //                               primary: const Color(0xFF021096),
                    //                               padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    //                               minimumSize: const Size(35,25),
                    //                             ),
                    //                             child: const Text('Edit',
                    //                               style: TextStyle(
                    //                                 color: Colors.white,
                    //                                 fontSize: 14,
                    //                                 fontWeight: FontWeight.w500,
                    //                               ),),
                    //                             onPressed: (){
                    //                               Navigator.of(context).push(
                    //                                   MaterialPageRoute(
                    //                                       builder: (BuildContext context)=> EditPostEvents(post: widget.post,refetchPosts: widget.refetchPosts,)));
                    //                             },
                    //                           ),
                    //                         ),
                    //                       const SizedBox(
                    //                         width: 8,
                    //                       ),
                    //                       if(userId==createdId)
                    //                         Mutation(
                    //                             options: MutationOptions(
                    //                                 document: gql(deleteEvent)
                    //                             ),
                    //                             builder:(
                    //                                 RunMutation runMutation,
                    //                                 QueryResult? result,
                    //                                 ){
                    //                               if (result!.hasException){
                    //                                 print(result.exception.toString());
                    //                               }
                    //                               if(result.isLoading){
                    //                                 return const CircularProgressIndicator();
                    //                               }
                    //                               return SizedBox(
                    //                                 width: 65,
                    //                                 child: ElevatedButton(
                    //                                     style: ElevatedButton.styleFrom(
                    //                                       primary: const Color(0xFF021096),
                    //                                       padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    //                                       minimumSize: const Size(35,25),
                    //                                     ),
                    //                                     onPressed: (){
                    //                                       runMutation({
                    //                                         "eventId":widget.post.id
                    //                                       });
                    //                                     },
                    //                                     child: const Text('Delete',
                    //                                       style: TextStyle(
                    //                                         color: Colors.white,
                    //                                         fontSize: 14,
                    //                                         fontWeight: FontWeight.w500,
                    //                                       ),)
                    //                                 ),
                    //                               );
                    //                             }
                    //                         ),
                    //                     ],
                    //                   ),
                    //                 ],
                    //               ),
                    //             ]
                    //         ),
                    //       ),
                    //     )
                    // ),
                    // child: cards(context, toggleStar, toggleLike, likeCount, refetch, widget.refetchPosts, isStarred, tags, deleteEvent, reportController, '', values.title, values.description, null, values.linkToAction, values.likeCount, null, values.id,null, values.linkName, userId, createdId, values.location, values.imgUrl, values.time, isLiked, null, "Event", "eventsListing"),
                  child: EventsCard(context, refetch, widget.refetchPosts, tags, widget.post, userId, createdId, 'eventsSection'),
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