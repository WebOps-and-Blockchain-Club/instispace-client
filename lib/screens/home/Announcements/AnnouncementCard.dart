import 'package:client/graphQL/announcement_mutations.dart';
import 'package:client/graphQL/announcement_queries.dart';
import 'package:client/graphQL/home.dart';
import 'package:client/screens/home/Announcements/Announcement.dart';
import 'package:client/screens/home/Announcements/home.dart';
import 'package:flutter/material.dart';
import 'package:client/screens/home/Announcements/SingleAnnouncement.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:client/screens/home/Announcements/expand_description.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:client/screens/home/Announcements/edit_announcements.dart';

class AnnouncementCard extends StatefulWidget {
  final Announcement announcement;
  final Future<QueryResult?> Function()? refetchAnnouncement;

  AnnouncementCard(
      {required this.announcement, required this.refetchAnnouncement});

  @override
  _AnnouncementCardState createState() => _AnnouncementCardState();
}

String getMe = homeQuery().getMe;
String getAllAnnouncements = AnnouncementQueries().getAllAnnouncements;
String deleteAnnouncement = AnnouncementMutations().deleteAnnouncement;

var role;
late String Id;
List<String> images = [];
bool isReadmore = false;

class _AnnouncementCardState extends State<AnnouncementCard> {
  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: gql(getMe),
        ),
        builder: (QueryResult result, {fetchMore, refetch}) {
          if (result.hasException) {
            print(result.exception.toString());
          }
          if (result.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.blue[700],
              ),
            );
          }
          role = result.data!["getMe"]["role"];
          Id = result.data!["getMe"]["id"];
          if (widget.announcement.images != null) {
            images = widget.announcement.images!.split(" AND ");
          }
          return Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
            child: SizedBox(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 1,
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 1,
              child: Card(
                color: Colors.blue[800],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SingleAnnouncement(
                                  announcement: Announcement(
                                    title: widget.announcement.title,
                                    description: widget.announcement.description,
                                    endTime: widget.announcement.endTime,
                                    id: widget.announcement.id,
                                    images: widget.announcement.images,
                                    createdByUserId:
                                        widget.announcement.createdByUserId,
                                    hostelIds: widget.announcement.hostelIds,
                                  ),
                                )));
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 0.0),
                        child: Text(
                          widget.announcement.title,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      if (images[0] != "")
                        ClipRect(
                          child: SizedBox(
                            width: 400.0,
                            child: CarouselSlider(
                              items: images
                                  .map((item) => Container(
                                        child: Center(
                                          child: Image.network(
                                            item,
                                            fit: BoxFit.cover,
                                            width: 400,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              options: CarouselOptions(
                                enableInfiniteScroll: false,
                              ),
                            ),
                          ),
                        ),
                      if (images[0] == "")
                        DescriptionTextWidget(
                            text: widget.announcement.description),
                      if (role == "ADMIN" ||
                          role == "HAS" ||
                          Id == widget.announcement.createdByUserId)
                        Row(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blue[700],
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0))),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        EditAnnouncements(
                                          announcement: Announcement(
                                            title: widget.announcement.title,
                                            description:
                                                widget.announcement.description,
                                            endTime: widget.announcement.endTime,
                                            id: widget.announcement.id,
                                            images: widget.announcement.images,
                                            createdByUserId: widget
                                                .announcement.createdByUserId,
                                            hostelIds:
                                                widget.announcement.hostelIds,
                                          ),
                                          refetchAnnouncement: widget.refetchAnnouncement,
                                        )));
                              },
                              child: Text(
                                "Edit Announcement",
                                style:
                                    TextStyle(color: Colors.white, fontSize: 7.0),
                              ),
                            ),
                            Mutation(
                                options: MutationOptions(
                                  document: gql(deleteAnnouncement),
                                ),
                                builder: (
                                  RunMutation runMutation,
                                  QueryResult? result,
                                ) {
                                  if (result!.hasException) {
                                    print(result.exception.toString());
                                  }
                                  if (result.isLoading) {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.blue[700],
                                      ),
                                    );
                                  }
                                  return ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.blue[700],
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0))),
                                    onPressed: () {
                                      runMutation({
                                        'deleteAnnouncementAnnouncementId2':
                                            widget.announcement.id
                                      });
                                      Navigator.pop(context);
                                      widget.refetchAnnouncement!();
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  Announcements()));
                                    },
                                    child: Text(
                                      "Delete Announcement",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 7.0),
                                    ),
                                  );
                                }),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}




// ReadMoreText(
// widget.announcement.description,
// style: TextStyle(
// color: Colors.white
// ),
// trimMode: TrimMode.Line,
// trimLines: 2,
// trimCollapsedText: "Read More",
// trimExpandedText: "Read Less",
// colorClickableText: Colors.red,
// ),


