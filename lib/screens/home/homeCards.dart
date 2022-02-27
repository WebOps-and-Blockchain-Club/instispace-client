import 'package:carousel_slider/carousel_slider.dart';
import 'package:client/graphQL/events.dart';
import 'package:client/graphQL/home.dart';
import 'package:client/graphQL/hostelProfile.dart';
import 'package:client/graphQL/hostelProfile.dart';
import 'package:client/graphQL/netops.dart';
import 'package:client/models/post.dart';
import 'package:client/models/tag.dart';
import 'package:client/screens/Events/post.dart';
import 'package:client/screens/home/Announcements/Announcement.dart';
import 'package:client/screens/home/Announcements/AnnouncementCard.dart';
import 'package:client/screens/home/Announcements/SingleAnnouncement.dart';
import 'package:client/screens/tagPage.dart';
import 'package:client/widgets/NetOpCards.dart';
import 'package:client/widgets/tagButtons.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../graphQL/auth.dart';
import '../../graphQL/hostelProfile.dart';
import '../../widgets/announcementCard.dart';
import '../../widgets/eventCards.dart';
import '../../widgets/titles.dart';
import '../Events/singlepost.dart';
import 'Announcements/expand_description.dart';
import 'networking_and _opportunities/comments.dart';
import 'networking_and _opportunities/singlepost.dart';
import 'package:url_launcher/url_launcher.dart';



class EventsHomeCard extends StatefulWidget {
  final Post events;
  EventsHomeCard({required this.events});
  @override
  _EventsHomeCardState createState() => _EventsHomeCardState();
}

class _EventsHomeCardState extends State<EventsHomeCard> {

  String getEvent = eventsQuery().getEvent;
  String toggleLike = eventsQuery().toggleLike;
  String toggleStarEvent = eventsQuery().toggleStar;
   late bool isStared;
  late bool isLiked;
  late String userId;
   String month = '';
  String date = '';
  String year = '';


  @override
  Widget build(BuildContext context) {
    var likeCount;
    List<Tag>tags = widget.events.tags;
    DateTime dateTime = DateTime.parse(widget.events.time);
    TextEditingController noUse = TextEditingController();
    return Query(
        options: QueryOptions(
        document: gql(getEvent),
          variables: {"eventId" : widget.events.id}
    ),
    builder:(QueryResult result, {fetchMore, refetch}) {
      if (result.hasException) {
        print(result.exception.toString());
        return Text(result.exception.toString());
      }
      if (result.isLoading) {
        return const Card(
            clipBehavior: Clip.antiAlias,
            elevation: 5.0,
            color: Color(0xFFF9F6F2),
            child: SizedBox(
              height: 60,
              width: 20,
            )
        );
      }
      isStared = result.data!["getEvent"]["isStared"];
      likeCount=result.data!["getEvent"]["likeCount"];
      isLiked=result.data!["getEvent"]["isLiked"];
      userId = result.data!["getMe"]["id"];
      if(widget.events.time.split("-")[1] == "01") {month = "JAN";}
      if(widget.events.time.split("-")[1] == "02") {month = "FEB";}
      if(widget.events.time.split("-")[1] == "03") {month = "MARCH";}
      if(widget.events.time.split("-")[1] == "04") {month = "APRIL";}
      if(widget.events.time.split("-")[1] == "05") {month = "MAY";}
      if(widget.events.time.split("-")[1] == "06") {month = "JUNE";}
      if(widget.events.time.split("-")[1] == "07") {month = "JULY";}
      if(widget.events.time.split("-")[1] == "08") {month = "AUG";}
      if(widget.events.time.split("-")[1] == "09") {month = "SEPT";}
      if(widget.events.time.split("-")[1] == "10") {month = "OCT";}
      if(widget.events.time.split("-")[1] == "11") {month = "NOV";}
      if(widget.events.time.split("-")[1] == "12") {month = "DEC";}

      var values = widget.events;

      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
        child: ExpandableNotifier(
          child: ScrollOnExpand(
            child: ExpandablePanel(
                theme: const ExpandableThemeData(
                  tapBodyToCollapse: true,
                  tapBodyToExpand: true,
                ),
                expanded: SizedBox(
                    height: MediaQuery.of(context).size.height * 1,
                    width: MediaQuery.of(context).size.width * 1,
                    child: SinglePost(post: widget.events,isStarred: isStared,refetch: refetch,)),
                collapsed: Padding(
                  padding: const EdgeInsets.fromLTRB(2,2,2,3),
      //             child: Card(
      //                 clipBehavior: Clip.antiAlias,
      //                 elevation: 5.0,
      //                 color: const Color(0xFF808CFF),
      //                 child: SizedBox(
      //                   height: MediaQuery.of(context).size.height * 0.3,
      //                   width: MediaQuery.of(context).size.width * 1,
      //                   child: Padding(
      //                     padding: const EdgeInsets.fromLTRB(12.0, 0.0, 0, 0),
      //                     child: Column(
      //                         crossAxisAlignment: CrossAxisAlignment.stretch,
      //                         children: [
      //                           Column(
      //                             crossAxisAlignment: CrossAxisAlignment.start,
      //                             children: [
      //                               //Title & Star
      //                             Row(
      //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                               children: [
      //                                 SubHeading(widget.events.title),
      //                                 Mutation(
      //                                     options:MutationOptions(
      //                                         document: gql(toggleStarEvent)
      //                                     ),
      //                                     builder: (
      //                                         RunMutation runMutation,
      //                                         QueryResult? result,
      //                                         ) {
      //                                       if (result!.hasException){
      //                                         print(result.exception.toString());
      //                                       }
      //                                       return IconButton(
      //                                         onPressed: (){
      //                                           runMutation({
      //                                             "eventId":widget.events.id
      //                                           });
      //                                           refetch!();
      //                                           },
      //                                         icon: isStared?const Icon(Icons.star): const Icon(Icons.star_border),
      //                                         color: isStared? Colors.amber:Colors.grey,
      //                                       );
      //                                     }
      //                                     ),
      //                               ],
      //                             ),
      //                               //Images & Alt Text
      //                               if(widget.events.imgUrl.isEmpty)
      //                                 Text(
      //                                   widget.events.description.length > 250
      //                                       ? widget.events.description.substring(
      //                                       0, 250) + '...'
      //                                       : widget.events.description,
      //                                   style: const TextStyle(
      //                                     fontSize: 15.0,
      //                                   ),
      //                                 ),
      //                               if(widget.events.imgUrl.isNotEmpty)
      //                                 CarouselSlider(
      //                                   items: widget.events.imgUrl.map((item) => Container(
      //                                     child: Center(
      //                                       child: Image.network(item,fit: BoxFit.cover,width: 400,),
      //                                     ),
      //                                   )
      //                                   ).toList(),
      //                                   options: CarouselOptions(
      //                                     enableInfiniteScroll: false,
      //                                   ),
      //                                 ),
      //                               const SizedBox(
      //                                 height: 10,
      //                               ),
      //                               //Row for Tags, Icons, Container
      //                               Padding(
      //                                 padding: const EdgeInsets.fromLTRB(0.0,0.0,12.0,0.0),
      //                                 child: Row(
      //                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                                   children: [
      //                                     Column(
      //                                       crossAxisAlignment: CrossAxisAlignment.start,
      //                                       children: [
      //                                         //Tags Row
      //                                         Row(
      //                                           children: [
      //                                             Padding(
      //                                               padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
      //                                               child: SizedBox(
      //                                                 width: MediaQuery.of(context).size.width*0.5,
      //                                                 height: 20,
      //                                                 child: ListView(
      //                                                   scrollDirection: Axis.horizontal,
      //                                                   children: tags.map((tag) =>
      //                                                       SizedBox(
      //                                                         child: Padding(
      //                                                           padding: const EdgeInsets.fromLTRB(2.0, 0.0, 2.0, 0.0),
      //                                                           child: TagButtons(tag, context)
      //                                                         ),
      //                                                       )).toList(),
      //                                                 ),
      //                                               ),
      //                                             ),
      //                                           ],
      //                                         ),
      //                                         //Icons Row
      //                                         Padding(
      //                                           padding: const EdgeInsets.fromLTRB(2, 10, 0, 0),
      //                                           child: Row(
      //                                             children: [
      //                                               //Share Icon
      //                                               Ink(
      //                                                 decoration: const ShapeDecoration(
      //                                                     color: Color(0xFFFFFFFF),
      //                                                     shape: CircleBorder(
      //                                                       side: BorderSide.none,
      //                                                     )
      //                                                 ),
      //                                                 height: MediaQuery.of(context).size.height*0.05,
      //                                                 width: MediaQuery.of(context).size.width*0.1,
      //                                                 child: Center(
      //                                                   child: IconButton(
      //                                                     onPressed: () =>
      //                                                     {
      //                                                       print(dateTime.toString().split(" ").first),
      //                                                       print(dateTime.toString().split(" ").last.split(".").first),
      //                                                       print(widget.events.location),
      //                                                       print('shared')
      //                                                     },
      //                                                     icon: const Icon(Icons.share),
      //                                                     iconSize: 20,
      //                                                     color: const Color(0xFF021096),
      //                                                   ),
      //                                                 ),
      //                                               ),
      //                                               const SizedBox(width: 5,),
      //                                               //Reminder Icon
      //                                               Ink(
      //                                                 decoration: const ShapeDecoration(
      //                                                     color: Colors.white,
      //                                                     shape: CircleBorder(
      //                                                       side: BorderSide.none,
      //                                                     )
      //                                                 ),
      //                                                 height: MediaQuery.of(context).size.height*0.05,
      //                                                 width: MediaQuery.of(context).size.width*0.1,
      //                                                 child: Center(
      //                                                   child: IconButton(
      //                                                     onPressed: () =>
      //                                                     {
      //                                                       print('remainder added')
      //                                                     },
      //                                                     icon: const Icon(Icons.access_alarm),
      //                                                     iconSize: 20,
      //                                                     color: const Color(0xFF021096),
      //                                                   ),
      //                                                 ),
      //                                               ),
      //                                               const SizedBox(width: 5,),
      //                                               //Like Icon
      //                                               Mutation(
      //                                                   options:MutationOptions(
      //                                                       document: gql(toggleLike)
      //                                                   ),
      //                                                   builder: (
      //                                                       RunMutation runMutation,
      //                                                       QueryResult? result,
      //                                                       ){
      //                                                     if (result!.hasException){
      //                                                       print(result.exception.toString());
      //                                                     }
      //                                                     return Ink(
      //                                                       decoration: const ShapeDecoration(
      //                                                           color: Color(0xFFFFFFFF),
      //                                                           shape: CircleBorder(
      //                                                             side: BorderSide.none,
      //                                                           )
      //                                                       ),
      //                                                       height: MediaQuery.of(context).size.height*0.05,
      //                                                       width: MediaQuery.of(context).size.width*0.1,
      //                                                       child: Center(
      //                                                         child: IconButton(
      //                                                           onPressed: ()
      //                                                           {
      //                                                             runMutation({
      //                                                               "eventId":widget.events.id
      //                                                             });
      //                                                             refetch!();
      //                                                             print('is liked');
      //                                                             },
      //                                                           icon: const Icon(Icons.thumb_up),
      //                                                           iconSize: 20,
      //                                                           color: isLiked? Colors.blue:Colors.grey,
      //                                                         ),
      //                                                       ),
      //                                                     );
      //                                                   }
      //                                                   ),
      //                                               //Like Count
      //                                               Container(
      //                                                 margin: const EdgeInsets.only(left: 10.0),
      //                                                 child: Text(
      //                                                   "$likeCount likes",
      //                                                   style: const TextStyle(
      //                                                     color: Color(0xFFFFFFFF),
      //                                                     fontWeight: FontWeight.bold,
      //                                                     fontSize: 16.0,
      //                                                   ),
      //                                                 ),
      //                                               ),
      //                                             ],
      //                                           ),
      //                                         ),],
      //                                     ),
      //                                     //Location & Date
      //                                     Container(
      //                                       height: MediaQuery.of(context).size.height*0.15,
      //                                       width: MediaQuery.of(context).size.width*.25,
      //                                       decoration: BoxDecoration(
      //                                         color: const Color(0xFFD3D8FF),
      //                                         borderRadius: BorderRadius.circular(10.0),
      //                                       ),
      //                                       child: Center(
      //                                         child: Column(
      //                                           mainAxisAlignment: MainAxisAlignment.center,
      //                                           crossAxisAlignment: CrossAxisAlignment.center,
      //                                           children: [
      //                                             Center(
      //                                               child: Text(
      //                                                 widget.events.location,
      //                                                 style: const TextStyle(
      //                                                   color: Color(0xFF808CFF),
      //                                                   fontWeight: FontWeight.w900,
      //                                                   fontSize: 14,
      //                                                 ),
      //                                               ),
      //                                             ),
      //                                             const SizedBox(height: 3,),
      //                                             Center(
      //                                               child: Text(
      //                                                 "$date $month $year",
      //                                                 style: const TextStyle(
      //                                                   color: Color(0xFF808CFF),
      //                                                   fontWeight: FontWeight.w900,
      //                                                   fontSize: 14,
      //                                                 ),
      //                                               ),
      //                                             ),
      //                                           ],
      //                                         ),
      //                                       ),
      //                                     ),
      //                                   ],
      //                                 ),
      //                               ),
      // //Edit & Delete buttons
      // // Row(
      // // children: [
      // // if(userId==createdId)
      // // SizedBox(
      // // width: 60,
      // // child: ElevatedButton(
      // // style: ElevatedButton.styleFrom(
      // // primary: const Color(0xFF021096),
      // // padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      // // minimumSize: const Size(35,25),
      // // ),
      // // child: const Text('Edit',
      // // style: TextStyle(
      // // color: Colors.white,
      // // fontSize: 14,
      // // fontWeight: FontWeight.w500,
      // // ),),
      // // onPressed: (){
      // // Navigator.of(context).push(
      // // MaterialPageRoute(
      // // builder: (BuildContext context)=> EditPostEvents(post: widget.post,refetchPosts: widget.refetchPosts,)));
      // // },
      // // ),
      // // ),
      // // const SizedBox(
      // // width: 8,
      // // ),
      // // if(userId==createdId)
      // // Mutation(
      // // options: MutationOptions(
      // // document: gql(deleteEvent)
      // // ),
      // // builder:(
      // // RunMutation runMutation,
      // // QueryResult? result,
      // // ){
      // // if (result!.hasException){
      // // print(result.exception.toString());
      // // }
      // // if(result.isLoading){
      // // return const CircularProgressIndicator();
      // // }
      // // return SizedBox(
      // // width: 65,
      // // child: ElevatedButton(
      // // style: ElevatedButton.styleFrom(
      // // primary: const Color(0xFF021096),
      // // padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      // // minimumSize: const Size(35,25),
      // // ),
      // // onPressed: (){
      // // runMutation({
      // // "eventId":widget.post.id
      // // });
      // // },
      // // child: const Text('Delete',
      // // style: TextStyle(
      // // color: Colors.white,
      // // fontSize: 14,
      // // fontWeight: FontWeight.w500,
      // // ),)
      // // ),
      // // );
      // // }
      // // ),
      // // ],
      // // ),
      //                             ],
      //                           ),
      //                         ]
      //                     ),
      //                   ),
      //                 )
      //             ),
                  child: EventsCard(context, refetch, refetch, tags,values, userId,values.createdById,'homePage'),
                ),
                builder: (_, collapsed, expanded) =>
                    Expandable(
                      collapsed: collapsed, expanded: expanded,)
            ),
          ),
          // ),
        ),
      );
    }
    );
  }
}



class NetOpHomeCard extends StatefulWidget {
  final NetOpPost netops;
  NetOpHomeCard({required this.netops});

  @override
  _NetOpHomeCardState createState() => _NetOpHomeCardState();
}

class _NetOpHomeCardState extends State<NetOpHomeCard> {

  String toggleStarNetop = netopsQuery().toggleStar;
  String toggleLike = netopsQuery().toggleLike;
  late bool isLiked;
  String getNetop = netopsQuery().getNetop;
  late bool isStared;
  late String userId;
  late String createdById;
  TextEditingController noUse = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Tag>tags = widget.netops.tags;
    var likeCount;
    return Query(
        options: QueryOptions(
        document: gql(getNetop),
          variables: {"getNetopNetopId" : widget.netops.id}
    ),
    builder:(QueryResult result, {fetchMore, refetch}) {
    if (result.hasException) {
    print(result.exception.toString());
    return Text(result.exception.toString());
    }
    if (result.isLoading) {
    return const Card(
    clipBehavior: Clip.antiAlias,
    elevation: 5.0,
    color: Color(0xFFF9F6F2),
    child: SizedBox(
    height: 60,
    width: 20,
    )
    );
    }
    isStared = result.data!["getNetop"]["isStared"];
    likeCount = result.data!["getNetop"]["likeCount"];
    isLiked = result.data!["getNetop"]["isLiked"];
    userId = result.data!["getMe"]["id"];
    createdById = result.data!["getNetop"]["createdBy"]["id"];
    var values = widget.netops;
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
                child: Single_Post(post: widget.netops,isStarred: isStared,refetch: refetch,)),

            collapsed: Padding(
              padding: const EdgeInsets.fromLTRB(2, 2, 2, 3),
              // child: Card(
              //     clipBehavior: Clip.antiAlias,
              //     elevation: 5.0,
              //     color: const Color(0xFF808CFF),
              //     child: Padding(
              //       padding: const EdgeInsets.fromLTRB(12.0, 0.0, 0.0, 0.0),
              //       child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.stretch,
              //           children: [
              //             Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 //Title & Star
              //                 Row(
              //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                   children: [
              //                     //Title
              //                     SizedBox(
              //                       width: MediaQuery
              //                           .of(context)
              //                           .size
              //                           .width * 0.5,
              //                       child: SubHeading(widget.netops.title)
              //                     ),
              //
              //                     Mutation(
              //                         options:MutationOptions(
              //                             document: gql(toggleStarNetop)
              //                         ),
              //                         builder: (
              //                             RunMutation runMutation,
              //                             QueryResult? result,
              //                             ){
              //                           if (result!.hasException){
              //                             print(result.exception.toString());
              //                           }
              //                           return IconButton(
              //                             onPressed: (){
              //                               runMutation({
              //                                 "toggleStarNetopId":widget.netops.id
              //                               });
              //                               refetch!();
              //                             },
              //                             icon: isStared? const Icon(Icons.star): const Icon(Icons.star_border),
              //                             color: isStared? Colors.amber:Colors.white,
              //                           );
              //                         }
              //                     ),
              //                   ],
              //                 ),
              //
              //                 //Images
              //                 if(widget.netops.imgUrl==null)
              //                   Text(
              //                     widget.netops.description.length > 250
              //                         ? widget.netops.description.substring(
              //                         0, 250) + '...'
              //                         : widget.netops.description,
              //                     style: const TextStyle(
              //                       fontSize: 15.0,
              //                     ),
              //                   ),
              //                 if(widget.netops.imgUrl !=null)
              //                   SizedBox(
              //                       width: 400.0,
              //                       child: Image.network(
              //                           widget.netops.imgUrl!,
              //                           height: 150.0)
              //                   ),
              //
              //                 //Rows for Tags, Icons
              //                 Padding(
              //                   padding: const EdgeInsets.fromLTRB(0, 5, 12, 5),
              //                   child: Row(
              //                     children: [
              //                       Column(
              //                         crossAxisAlignment: CrossAxisAlignment.start,
              //                         children: [
              //                           //Tags
              //                           Padding(
              //                             padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
              //                             child: SizedBox(
              //                               width: 200.0,
              //                               height: 20.0,
              //                               child: ListView(
              //                                 scrollDirection: Axis.horizontal,
              //                                 children: tags.map((tag) =>
              //                                     SizedBox(
              //                                       height: 25.0,
              //                                       child: Padding(
              //                                         padding: const EdgeInsets.fromLTRB(2.0, 0.0, 2.0, 0.0),
              //                                         child: TagButtons(tag, context)
              //                                       ),
              //                                     )).toList(),
              //                               ),
              //                             ),
              //                           ),
              //
              //                           //Icons
              //                           Padding(
              //                             padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
              //                             child: Row(
              //                               children: [
              //                                 //Share Icon
              //                                 Ink(
              //                                   decoration: const ShapeDecoration(
              //                                       color: Color(0xFFFFFFFF),
              //                                       shape: CircleBorder(
              //                                         side: BorderSide.none,
              //                                       )
              //                                   ),
              //                                   height: 36,
              //                                   width: 36,
              //                                   child: Center(
              //                                     child: IconButton(onPressed: () =>
              //                                     {
              //                                       print('shared')
              //                                     }, icon: const Icon(Icons.share),
              //                                       iconSize: 20,
              //                                       color:const Color(0xFF021096),),
              //                                   ),
              //                                 ),
              //                                 const SizedBox(width: 5,),
              //
              //                                 //Reminder
              //                                 Ink(
              //                                   decoration: const ShapeDecoration(
              //                                       color: Colors.white,
              //                                       shape: CircleBorder(
              //                                         side: BorderSide.none,
              //                                       )
              //                                   ),
              //                                   height: 36,
              //                                   width: 36,
              //                                   child: Center(
              //                                     child: IconButton(onPressed: () =>
              //                                     {
              //                                       print('remainder added')
              //                                     },
              //                                       icon: const Icon(Icons.access_alarm),
              //                                       iconSize: 20,
              //                                       color: const Color(0xFF021096),),
              //                                   ),
              //                                 ),
              //                                 const SizedBox(width: 5,),
              //
              //                                 Mutation(
              //                                     options:MutationOptions(
              //                                         document: gql(toggleLike)
              //                                     ),
              //                                     builder: (
              //                                         RunMutation runMutation,
              //                                         QueryResult? result,
              //                                         ){
              //                                       if (result!.hasException){
              //                                         print(result.exception.toString());
              //                                       }
              //                                       return Ink(
              //                                         decoration: const ShapeDecoration(
              //                                             color: Color(0xFFFFFFFF),
              //                                             shape: CircleBorder(
              //                                               side: BorderSide.none,
              //                                             )
              //                                         ),
              //                                         height: 36,
              //                                         width: 36,
              //                                         child: Center(
              //                                           child: IconButton(onPressed: () =>
              //                                           {
              //                                             Navigator.push(
              //                                               context,
              //                                               MaterialPageRoute(
              //                                                   builder: (context) =>
              //                                                       Comments(post: widget
              //                                                           .netops,)),
              //                                             ),
              //                                             print('commented'),
              //                                           }, icon: const Icon(Icons.comment),
              //                                             iconSize: 20,
              //                                             color: const Color(0xFF021096),),
              //                                         ),
              //                                       );
              //                                     }
              //                                 ),
              //                                 const SizedBox(width: 5,),
              //
              //                                 Mutation(
              //                                     options:MutationOptions(
              //                                         document: gql(toggleLike)
              //                                     ),
              //                                     builder: (
              //                                         RunMutation runMutation,
              //                                         QueryResult? result,
              //                                         ){
              //                                       if (result!.hasException){
              //                                         print(result.exception.toString());
              //                                       }
              //                                       return Ink(
              //                                         decoration: const ShapeDecoration(
              //                                             color: Color(0xFFFFFFFF),
              //                                             shape: CircleBorder(
              //                                               side: BorderSide.none,
              //                                             )
              //                                         ),
              //                                         height: 36,
              //                                         width: 36,
              //                                         child: Center(
              //                                           child: IconButton(
              //                                             onPressed: () =>
              //                                             {
              //                                               print('remainder added')
              //                                             },
              //                                             icon: const Icon(Icons.thumb_up),
              //                                             iconSize: 20,
              //                                             color: const Color(0xFF021096),
              //                                           ),
              //                                         ),
              //                                       );
              //                                     }
              //                                 ),
              //
              //                                 Container(
              //                                   margin: const EdgeInsets.only(left: 10.0),
              //                                   child: Text(
              //                                     "$likeCount likes",
              //                                     style: const TextStyle(
              //                                       color: Color(0xFFFFFFFF),
              //                                       fontWeight: FontWeight.bold,
              //                                       fontSize: 16.0,
              //                                     ),
              //                                   ),
              //                                 ),
              //
              //                               ],
              //                             ),
              //                           ),
              //
              //                           //Button Row
              //                           // Row(
              //                           //   children: [
              //                           //     if(userId==createdId)
              //                           //       SizedBox(
              //                           //         width: 60,
              //                           //         child: ElevatedButton(
              //                           //           style: ElevatedButton.styleFrom(
              //                           //             primary: Color(0xFF021096),
              //                           //             padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              //                           //             minimumSize: Size(35,25),
              //                           //           ),
              //                           //           child: Text('Edit',
              //                           //             style: TextStyle(
              //                           //               color: Colors.white,
              //                           //               fontSize: 14,
              //                           //               fontWeight: FontWeight.bold,
              //                           //             ),),
              //                           //           onPressed: (){
              //                           //             Navigator.of(context).push(
              //                           //                 MaterialPageRoute(
              //                           //                     builder: (BuildContext context)=> EditPost(post: widget.post,refetchPosts: widget.refetchPosts,)));
              //                           //           },
              //                           //         ),
              //                           //       ),
              //                           //     SizedBox(width: 8,),
              //                           //
              //                           //     if(userId==createdId)
              //                           //       Mutation(
              //                           //           options: MutationOptions(
              //                           //               document: gql(deleteNetop)
              //                           //           ),
              //                           //           builder:(
              //                           //               RunMutation runMutation,
              //                           //               QueryResult? result,
              //                           //               ){
              //                           //             if (result!.hasException){
              //                           //               print(result.exception.toString());
              //                           //             }
              //                           //             if(result.isLoading){
              //                           //               return CircularProgressIndicator();
              //                           //             }
              //                           //             return SizedBox(
              //                           //               width: 65,
              //                           //               child: ElevatedButton(
              //                           //                   style: ElevatedButton.styleFrom(
              //                           //                     primary: Color(0xFF021096),
              //                           //                     padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              //                           //                     minimumSize: Size(35,25),
              //                           //                   ),
              //                           //                   onPressed: (){
              //                           //                     runMutation({
              //                           //                       "eventId":widget.post.id
              //                           //                     });
              //                           //                   },
              //                           //                   child: Text('Delete',
              //                           //                     style: TextStyle(
              //                           //                       color: Colors.white,
              //                           //                       fontSize: 14,
              //                           //                       fontWeight: FontWeight.w500,
              //                           //                     ),)
              //                           //               ),
              //                           //             );
              //                           //           }
              //                           //       ),
              //                           //     SizedBox(width: 8,),
              //                           //
              //                           //     SizedBox(
              //                           //       child: ElevatedButton(
              //                           //         child: Text('Report',
              //                           //           style: TextStyle(
              //                           //             color: Colors.white,
              //                           //             fontSize: 14,
              //                           //             fontWeight: FontWeight.w500,
              //                           //           ),),
              //                           //         style: ElevatedButton.styleFrom(
              //                           //           primary: Color(0xFF021096),
              //                           //           padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              //                           //           minimumSize: Size(35,25),
              //                           //         ),
              //                           //         onPressed: (){
              //                           //           return showAlertDialog(context);
              //                           //         },
              //                           //       ),
              //                           //     ),
              //                           //   ],
              //                           // )
              //                         ],
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //
              //               ],
              //             ),
              //           ]
              //       ),
              //     )
              // ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0,0,0,10.0),
                // child: Container(),
                child: NetopsCard(context, refetch, refetch, isStared, tags, userId,createdById,noUse, values,'HomePage'),
              ),
            ),
            builder: (_, collapsed, expanded) =>
                Expandable(
                  collapsed: collapsed, expanded: expanded,)
        ),
      ),
      // ),
    );
    });
  }
}




class AnnouncementHomeCard extends StatefulWidget {
  final Announcement announcements;
  AnnouncementHomeCard({required this.announcements});

  @override
  _AnnouncementHomeCardState createState() => _AnnouncementHomeCardState();
}

class _AnnouncementHomeCardState extends State<AnnouncementHomeCard> {

  var images;
  Future<QueryResult?> Function()? refetch;

  @override
  Widget build(BuildContext context) {
    if (widget.announcements.images != null) {
      images = widget.announcements.images!.split(" AND ");
    }
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
              child: SingleAnnouncement(
                announcement: Announcement(
                  title: widget.announcements.title,
                  description: widget.announcements.description,
                  endTime: widget.announcements.endTime,
                  id: widget.announcements.id,
                  images: widget.announcements.images,
                  createdByUserId:
                  widget.announcements.createdByUserId,
                  hostelIds: widget.announcements.hostelIds,
                ),
              ),
            ),
            collapsed: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
              // child: Card(
              //   color: const Color(0xFFDEDDFF),
              //   shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(10.0)),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.stretch,
              //     children: [
              //       Padding(
              //         padding: const EdgeInsets.fromLTRB(12.0, 10.0, 0.0, 0.0),
              //         child: SubHeading(widget.announcements.title)
              //       ),
              //       if (images[0] != "")
              //         ClipRect(
              //           child: SizedBox(
              //             width: 400.0,
              //             child: CarouselSlider(
              //               items: images
              //                   .map((item) => Container(
              //                 child: Center(
              //                   child: Image.network(
              //                     item,
              //                     fit: BoxFit.cover,
              //                     width: 400,
              //                   ),
              //                 ),
              //               ))
              //                   .toList(),
              //               options: CarouselOptions(
              //                 enableInfiniteScroll: false,
              //               ),
              //             ),
              //           ),
              //         ),
              //       if (images[0] == "")
              //         DescriptionTextWidget(
              //             text: widget.announcements.description),
              //     ],
              //   ),
              // ),
              child: AnnouncementsCards(context,images,'','',refetch,widget.announcements,'homePage'),
            ),
            builder: (_, collapsed, expanded) =>
                Expandable(
                  collapsed: collapsed, expanded: expanded,)
        ),
      ),
    );

  }
}

class HostelAmenity extends StatefulWidget {

  final Amenities amenities;
  HostelAmenity({required this.amenities});

  @override
  _HostelAmenityState createState() => _HostelAmenityState();
}

//Hostel Amenity Card
class _HostelAmenityState extends State<HostelAmenity> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
      child: Card(
        elevation: 3,
        color: const Color(0xFFFFFFFF),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0)),
        child: Column(
          children: [
            //Name
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 10, 5),
              child: Center(
                child: Row(
                  children: [
                    Text(widget.amenities.name,
                      style: const TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.bold,
                      ),
              ),
                  ],
                ),
              ),
            ),

            //Description
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 10, 10),
              child: Row(
                children: [
                  Text(widget.amenities.description,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HostelContacts extends StatefulWidget {

  final Contacts contacts;
  HostelContacts({required this.contacts});

  @override
  _HostelContactsState createState() => _HostelContactsState();
}

//Hostel Contacts Card
class _HostelContactsState extends State<HostelContacts> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
      child: Card(
        elevation: 3,
        color: const Color(0xFFFFFFFF),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Content
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Names
                Column(
                  children: [
                    //Designation
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 10, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(widget.contacts.type,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    //Contact Name
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 10, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(widget.contacts.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                //Mobile
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 15, 0),
                  child: SizedBox(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.305,
                    child: ElevatedButton(
                        onPressed: () {
                          launch('tel:${widget.contacts.contact}');
                        },
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xFF42454D),
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          minimumSize: const Size(50, 35),
                        ),
                        child: Container(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.call,
                                color: Colors.white,
                                size: 14,
                              ),

                              const SizedBox(
                                width: 5,
                              ),

                              Text(widget.contacts.contact,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class EmergencyContacts extends StatefulWidget {

  final emergencycontacts Emergencycontacts;
  EmergencyContacts({required this.Emergencycontacts});

  @override
  _EmergencyContactsState createState() => _EmergencyContactsState();
}

//Emergency Contact List
class _EmergencyContactsState extends State<EmergencyContacts> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
      child: Card(
        elevation: 3,
        color: const Color(0xFFFFFFFF),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0)),

        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Name
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                child: SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.40,
                  child: Text(widget.Emergencycontacts.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              //Mobile
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 12, 0),
                child: SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.35,
                  child: ElevatedButton(
                      onPressed: () {
                        launch('tel:${widget.Emergencycontacts.contact}');
                      },

                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF42454D),
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      minimumSize: const Size(50, 35),
                    ),

                    child: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.28,
                      child: Center(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.call,
                              color: Colors.white,
                              size: 14,
                            ),

                            const SizedBox(
                              width: 5,
                            ),

                            Text(widget.Emergencycontacts.contact,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



