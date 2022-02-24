import 'package:carousel_slider/carousel_slider.dart';
import 'package:client/graphQL/events.dart';
import 'package:client/screens/Events/post.dart';
import 'package:client/screens/home/Announcements/expand_description.dart';
import 'package:client/widgets/tagButtons.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:client/models/tag.dart';

import '../screens/Events/editEvent.dart';

Widget EventsCard (
    BuildContext context,
    Future<QueryResult?> Function()? refetch,
    Future<QueryResult?> Function()? refetchPosts,
    List<Tag> tags,
    Post events,
    String userId,
    String createdId,
    String page,
    ) {

  String delete = eventsQuery().deleteEvent;
  String toggleStar = eventsQuery().toggleStar;
  String toggleLike = eventsQuery().toggleLike;

  String month = '';
  String date = '';
  String year = '';

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


  return Card(
          clipBehavior: Clip.antiAlias,
          elevation: 5.0,
          color: const Color(0xFF808CFF),
          child: SizedBox(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.3,
            width: MediaQuery
                .of(context)
                .size
                .width * 1,
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
                              events.title,
                              style: const TextStyle(
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
                                        "eventId":events.id
                                      });
                                      refetch!();
                                    },
                                    icon: events.isStarred?const Icon(Icons.star):Icon(Icons.star_border),
                                    color: events.isStarred? Colors.amber:Colors.grey,
                                  );
                                }
                            ),
                          ],
                        ),
                        //Images & Alt Text
                        if(events.imgUrl.isEmpty)
                          DescriptionTextWidget(text: events.description),
                          // Text(
                          //   events.description.length > 250
                          //       ? events.description.substring(
                          //       0, 250) + '...'
                          //       : events.description,
                          //   style: const TextStyle(
                          //     fontSize: 15.0,
                          //   ),
                          // ),
                        if(events.imgUrl.isNotEmpty)
                          CarouselSlider(
                            items: events.imgUrl.map((item) => Container(
                              child: Center(
                                child: Image.network(item,fit: BoxFit.cover,width: 400,),
                              ),
                            )
                            ).toList(),
                            options: CarouselOptions(
                              enableInfiniteScroll: false,
                            ),
                          ),
                        const SizedBox(
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
                                          width: MediaQuery.of(context).size.width*0.5,
                                          height: 20,
                                          child: ListView(
                                            scrollDirection: Axis.horizontal,
                                            children: tags.map((tag) =>
                                                SizedBox(
                                                  child: Padding(
                                                    padding: const EdgeInsets.fromLTRB(2.0, 0.0, 2.0, 0.0),
                                                    child: TagButtons(tag, context)
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
                                          height: MediaQuery.of(context).size.height*0.05,
                                          width: MediaQuery.of(context).size.width*0.1,
                                          child: Center(
                                            child: IconButton(
                                              onPressed: () =>
                                              {
                                                print('shared')
                                              },
                                              icon: const Icon(Icons.share),
                                              iconSize: 20,
                                              color: const Color(0xFF021096),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 5,),
                                        //Reminder Icon
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
                                                  print('remainder added')
                                                },
                                                icon: const Icon(Icons.access_alarm),
                                                iconSize: 20,
                                                color: const Color(0xFF021096),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 5,),
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
                                                height: MediaQuery.of(context).size.height*0.05,
                                                width: MediaQuery.of(context).size.width*0.1,
                                                child: Center(
                                                  child: IconButton(
                                                    onPressed: ()
                                                    {
                                                    runMutation({
                                                    "eventId":events.id
                                                    });
                                                      refetch!();
                                                      print('is liked');
                                                    },
                                                    icon: const Icon(Icons.thumb_up),
                                                    iconSize: 20,
                                                    color: events.isLiked? Colors.blue:Colors.grey,
                                                  ),
                                                ),
                                              );
                                            }
                                        ),
                                        //Like Count
                                        Container(
                                          margin: const EdgeInsets.only(left: 10.0),
                                          child: Text(
                                            "${events.likeCount} likes",
                                            style: const TextStyle(
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
                                          events.location,
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
                        //Edit & Delete buttons
                        if (page == 'eventsSection')
                        Row(
                          children: [
                            if(userId==createdId)
                              SizedBox(
                                width: 60,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: const Color(0xFF021096),
                                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                    minimumSize: const Size(35,25),
                                  ),
                                  child: const Text('Edit',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),),
                                  onPressed: (){
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context)=> EditPostEvents(post: events,refetchPosts: refetchPosts,)));
                                  },
                                ),
                              ),
                            const SizedBox(
                              width: 8,
                            ),
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
                                    return SizedBox(
                                      width: 65,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: const Color(0xFF021096),
                                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                            minimumSize: const Size(35,25),
                                          ),
                                          onPressed: (){
                                            runMutation({
                                              "eventId":events.id
                                            });
                                          },
                                          child: const Text('Delete',
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
            ),
          )
      );
}