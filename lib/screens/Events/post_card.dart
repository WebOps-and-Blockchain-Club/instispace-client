import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'post.dart';
import 'singlepost.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final num index;
  PostCard({required this.post,required this.index});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0,0.0,5.0,5.0),
      child: Card(
        color: Color(0xFFF9F6F2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(post.imgUrl,height: 200.0),
            SizedBox(
              height: 6.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 5.0),
                  child: Text(
                    post.title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30.0,
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(onPressed: () => {}, icon: Icon(Icons.arrow_circle_up_outlined)),
                    IconButton(onPressed: () => {}, icon: Icon(Icons.access_alarm)),
                    IconButton(onPressed: () => {}, icon: Icon(Icons.share))
                  ],
                )
              ],
            ),
            SizedBox(
              height: 6.0,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
              child: Flexible(
                child: Text(
                  post.description,
                  overflow: TextOverflow.ellipsis,
                  // trimLines: 2,
                  // trimMode: TrimMode.Line,
                  // trimCollapsedText: "Read More",
                  // trimExpandedText: "Read Less",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 5.0),
                  child: Text(
                    post.location,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 6.0,
                ),
                Text("24 Dec | 15:00",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                  ),),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
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
            ButtonBar(
              alignment: MainAxisAlignment.start,
              children: [
                TextButton(
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SinglePost(post:post)),
                      ),
                    },
                    child: Text(
                      'More Details',
                    )
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}