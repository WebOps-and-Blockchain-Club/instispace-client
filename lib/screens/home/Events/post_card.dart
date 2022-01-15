import 'package:client/screens/home/Events/singlepost.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'post.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final num index;
  PostCard({required this.post,required this.index});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0,0.0,0.0,10.0),
      child: Card(
        color: Colors.blue[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0)
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SinglePost(post: Post(title: post.title, location: post.location, description: post.description, imgUrl: post.imgUrl, formLink: post.formLink),)));
            print("tapped");
          },
          child: Column(
            children: [
              ClipRect(
                child: Container(
                  height: 250.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(15.0),topLeft: Radius.circular(15.0)),
                    image: DecorationImage(
                      image: NetworkImage(post.imgUrl),
                      fit: BoxFit.fill,
                    )
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Container(
                          width: 30.0,
                          height: 30.0,
                          child: IconButton(icon: Icon(Icons.star_border), onPressed: () {print("Liked");},iconSize: 15.0,),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: Colors.white
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4.0,0.0,0.0,0.0),
                            child: Text(
                              post.title,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.w500
                              ),),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(4.0),
                                child: ElevatedButton(
                                  onPressed: () {},
                                  child: Text(
                                    "Tag1",
                                    style: TextStyle(
                                      color: Colors.indigo,
                                      fontSize: 10.0
                                    ),),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(4.0),
                                child: ElevatedButton(
                                  onPressed: () {},
                                  child: Text(
                                    "Tag2",
                                    style: TextStyle(
                                      color: Colors.indigo,
                                      fontSize: 10.0
                                    ),),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(4.0),
                                child: ElevatedButton(
                                  onPressed: () {},
                                  child: Text(
                                    "Tag3",
                                    style: TextStyle(
                                      color: Colors.indigo,
                                      fontSize: 10.0
                                    ),),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4.0,4.0,20.0,4.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.blue[100]
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Column(
                              children: [
                                Text(post.location,style: TextStyle(color: Colors.indigo,fontWeight: FontWeight.w600),),
                                Text("24 Dec | 15:00",
                                  style: TextStyle(
                                    color: Colors.indigo,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      "More",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300
                    ),
                  ),
                  Icon(Icons.arrow_drop_down_outlined,color: Colors.white,)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}


// Card(
// shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(10.0)
// ),
// color: Colors.indigo,
// elevation: 5.0,
// child: InkWell(
// highlightColor: Colors.white30,
// onTap: () =>
// {
// Navigator.pushNamed(context, '/singlepost'),
// print("Tapped")
// },
// child: Container(
// child: Column(
// children: [
// Container(
// height: 275.0,
// decoration: BoxDecoration(
// image: DecorationImage(
// image: NetworkImage(post.imgUrl),
// fit: BoxFit.cover
// )
// ),
// child: Row(
// mainAxisAlignment: MainAxisAlignment.end,
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Padding(
// padding: const EdgeInsets.all(4.0),
// child: Container(
// child: IconButton(onPressed: () => {print("Liked")}, icon: Icon(Icons.star_border)),
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(30.0),
// color: Colors.white
// ),
// ),
// )
// ],
// ),
// ),
// Row(
// children: [
// Column(
// children: [
// Text(
// post.title,
// style: TextStyle(
// color: Colors.white,
// fontSize: 30.0
// ),
// ),
// Row(
// mainAxisAlignment: MainAxisAlignment.start,
// children: [
// Padding(
// padding: const EdgeInsets.fromLTRB(2.0,0.0,0.0,0.0),
// child: ElevatedButton(
// onPressed: () {},
// child: Text("Tag 1",
// style: TextStyle(
// color: Colors.indigo
// ),),
// style: ElevatedButton.styleFrom(
// primary: Colors.white,
// ),
// ),
// ),
// Padding(
// padding: const EdgeInsets.fromLTRB(2.0,0.0,0.0,0.0),
// child: ElevatedButton(
// onPressed: () {},
// child: Text("Tag 2",
// style: TextStyle(
// color: Colors.indigo
// ),),
// style: ElevatedButton.styleFrom(
// primary: Colors.white,
// ),
// ),
// ),
// Padding(
// padding: const EdgeInsets.fromLTRB(2.0,0.0,0.0,0.0),
// child: ElevatedButton(
// onPressed: () {},
// child: Text("Tag 3",
// style: TextStyle(
// color: Colors.indigo
// ),),
// style: ElevatedButton.styleFrom(
// primary: Colors.white,
// ),
// ),
// )
// ],
// ),
// ],
// ),
// Column(
// children: [
// Padding(
// padding: const EdgeInsets.all(8.0),
// child: Container(
// decoration: BoxDecoration(
// color: Colors.cyan,
// borderRadius: BorderRadius.circular(10.0)
// ),
// child: Padding(
// padding: EdgeInsets.all(5.0),
// child: Column(
// children: [
// Padding(
// padding: const EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 5.0),
// child: Text(
// post.location,
// style: TextStyle(
// color: Colors.indigo,
// fontSize: 15.0,
// fontWeight: FontWeight.bold
// ),
// ),
// ),
// Text("24 Dec | 15:00",
// style: TextStyle(
// color: Colors.indigo,
// fontSize: 15.0,
// fontWeight: FontWeight.bold
// ),),
// ],
// ),
// ),
// ),
// ),
// ],
// )
// ],
// ),
// Container(
// width: 500.0,
// child: RaisedButton.icon(
// onPressed: () {  },
// icon: Icon(Icons.arrow_drop_down),
// label: Text("More details"),
// color: Colors.indigo,
// ),
// ),
// ]
// ),
// ),
// ),
// );