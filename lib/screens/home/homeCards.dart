import 'package:client/graphQL/events.dart';
import 'package:client/graphQL/home.dart';
import 'package:client/graphQL/hostelProfile.dart';
import 'package:client/graphQL/hostelProfile.dart';
import 'package:client/graphQL/netops.dart';
import 'package:client/models/post.dart';
import 'package:client/models/tag.dart';
import 'package:client/screens/Events/post.dart';
import 'package:client/screens/home/Announcements/Announcement.dart';
import 'package:client/screens/home/Announcements/SingleAnnouncement.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../graphQL/hostelProfile.dart';
import '../Events/singlepost.dart';
import 'networking_and _opportunities/singlepost.dart';
import 'package:url_launcher/url_launcher.dart';



class EventsHomeCard extends StatefulWidget {
  final Post events;
  EventsHomeCard({required this.events});
  @override
  _EventsHomeCardState createState() => _EventsHomeCardState();
}

class _EventsHomeCardState extends State<EventsHomeCard> {

  String toggleStar=netopsQuery().toggleStar;
  String getEvent = eventsQuery().getEvent;
  String toggelStarEvent = homeQuery().toggelStarEvent;
   late bool isStared;
   String month = '';


  @override
  Widget build(BuildContext context) {

    List<Tag>tags = widget.events.tags;
    return Query(
        options: QueryOptions(
        document: gql(getEvent),
          variables: {"eventId":widget.events.id}
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

      return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
        child: InkWell(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => SinglePost(refetch: refetch, post: widget.events, isStarred: isStared,)));
          },
          child: Card(
            color: Colors.blue[800],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.events.title
                    ),
                    Mutation(
                        options:MutationOptions(
                            document: gql(toggelStarEvent)
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
                                "eventId":widget.events.id
                              });
                              refetch!();
                            },
                            icon: isStared?Icon(Icons.star):Icon(Icons.star_border),
                            color: isStared? Colors.amber:Colors.grey,
                          );
                        }
                    ),
                  ],
                ),
                // Text(
                //   widget.events.location
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 240.0,
                      height: 30.0,
                      child: ListView(
                        scrollDirection: Axis
                            .horizontal,
                        children: tags.map((tag) =>
                            SizedBox(
                              height: 25.0,
                              child: Padding(
                                padding: const EdgeInsets
                                    .fromLTRB(
                                    2.0, 0.0, 2.0,
                                    0.0),
                                child: ElevatedButton(
                                    onPressed: () =>
                                    {
                                    },
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty
                                            .all(
                                            Colors
                                                .grey),
                                        shape: MaterialStateProperty
                                            .all<
                                            RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius
                                                  .circular(
                                                  30.0),
                                            ))
                                    ),
                                    child: Text(
                                      tag.Tag_name,
                                    )),
                              ),
                            )).toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.lightBlueAccent,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            children: [
                              Text("${widget.events.time.split("-").last.split("T").first} $month"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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

  String toggleStar=netopsQuery().toggleStar;
  String toggelStarEvent = homeQuery().toggelStarEvent;
  String getMeHome = homeQuery().getMeHome;
  String getNetop = netopsQuery().getNetop;
  late bool isStared;

  @override
  Widget build(BuildContext context) {
    List<Tag>tags = widget.netops.tags;
    return Query(
        options: QueryOptions(
        document: gql(getNetop),
          variables: {"getNetopNetopId":widget.netops.id}
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
      child: InkWell(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => Single_Post(post: widget.netops, isStarred: isStared, refetch: refetch,)));
        },
        child: Card(
          color: Colors.blue[800],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0)),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      widget.netops.title
                  ),
                  Mutation(
                      options:MutationOptions(
                          document: gql(toggelStarEvent)
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
                              "eventId":widget.netops.id
                            });
                            refetch!();
                          },
                          icon: isStared?const Icon(Icons.star):const Icon(Icons.star_border),
                          color: isStared? Colors.amber:Colors.grey,
                        );
                      }
                  ),
                ],
              ),
              // Text(
              //     widget.netops.location
              // ),
              Row(
                children: [
                  SizedBox(
                    width: 240.0,
                    height: 30.0,
                    child: ListView(
                      scrollDirection: Axis
                          .horizontal,
                      children: tags.map((tag) =>
                          SizedBox(
                            height: 25.0,
                            child: Padding(
                              padding: const EdgeInsets
                                  .fromLTRB(
                                  2.0, 0.0, 2.0,
                                  0.0),
                              child: ElevatedButton(
                                  onPressed: () =>
                                  {
                                  },
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty
                                          .all(
                                          Colors
                                              .grey),
                                      shape: MaterialStateProperty
                                          .all<
                                          RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius
                                                .circular(
                                                30.0),
                                          ))
                                  ),
                                  child: Text(
                                    tag.Tag_name,
                                  )),
                            ),
                          )).toList(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => SingleAnnouncement(announcement: widget.announcements,)));
      },
      child: Card(
        color: Colors.blue[800],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0)),
        child: SizedBox(
          width: 450.0,
          height: 50.0,
          child: Padding(
            padding: EdgeInsets.all(4.0),
            child: Text(widget.announcements.title),
          ),
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

class _HostelAmenityState extends State<HostelAmenity> {

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0)),
      child: Column(
        children: [
          Center(child: Text(widget.amenities.name)),
          Text(widget.amenities.description),
        ],
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

class _HostelContactsState extends State<HostelContacts> {

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Text(widget.contacts.type)),
          Text(widget.contacts.name),
          Center(
            child: ElevatedButton(
              onPressed: () {
                launch('tel:${widget.contacts.contact}');
              },
                child: Text(widget.contacts.contact)),
          ),
        ],
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

class _EmergencyContactsState extends State<EmergencyContacts> {

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Text(widget.Emergencycontacts.name)),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    launch('tel:${widget.Emergencycontacts.contact}');
                  },
                  child: Text(widget.Emergencycontacts.contact)),
            ),
          ],
        ),
      ),
    );
  }
}



