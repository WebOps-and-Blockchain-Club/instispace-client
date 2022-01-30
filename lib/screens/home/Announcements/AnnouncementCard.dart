import 'package:client/graphQL/home.dart';
import 'package:client/screens/home/Announcements/Announcement.dart';
import 'package:client/screens/home/Announcements/home.dart';
import 'package:flutter/material.dart';
import 'package:client/screens/home/Announcements/SingleAnnouncement.dart';
import 'package:graphql_flutter/graphql_flutter.dart';


class AnnouncementCard extends StatefulWidget {
  final Announcement announcement;
  final Future<QueryResult?> Function()? refetchAnnouncement;

  AnnouncementCard({required this.announcement, required this.refetchAnnouncement});

  @override
  _AnnouncementCardState createState() => _AnnouncementCardState();
}

String getMe = homeQuery().getMe;
String getAllAnnouncements = homeQuery().getAllAnnouncements;
String deleteAnnouncement = homeQuery().deleteAnnouncement;

var role;

class _AnnouncementCardState extends State<AnnouncementCard> {
  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
        document: gql(getMe),),
    builder: (QueryResult result, {fetchMore, refetch}) {
      if (result.hasException) {
        print(result.exception.toString());
      }
      if (result.isLoading) {
        return Center(
          child: CircularProgressIndicator(color: Colors.blue[700],),
        );
      }
      role = result.data!["getMe"]["role"];
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
        child: Card(
          color: Colors.blue[800],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0)
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  SingleAnnouncement(announcement: Announcement(
                    title: widget.announcement.title,
                    description: widget.announcement.description,
                    endTime: widget.announcement.endTime,
                    id: widget.announcement.id,
                    images: widget.announcement.images,
                    hostelIds: widget.announcement.hostelIds,),)));
            },
            child: Column(
              children: [
                ClipRect(
                  child:SizedBox(
                      width: 400.0,
                      child: Image.network(
                          widget.announcement.images, height: 150.0)
                  ),
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  4.0, 0.0, 0.0, 0.0),
                              child: Text(
                                widget.announcement.title,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.w500
                                ),),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "More",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300
                      ),
                    ),
                    Icon(Icons.arrow_drop_down_outlined,
                      color: Colors.white,)
                  ],
                ),
                if (role == "ADMIN" || role == "HAS" )
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
                            child: CircularProgressIndicator(color: Colors.blue[700],),
                          );
                        }
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.blue[700],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0))
                          ),
                          onPressed: () {
                            runMutation({
                              'deleteAnnouncementAnnouncementId2': widget.announcement.id
                            });
                            Navigator.pop(context);
                            widget.refetchAnnouncement!();
                          },
                          child: Text(
                            widget.announcement.endTime,
                            style: TextStyle(color: Colors.white,fontSize: 7.0),
                          ),
                        );
                      }
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

