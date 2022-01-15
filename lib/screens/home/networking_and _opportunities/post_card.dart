import 'package:client/screens/home/networking_and%20_opportunities/singlepost.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../models/post.dart';
import '../../../models/tag.dart';
import 'package:client/screens/home/networking_and _opportunities/comments.dart';


class PostCard extends StatelessWidget {
  final Post post;

  PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    List<Tag>tags =post.tags;
    return Card(
      elevation: 5.0,
      color: Color(0xFFF9F6F2),
      child: InkWell(
          highlightColor: Colors.white30,
          onTap: () =>
          {
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Single_Post(post:post)),
          ),
            print('tapped')
          },
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(onPressed: () =>
                        {
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
                          width: 360.0,
                          height: 30.0,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              Row(
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
                                  )).toList()
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ]
            ),
          )
          )
          );
  }
}
