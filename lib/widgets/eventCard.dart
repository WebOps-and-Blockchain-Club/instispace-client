import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:client/graphQL/events.dart';
import 'package:client/widgets/expandDescription.dart';
import 'package:client/widgets/NetOpCard.dart';
import 'package:client/widgets/imageView.dart';
import 'package:client/widgets/tagButtons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:client/models/tag.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:client/widgets/marquee.dart';
import '../screens/home/events/editEvent.dart';
import '../models/eventsClass.dart';
import 'addToCal.dart';


class EventsCard extends StatefulWidget {
  Future<QueryResult?> Function()? refetch;
  String userId;
  eventsPost post;
  String userRole;

  EventsCard({required this.post,required this.refetch,required this.userId,required this.userRole});

  @override
  _EventsCardState createState() => _EventsCardState();
}

class _EventsCardState extends State<EventsCard> {
  ///GraphQL
  String delete = eventsQuery().deleteEvent;
  String toggleStar = eventsQuery().toggleStar;
  String toggleLike = eventsQuery().toggleLike;


  @override
  Widget build(BuildContext context) {
    ///Variables
    String month = '';
    var events = widget.post;
    var userId = widget.userId;
    var userRole = widget.userRole;
    var createdId = events.createdById;
    String date = events.time.split("-")[2].split("T")[0];
    String year = events.time.split("-")[0];
    String Time = events.time.split("T").last.split(".").first;
    String hourTime = Time.split(":").first;
    String dayTime = '';
    if (hourTime == '01' ||
        hourTime == '02' ||
        hourTime == '03' ||
        hourTime == '04' ||
        hourTime == '05' ||
        hourTime == '06' ||
        hourTime == '07' ||
        hourTime == '08' ||
        hourTime == '09' ||
        hourTime == '10' ||
        hourTime == '11' ||
        hourTime == '12'
    ) {dayTime = 'AM';}
    if (hourTime == '00') {hourTime = '12';dayTime = 'AM';}
    if (hourTime == '12') {hourTime = '12';dayTime = 'PM';}
    if (hourTime == '13') {hourTime = '01';dayTime = 'PM';}
    if (hourTime == '14') {hourTime = '02';dayTime = 'PM';}
    if (hourTime == '15') {hourTime = '03';dayTime = 'PM';}
    if (hourTime == '16') {hourTime = '04';dayTime = 'PM';}
    if (hourTime == '17') {hourTime = '05';dayTime = 'PM';}
    if (hourTime == '18') {hourTime = '06';dayTime = 'PM';}
    if (hourTime == '19') {hourTime = '07';dayTime = 'PM';}
    if (hourTime == '20') {hourTime = '08';dayTime = 'PM';}
    if (hourTime == '21') {hourTime = '09';dayTime = 'PM';}
    if (hourTime == '22') {hourTime = '10';dayTime = 'PM';}
    if (hourTime == '23') {hourTime = '11';dayTime = 'PM';}

    String minTime = Time.split(":")[1];

    if(events.time.split("-")[1] == "01") {month = "JAN";}
    if(events.time.split("-")[1] == "02") {month = "FEB";}
    if(events.time.split("-")[1] == "03") {month = "MARCH";}
    if(events.time.split("-")[1] == "04") {month = "APRIL";}
    if(events.time.split("-")[1] == "05") {month = "MAY";}
    if(events.time.split("-")[1] == "06") {month = "JUNE";}
    if(events.time.split("-")[1] == "07") {month = "JULY";}
    if(events.time.split("-")[1] == "08") {month = "AUG";}
    if(events.time.split("-")[1] == "09") {month = "SEPT";}
    if(events.time.split("-")[1] == "10") {month = "OCT";}
    if(events.time.split("-")[1] == "11") {month = "NOV";}
    if(events.time.split("-")[1] == "12") {month = "DEC";}


    ///Called the function difference to calculate time difference
    String timeDifference = difference(events.createdAt);
    return Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.5)
        ),
        elevation: 4.0,
        // color: const Color(0xFFFFFFFF),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// Title,edit,delete,star Row
            Container(
              color: const Color(0xFF42454D),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15,0,0,0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    ///Title
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,0,0,0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width*0.5,
                        child: MarqueeWidget(
                          direction: Axis.horizontal,
                          child: Text(
                            capitalize(events.title),
                            style: TextStyle(
                              //Conditional Font Size
                              fontWeight: (userId==events.createdById)
                                  ? FontWeight.w700
                                  : FontWeight.bold,
                              //Conditional Font Size
                              fontSize: (userId==events.createdById)
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
                        if(userId==createdId || userRole == "ADMIN" || userRole == "HAS" || userRole == "SECRETORY")
                          IconButton(
                            onPressed: (){
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) => EditPostEvents(post: events,refetchPosts: widget.refetch)
                                  )
                              );
                            },
                            icon: const Icon(Icons.edit_outlined),
                            color: Colors.white,
                            iconSize: 20,
                          ),

                        ///Delete Button
                        if(userId==createdId || userRole == "ADMIN" || userRole == "HAS" || userRole == "SECRETORY")
                          Mutation(
                              options: MutationOptions(
                                  document: gql(delete),
                                  onCompleted: (result){
                                    print("result : $result");
                                    widget.refetch!();
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
                                      "eventId":events.id
                                    });
                                  },
                                  icon: const Icon(Icons.delete_outline),
                                  color: Colors.white,
                                  iconSize: 20,
                                );
                              }
                          ),

                        ///Star Button
                        Mutation(
                            options:MutationOptions(
                                document: gql(toggleStar),
                                onCompleted: (result){
                                  // print(result);
                                  if(result["toggleStarEvent"]){
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
                              return IconButton(
                                onPressed: (){
                                  runMutation({
                                    "eventId":events.id
                                  });
                                  events.isStarred = !events.isStarred;
                                },
                                icon: events.isStarred? const Icon(Icons.star): const Icon(Icons.star_border),
                                color: events.isStarred? Colors.white:Colors.white,
                                iconSize: 20,
                              );
                            }
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),

            ///Images
            if (events.imgUrl.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(15,10,15,0),
                child: CarouselSlider(
                  // items: events.imgUrl.map((item) => Container(
                  //   child: Center(
                  //     child: Image.network(item,fit: BoxFit.contain,width: 400,),
                  //   ),
                  items: events.imgUrl.map((item) => Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5,0,5,0),
                      child: GestureDetector(
                        child: Center(
                          child: Image.network(item,fit: BoxFit.contain,width: 400,),
                        ),
                        onTap: () {
                          openImageView(context, events.imgUrl.indexOf(item), events.imgUrl);
                        },
                      ),
                    ),
                  )
                  ).toList(),
                  options: CarouselOptions(
                      enableInfiniteScroll: true,
                      autoPlay: true
                  ),
                ),
              ),

            ///Description
            Padding(
              padding: const EdgeInsets.fromLTRB(18,5,18,0),
              child: DescriptionTextWidget(text: events.description),
            ),

            ///Location & Time
            Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15,10,15,0),
                  child: Row(
                    children: [
                      const Icon(Icons.location_pin,size: 20,),
                      Text(
                        events.location,
                        style: const TextStyle(
                            color: Colors.black
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15,5,10,0),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time,size: 20,),
                      Text(
                        " $hourTime:$minTime $dayTime, $date $month $year",
                        style: const TextStyle(
                            color: Colors.black
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            /// Call to Action Button
            if (events.linkName != null && events.linkToAction != null && events.linkToAction !="")
              Padding(
                padding: const EdgeInsets.fromLTRB(15,10,15,0),
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width*0.9,
                    height: 24,
                    child: ElevatedButton(
                      onPressed: () {
                        launch('${events.linkToAction}');
                      },
                      child: Text(
                        events.linkName!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF42454D),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            /// Tags Wrap
            if(events.tags.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(15,10,8,0),
                child: Wrap(
                  children: events.tags.map((tag) =>
                      SizedBox(
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                            child: TagButtons(tag, context)
                        ),
                      ))
                      .toList(),
                ),
              ),


            ///Posted by
            Padding(
              padding:  const EdgeInsets.fromLTRB(18,10,18,0),
              child: Text(
                'Posted by ${events.createdByName}, $timeDifference',
                // ${events.createdByName}
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 10.0,
                ),
              ),
            ),

            ///Button Row (Share, Like, Set Reminder)
            Padding(
              padding: const EdgeInsets.fromLTRB(10,0,10,10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  ///Share Icon
                  IconButton(
                    onPressed: () =>
                    {
                      print('shared')
                    },
                    icon: const Icon(Icons.share),
                    iconSize: 20,
                    color: Colors.grey,
                    // color: const Color(0xFF021096),
                  ),

                  /// Like Button and Like Count
                  Row(
                    children: [

                      ///Like Icon
                      Mutation(
                          options:MutationOptions(
                              document: gql(toggleLike),
                              onCompleted: (result){
                                if(result["toggleLikeEvent"]){
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
                            return IconButton(
                              onPressed: ()
                              {
                                runMutation({
                                  "eventId":events.id
                                });
                                setState(() {
                                  events.isLiked = !events.isLiked;
                                  if(events.isLiked){
                                    events.likeCount = events.likeCount+1;
                                    print("likeCOunt: ${events.likeCount}");
                                  }
                                  else{
                                    events.likeCount = events.likeCount-1;
                                    print("likeCOunt: ${events.likeCount}");
                                  }
                                });
                              },
                              icon: const Icon(Icons.thumb_up),
                              iconSize: 20,
                              color: events.isLiked? const Color(0xFF42454D):Colors.grey,
                            );
                          }
                      ),

                      ///Like Count

                      Text(
                        "${events.likeCount}",
                        style: const TextStyle(
                          color: Color(0xFF42454D),
                          fontWeight: FontWeight.w400,
                          fontSize: 10.0,
                        ),
                      ),
                    ],
                  ),

                  /// Set Reminder
                  IconButton(
                    onPressed: () =>
                    {
                      Add2Calendar.addEvent2Cal(
                        buildEvent(title: events.title, startDate: DateTime.parse(events.time), description: events.description, endDate: DateTime.parse(events.time).add(const Duration(hours: 1)), location: events.location),
                      ),
                    },
                    icon: const Icon(Icons.access_alarm),
                    iconSize: 20,
                    color:Colors.grey,
                    // color: const Color(0xFF021096),
                  ),
                ],
              ),
            ),
          ],
        )
    );;
  }
}

///Function to capitalize first letter of Title
String capitalize(String s) {
  if(s!="") {
    return s[0].toUpperCase() + s.substring(1);
  } else{
    return s;
  }
}