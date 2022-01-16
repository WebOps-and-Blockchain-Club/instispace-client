import 'package:client/screens/home/networking_and%20_opportunities/singlepost.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../models/post.dart';
import '../../../models/tag.dart';
import 'package:client/screens/home/networking_and _opportunities/comments.dart';
import 'package:expandable/expandable.dart';
import 'package:intl/intl.dart';


class PostCard extends StatelessWidget {
  final Post post;

  PostCard({required this.post});

  @override
  Widget build(BuildContext context) {

    List<Tag>tags =post.tags;
    DateTime dateTime = DateTime.parse(post.endTime);
    final format = DateFormat.jm();
    final format1 =DateFormat.yMMMMd('en_US');
    final date= format1.format(dateTime);
    final time =format.format(dateTime);
    // print("date : $date");
    // print("time: $time");
    return ExpandableNotifier(
      child: ScrollOnExpand(
        child: ExpandablePanel(
          theme: ExpandableThemeData(
            tapBodyToCollapse: true,
            tapBodyToExpand: true,
          ),
          expanded: SizedBox(
            height: MediaQuery.of(context).size.height*1,
              width: MediaQuery.of(context).size.width*1,
              child: Single_Post(post:post)),
          collapsed: Card(
            clipBehavior: Clip.antiAlias,
            elevation: 5.0,
            color: Color(0xFFF9F6F2),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0 , 10.0, 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  post.title,
                                   style: TextStyle(
                                   fontSize: 20,
                                   color: Colors.black,
                              ),
                              ),
                              IconButton(onPressed: () =>
                              {
                                print('starred')
                              }, icon: Icon(Icons.star_border)),
                            ],
                          ),
                          if(post.imgUrl.isEmpty)
                          Text(
                            post.description.length >250? post.description.substring(0,250)+'...' : post.description,
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                          ),
                          if(post.imgUrl.isNotEmpty)
                          SizedBox(
                          width: 400.0,
                          child: Image.network(post.imgUrl, height: 150.0)
                          ),
                          Row(
                            children: [
                              Column(
                                children: [
                                  Row(

                                    children: [
                                      IconButton(onPressed: () =>
                                      {
                                        print(dateTime),
                                        print('shared')
                                      }, icon: Icon(Icons.share)),
                                      IconButton(onPressed: () =>
                                      {
                                        print('remainder added')
                                      }, icon: Icon(Icons.access_alarm)),
                                      IconButton(onPressed: () =>
                                      {
                                        print('liked')
                                      }, icon: Icon(Icons.arrow_circle_up_outlined)),
                                      IconButton(onPressed: () =>
                                      {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => Comments(post: post,)),
                                        ),
                                        print('commented'),
                                      }, icon: Icon(Icons.comment)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 240.0,
                                        height: 30.0,
                                        child: ListView(
                                          scrollDirection: Axis.horizontal,
                                          children: tags.map((tag) => SizedBox(
                                            height:25.0,
                                            child: Padding(
                                              padding: const EdgeInsets.fromLTRB(2.0,0.0,2.0,0.0),
                                              child: ElevatedButton(onPressed:()=>{},
                                                  style: ButtonStyle(
                                                      backgroundColor: MaterialStateProperty.all(Colors.grey),
                                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(30.0),
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
                                ],
                              ),
                              SizedBox(
                                  width: 120,
                                  height: 50,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                        borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(2.0, 8.0, 8.0, 0.0),
                                      child: Column(
                                        children: [
                                          Text(time),
                                          Text(date),
                                        ],
                                      ),
                                    ),
                                  )
                              )
                            ],
                          ),

                        ],
                      ),
                    ]
                  ),
                )
                ),
          builder: (_,collapsed,expanded)=> Expandable(collapsed: collapsed, expanded: expanded,)
                ),
      ),
      // ),
    );
  }
}
