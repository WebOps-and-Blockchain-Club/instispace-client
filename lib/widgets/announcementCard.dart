import 'package:carousel_slider/carousel_slider.dart';
import 'package:client/graphQL/announcement_mutations.dart';
import 'package:client/screens/home/Announcements/Announcement.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../screens/home/Announcements/edit_announcements.dart';
import '../screens/home/Announcements/expand_description.dart';
import '../screens/home/Announcements/home.dart';

Widget AnnouncementsCards(
    BuildContext context,
    List<String> images,
    String role,
    String userId,
    Future<QueryResult?> Function()? refetchAnnouncements,
    Announcement announcement,
    String page
    ) {

  String delete = AnnouncementMutations().deleteAnnouncement;
  return Card(
    color: const Color(0xFFFFFFFF),
    elevation: 3,
    borderOnForeground: true,
    shadowColor: Colors.black54,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.5)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 10.0, 0.0, 0.0),
          child: Text(
            announcement.title,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.w700),
          ),
        ),
        if (images[0] != "")
          ClipRect(
            child: SizedBox(
              width: 400.0,
              child: CarouselSlider(
                items: images
                    .map((item) => Center(
                      child: Image.network(
                        item,
                        fit: BoxFit.cover,
                        width: 400,
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
          DescriptionTextWidget(text: announcement.description,),
        if(page == 'announcementsSection')
        if (role == "ADMIN" || role == "HAS" || userId == announcement.createdByUserId)
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 1),
            child: Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF6464DA),
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
                if (page == 'announcementsSection')
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
                            color: Color(0xFF6464DA),
                          ),
                        );
                      }
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xFF6464DA),
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