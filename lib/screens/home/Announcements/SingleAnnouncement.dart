import 'package:client/screens/home/Announcements/Announcement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';

class SingleAnnouncement extends StatelessWidget {
  final Announcement announcement;
  SingleAnnouncement({required this.announcement});

  @override
  Widget build(BuildContext context) {
    var endtime = dateTimeString(announcement.endTime);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image.network(announcement.image,height: 255.0),
            // SizedBox(height: 10.0),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     IconButton(onPressed: () => {}, icon: Icon(Icons.arrow_circle_up_outlined)),
            //     IconButton(onPressed: () => {}, icon: Icon(Icons.access_alarm)),
            //     IconButton(onPressed: () => {}, icon: Icon(Icons.share))
            //   ],
            // ),
            Column(
              children: [
                SizedBox(height: 20.0),
                Text(
                  "Details",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.0),
                SizedBox(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.70,
                  child : ListView(
                      children: [
                        MarkdownBody(
                        data: announcement.description,
                        shrinkWrap: true,
                      ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(endtime,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12
                            ),),
                          ],
                        ),
                      ]),
                ),
              ],
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: ElevatedButton(
                onPressed: () => {},
                child: Text("Know More",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF6B7AFF),
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  minimumSize: Size(50, 35),
                ),
              ),
            )
            ]
        ),
    )
    );
  }
  String dateTimeString(String utcDateTime) {
    if (utcDateTime == "") {
      return "";
    }
    var parseDateTime = DateTime.parse(utcDateTime);
    final localDateTime = parseDateTime.toLocal();

    var dateTimeFormat = DateFormat("dd-MMM-yyyy hh:mm aaa");

    return dateTimeFormat.format(localDateTime);
  }
}
