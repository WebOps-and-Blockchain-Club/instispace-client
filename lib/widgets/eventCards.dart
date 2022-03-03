import 'package:carousel_slider/carousel_slider.dart';
import 'package:client/graphQL/events.dart';
import 'package:client/screens/Events/post.dart';
import 'package:client/screens/home/Announcements/expand_description.dart';
import 'package:client/screens/wrapper.dart';
import 'package:client/widgets/NetOpCards.dart';
import 'package:client/widgets/tagButtons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:client/models/tag.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:client/widgets/marquee.dart';

import '../screens/Events/editEvent.dart';

Widget EventsCard (
    BuildContext context,
    Future<QueryResult?> Function()? refetch,
    Future<QueryResult?> Function()? refetchPosts,
    DateTime postCreated,
    List<Tag> tags,
    Post events,
    String userId,
    String createdId,
    ) {

  String delete = eventsQuery().deleteEvent;
  String toggleStar = eventsQuery().toggleStar;
  String toggleLike = eventsQuery().toggleLike;

  String month = '';
  String date = events.time.split("-")[2].split("T")[0];
  String year = events.time.split("-")[0];
  // print(events.time);
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

  List<String> Images = ['https://thumbs.dreamstime.com/b/beautiful-rain-forest-ang-ka-nature-trail-doi-inthanon-national-park-thailand-36703721.jpg','https://media.istockphoto.com/photos/renewable-energy-and-sustainable-development-picture-id1186330948?k=20&m=1186330948&s=612x612&w=0&h=5aNPCcQ8FcZraX44PEhb2mqcHkow2xMITJMHdh28xNg=','https://cdn.pixabay.com/photo/2018/04/04/13/38/nature-3289812_1280.jpg'];

String timeDifference = difference(postCreated);

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
                            child: Text(events.title,
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
                          if(userId==createdId)
                            IconButton(
                              onPressed: (){
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) => EditPostEvents(post: events,refetchPosts: refetchPosts)
                                    )
                                );
                              },
                              icon: const Icon(Icons.edit_outlined),
                              color: Colors.white,
                              iconSize: 20,
                            ),

                          ///Delete Button
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
                                    return const CircularProgressIndicator();
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
                                      refetch!();
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

              if (events.imgUrl != [])
              Padding(
                padding: const EdgeInsets.fromLTRB(15,10,15,0),
                child: CarouselSlider(
                  // items: events.imgUrl.map((item) => Container(
                  //   child: Center(
                  //     child: Image.network(item,fit: BoxFit.contain,width: 400,),
                  //   ),
                  items: Images.map((item) => Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5,0,5,0),
                      child: Center(
                        child: Image.network(item,fit: BoxFit.contain,width: 400,),
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
                  if (events.linkName != '')
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
                            events.linkName,
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
              if(tags.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(15,10,8,0),
                  child: Wrap(
                    children: tags.map((tag) =>
                        SizedBox(
                          child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 2, 0),
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
                  'Posted by Admin, $timeDifference',
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
                                        refetch!();
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
                            print('remainder added')
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
      );
}