import 'package:client/graphQL/announcements.dart';
import 'package:client/models/announcementsClass.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../screens/home/HostelSection/Announcements/editAnnouncements.dart';
import 'expandDescription.dart';
import '../screens/home/HostelSection/Announcements/announcements.dart';

import 'package:client/widgets/marquee.dart';

Widget AnnouncementsCards(
    BuildContext context,
    String role,
    String userId,
    Future<QueryResult?> Function()? refetchAnnouncements,
    Announcement announcement,
    ) {

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
                topLeft: Radius.circular(8.5),
                topRight: Radius.circular(8.5)),
          ),
          // color: const Color(0xFF42454D),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ///Title
              Padding(
                //Conditional Padding
                  padding: (userId==announcement.createdByUserId)
                      ? const EdgeInsets.fromLTRB(18, 0, 0, 0)
                      : const EdgeInsets.fromLTRB(18, 10, 0, 10),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: MarqueeWidget(
                      direction: Axis.horizontal,
                      child: Text(
                        capitalize(announcement.title),
                        style: TextStyle(
                          //Conditional Font Size
                          fontWeight: (userId==announcement.createdByUserId)
                              ? FontWeight.w700
                              : FontWeight.bold,
                          //Conditional Font Size
                          fontSize: (userId==announcement.createdByUserId)
                              ? 18
                              : 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
              ),
            ],
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
            padding: const EdgeInsets.all(15),
            child: DescriptionTextWidget(text: announcement.description,),
          ),


        ///Edit Button, delete button
        if (role == "ADMIN" || role == "HAS" || userId == announcement.createdByUserId)
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 1),
            child: Row(
              children: [
                ///Edit Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF42454D),
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    minimumSize: const Size(40,24),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            EditAnnouncements(
                              announcement: Announcement(
                                title: announcement.title,
                                description:
                                announcement.description,
                                endTime: announcement.endTime,
                                id: announcement.id,
                                images: announcement.images,
                                createdByUserId:
                                    announcement.createdByUserId,
                                hostelIds:
                                announcement.hostelIds,
                              ),
                              refetchAnnouncement: refetchAnnouncements,
                            )));
                  },
                  child: const Text(
                    "Edit",
                    style:
                    TextStyle(color: Colors.white, fontSize: 12.0),
                  ),
                ),

                  ///Delete Button
                  if(role == "ADMIN" || role == "HAS" || userId == announcement.createdByUserId)
                Mutation(
                    options: MutationOptions(
                      document: gql(delete),
                    ),
                    builder: (
                        RunMutation runMutation,
                        QueryResult? result,
                        ) {
                      if (result!.hasException) {
                        print(result.exception.toString());
                      }
                      if (result.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF42454D),
                          ),
                        );
                      }
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xFF42454D),
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          minimumSize: const Size(40,24),
                        ),
                        onPressed: () {
                          runMutation({
                            'announcementId':
                           announcement.id
                          });
                          Navigator.pop(context);
                          refetchAnnouncements!();
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const Announcements()));
                        },
                        child: const Text(
                          "Delete",
                          style: TextStyle(
                              color: Colors.white, fontSize: 12.0),
                        ),
                      );
                    }),
              ],
            ),
          ),
      ],
    ),
  );
}

///To capitalize the first letter of Title
String capitalize(String s) => s[0].toUpperCase() + s.substring(1);