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
        padding: const EdgeInsets.fromLTRB(15.0,0.0,15.0,5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Images
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
            //Icons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => {},
                  icon: Icon(Icons.arrow_circle_up_outlined),
                  iconSize: 24,
                  color: Color(0xFF021096),
                ),
                IconButton(
                  onPressed: () => {},
                  icon: Icon(Icons.access_alarm),
                  iconSize: 24,
                  color: Color(0xFF021096),
                ),
                IconButton(
                  onPressed: () => {},
                  icon: Icon(Icons.share),
                  iconSize: 24,
                  color: Color(0xFF021096),
                )
              ],
            ),
            SizedBox(height: 10.0),
            //Tags
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 240.0,
                  height: 30.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: tag.map((tag) =>
                        SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(2.0, 0.0, 2.0, 0.0),
                            child: ElevatedButton(
                              onPressed: () => {},
                              child: Text(
                                tag.Tag_name,
                                style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFF808CFF),
                                padding: EdgeInsets.symmetric(
                                    vertical: 2,
                                    horizontal: 6),
                              ),
                            ),
                          ),
                        )).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 25.0),
            Text("Description",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF021096),
              ),
            ),
            SizedBox(height: 10.0),
            //Description Text
            SizedBox(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.6,
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
              child: Text(post.linkName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 14
              ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF6B7AFF),
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                minimumSize: Size(50, 35),
              ),
            )
          ],
        ),
      ),
    );
  }
}
