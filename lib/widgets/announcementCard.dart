import 'package:client/graphQL/announcements.dart';
import 'package:client/models/announcementsClass.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../screens/home/hostelSection/announcements/editAnnouncements.dart';
import 'expandDescription.dart';
import '../screens/home/hostelSection/announcements/announcements.dart';

import 'package:client/widgets/marquee.dart';

Widget AnnouncementsCards(
    BuildContext context,
    String role,
    String userId,
    Future<QueryResult?> Function()? refetchAnnouncements,
    Announcement announcement,
    int? hostelNumber) {
  ///GraphQL
  String delete = AnnouncementQM().deleteAnnouncement;

  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.5),
    ),
    color: const Color(0xFFFFFFFF),
    elevation: 3,
    borderOnForeground: true,
    shadowColor: Colors.black54,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ///Title Container
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFF42454D),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.5), topRight: Radius.circular(8.5)),
          ),
          // color: const Color(0xFF42454D),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ///Title
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: MarqueeWidget(
                        direction: Axis.horizontal,
                        child: Text(
                          capitalize(announcement.title),
                          style: TextStyle(
                            //Conditional Font Size
                            fontWeight: (userId == announcement.createdByUserId)
                                ? FontWeight.w700
                                : FontWeight.bold,
                            //Conditional Font Size
                            fontSize: (userId == announcement.createdByUserId)
                                ? 18
                                : 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )),

                ///Edit Button, delete button
                if (role == "ADMIN" ||
                    role == "HAS" ||
                    userId == announcement.createdByUserId)
                  Row(
                    children: [
                      ///Edit Button
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  EditAnnouncements(
                                    announcement: Announcement(
                                      title: announcement.title,
                                      description: announcement.description,
                                      endTime: announcement.endTime,
                                      id: announcement.id,
                                      images: announcement.images,
                                      createdByUserId:
                                          announcement.createdByUserId,
                                      hostelIds: announcement.hostelIds,
                                      hostelNames: announcement.hostelNames,
                                    ),
                                    refetchAnnouncement: refetchAnnouncements,
                                  )));
                        },
                        icon: const Icon(Icons.edit_outlined),
                        color: Colors.white,
                        iconSize: 20,
                      ),

                      ///Delete Button
                      Mutation(
                          options: MutationOptions(document: gql(delete)),
                          builder: (
                            RunMutation runMutation,
                            QueryResult? result,
                          ) {
                            if (result!.hasException) {
                              print(result.exception.toString());
                            }
                            if (result.isLoading) {
                              return Center(
                                  child:
                                      LoadingAnimationWidget.threeRotatingDots(
                                color: Colors.white,
                                size: 20,
                              ));
                            }
                            return IconButton(
                              onPressed: () {
                                runMutation(
                                    {'announcementId': announcement.id});
                                Navigator.pop(context);
                                refetchAnnouncements!();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const Announcements()));
                              },
                              icon: const Icon(Icons.delete_outline),
                              color: Colors.white,
                              iconSize: 20,
                            );
                          }),
                    ],
                  ),
              ],
            ),
          ),
        ),

        // if (images != null)
        //   ClipRect(
        //     child: SizedBox(
        //       width: 400.0,
        //       child: CarouselSlider(
        //         items: images
        //             .map((item) => Center(
        //               child: Image.network(
        //                 item,
        //                 fit: BoxFit.cover,
        //                 width: 400,
        //               ),
        //             ))
        //             .toList(),
        //         options: CarouselOptions(
        //           enableInfiniteScroll: false,
        //         ),
        //       ),
        //     ),
        //   ),

        ///Description
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
          child: DescriptionTextWidget(
            text: announcement.description,
          ),
        ),

        if (role == "ADMIN" ||
            role == "HAS" ||
            userId == announcement.createdByUserId)
          if (announcement.hostelNames.length == hostelNumber)
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
              child: Wrap(children: [
                ElevatedButton(
                  onPressed: () => {},
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                    child: Text(
                      "All hostels",
                      style: TextStyle(
                        color: Color(0xFF2B2E35),
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: const Color(0xFFDFDFDF),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 6),
                      minimumSize: const Size(35, 30)),
                ),
              ]),
            ),

        ///Hostel Names
        if (role == "ADMIN" ||
            role == "HAS" ||
            userId == announcement.createdByUserId)
          if (announcement.hostelNames.length != hostelNumber)
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
              child: Wrap(
                children: announcement.hostelNames
                    .map((hostelName) => SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 5, 5),
                            child: ElevatedButton(
                              onPressed: () => {},
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                                child: Text(
                                  hostelName,
                                  style: const TextStyle(
                                    color: Color(0xFF2B2E35),
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: const Color(0xFFDFDFDF),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  // side: BorderSide(color: Color(0xFF2B2E35)),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 6),
                                  minimumSize: const Size(35, 30)),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
      ],
    ),
  );
}

String capitalize(String s) {
  if (s != "") {
    return s[0].toUpperCase() + s.substring(1);
  } else {
    return s;
  }
}
