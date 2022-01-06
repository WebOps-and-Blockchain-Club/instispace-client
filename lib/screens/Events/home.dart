import 'package:client/screens/Events/addpost.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'post.dart';
import 'post_card.dart';

class EventsHome extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<EventsHome> {

  List<Post> posts =[Post(title: "Title1", location: "OAT", description: "Anshul is a good boy. He is from Chemical Engineering Department. ngjngnfvjntnbjscnjnrjgvnjcn f vjnjbnsgvnb fnmb gbgjbn fg bkfgdjnbjgbngsjkrn bjnrjbn njbnjktnbjn bknbkjnjkbn jkn btrn jkrtnb jkrt", imgUrl: "https://hss.iitm.ac.in/wp-content/uploads/2018/12/DJ-Logo.jpg", formLink: "https://hss.iitm.ac.in/wp-content/uploads/2018/12/DJ-Logo.jpg"),
    Post(title: "Title1", location: "OAT", description: "Anshul is a good boy. He is from Chemical Engineering Department. ngjngnfvjntnbjscnjnrjgvnjcn f vjnjbnsgvnb fnmb gbgjbn fg bkfgdjnbjgbngsjkrn bjnrjbn njbnjktnbjn bknbkjnjkbn jkn btrn jkrtnb jkrt", imgUrl: "https://hss.iitm.ac.in/wp-content/uploads/2018/12/DJ-Logo.jpg", formLink: "https://hss.iitm.ac.in/wp-content/uploads/2018/12/DJ-Logo.jpg"),
    Post(title: "Title1", location: "OAT", description: "Anshul is a good boy. He is from Chemical Engineering Department. ngjngnfvjntnbjscnjnrjgvnjcn f vjnjbnsgvnb fnmb gbgjbn fg bkfgdjnbjgbngsjkrn bjnrjbn njbnjktnbjn bknbkjnjkbn jkn btrn jkrtnb jkrt", imgUrl: "https://hss.iitm.ac.in/wp-content/uploads/2018/12/DJ-Logo.jpg", formLink: "https://hss.iitm.ac.in/wp-content/uploads/2018/12/DJ-Logo.jpg"),
    Post(title: "Title1", location: "OAT", description: "Anshul is a good boy. He is from Chemical Engineering Department. ngjngnfvjntnbjscnjnrjgvnjcn f vjnjbnsgvnb fnmb gbgjbn fg bkfgdjnbjgbngsjkrn bjnrjbn njbnjktnbjn bknbkjnjkbn jkn btrn jkrtnb jkrt", imgUrl: "https://hss.iitm.ac.in/wp-content/uploads/2018/12/DJ-Logo.jpg", formLink: "https://hss.iitm.ac.in/wp-content/uploads/2018/12/DJ-Logo.jpg")];

  var ScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ScaffoldKey,
      appBar: AppBar(
        title: Text("All Events",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),),
        actions: [
          IconButton(onPressed: () =>
                ScaffoldKey.currentState?.openEndDrawer(),
                icon: Icon(Icons.filter_alt_outlined)
         ),
          IconButton(
              onPressed: () {
           Navigator.of(context).push(
           MaterialPageRoute(
           builder: (BuildContext context)=> AddPostEvents()));
              }, icon: Icon(Icons.add_box))
        ],
        backgroundColor: Color(0xFFE6CCA9),
      ),
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: ListView(
          children: [ Column(children: posts
              .map((post) => PostCard(
            post: post,
            index: posts.indexOf(post),
          ))
              .toList(),
          ),
          ],
        ),
      ),
      endDrawer: Drawer(
          child: Container(
            color: Color(0xFFF9F6F2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0,10.0,10.0,10.0),
                  child: SizedBox(
                    height: 280.0,
                    child: Text(
                      "Sort By",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0,0.0,10.0,0.0),
                  child: SizedBox(
                    height: 280.0,
                    child: Text(
                      "Filter",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }
}