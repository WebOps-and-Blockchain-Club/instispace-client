import 'package:carousel_slider/carousel_slider.dart';
import 'package:client/graphQL/events.dart';
import 'package:client/models/tag.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'post.dart';



class SinglePost extends StatelessWidget {
  final Post post;
  String toggleStar=eventsQuery().toggleStar;
  bool isStarred;
  Future<QueryResult?> Function()? refetch;
  SinglePost({required this.post,required this.refetch,required this.isStarred,});
  @override
  Widget build(BuildContext context) {

    List<Tag> tag = post.tags;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(5.0,0.0,5.0,2.0),
        child: Column(
          children: [
            if(post.imgUrl.isNotEmpty)
              CarouselSlider(
                items: post.imgUrl.map((item) => Container(
                  child: Center(
                    child: Image.network(item,fit: BoxFit.cover,width: 400,),
                  ),
                )
                ).toList(),
                options: CarouselOptions(
                  enableInfiniteScroll: false,
                ),
              ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(onPressed: () => {}, icon: Icon(Icons.arrow_circle_up_outlined)),
                IconButton(onPressed: () => {}, icon: Icon(Icons.access_alarm)),
                IconButton(onPressed: () => {}, icon: Icon(Icons.share))
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 240.0,
                  height: 30.0,
                  child: ListView(
                    scrollDirection: Axis
                        .horizontal,
                    children: tag.map((tag) =>
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
                    Text(
                      post.description,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                      ),
                    ),
                  ]
              ),
            ),
            if(post.linkToAction!=null && post.linkToAction != "")
            ElevatedButton(
              onPressed: () => {
                launch(post.linkToAction!)
              },
              child: Text(post.linkName),
            )
          ],
        ),
      ),
    );
  }
}
