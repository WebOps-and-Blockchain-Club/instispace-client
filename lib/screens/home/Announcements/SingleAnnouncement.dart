import 'package:client/screens/home/Announcements/Announcement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart';

class SingleAnnouncement extends StatelessWidget {
  final Announcement announcement;
  SingleAnnouncement({required this.announcement});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          announcement.title,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFE6CCA9),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(5.0,0.0,5.0,2.0),
        child: Column(
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
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(2.0,0.0,0.0,0.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text("Tag 1",
                      style: TextStyle(
                          color: Colors.white
                      ),),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(2.0,0.0,0.0,0.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text("Tag 2",
                      style: TextStyle(
                          color: Colors.white
                      ),),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(2.0,0.0,0.0,0.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text("Tag 3",
                      style: TextStyle(
                          color: Colors.white
                      ),),
                  ),
                )
              ],
            ),
            SizedBox(height: 10.0),
            Text("Description",
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            SizedBox(
              height: 150.0,
              child: ListView(
                  children: [
                    MarkdownBody(
                      data: announcement.description,
                      shrinkWrap: true,
                    ),
                  ]
              ),
            ),
            ElevatedButton(
              onPressed: () => {},
              child: Text("Know More"),
            )
          ],
        ),
      ),
    );
  }
}
