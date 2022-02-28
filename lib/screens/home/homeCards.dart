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
  final Future<QueryResult?> Function()? refetchPosts;
  EventsHomeCard({required this.events,required this.refetchPosts});
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
  late DateTime createdAt;


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
      createdAt = DateTime.parse(result.data!['getEvent']['createdAt']);
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
        child: EventsCard(context, refetch, widget.refetchPosts,createdAt, tags,values, userId,values.createdById),
      );
    }
    );
  }
}



class NetOpHomeCard extends StatefulWidget {
  final NetOpPost netops;
  final Future<QueryResult?> Function()? refetchPosts;
  NetOpHomeCard({required this.netops, required this.refetchPosts});

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
  late DateTime createdAt;
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
    createdAt = DateTime.parse(result.data!['getNetop']['createdAt']);
    userId = result.data!["getMe"]["id"];
    createdById = result.data!["getNetop"]["createdBy"]["id"];
    var values = widget.netops;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0,0,0,10.0),
      child: NetopsCard(context, refetch, widget.refetchPosts, isStared,isLiked,likeCount,createdAt, tags, userId,createdById,noUse, values,'HomePage'),
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

  List<String>? images;
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
              child: AnnouncementsCards(context,'','',refetch,widget.announcements,'homePage'),
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
        color: const Color(0xFFDEDDFF),
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
                        fontSize: 15.5,
                        fontWeight: FontWeight.w500,
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
                      fontSize: 15,
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
        color: const Color(0xFFDEDDFF),
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
                          primary: const Color(0xFF6B7AFF),
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
        color: const Color(0xFFDEDDFF),
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
                      primary: const Color(0xFF6B7AFF),
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



