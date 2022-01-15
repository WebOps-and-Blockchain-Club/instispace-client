import 'package:client/screens/home/Events/post_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'addpost.dart';
import 'post.dart';
import 'post_card.dart';

class EventsHome extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<EventsHome> {
  List<Post> posts = [
    Post(
        title: "Title1",
        location: "OAT1",
        description:
            "Anshul is not a good boy. He is from Chemical Engineering Department. ngjngnfvjntnbjscnjnrjgvnjcn f vjnjbnsgvnb fnmb gbgjbn fg bkfgdjnbjgbngsjkrn bjnrjbn njbnjktnbjn bknbkjnjkbn jkn btrn jkrtnb jkrt",
        imgUrl: "http://im.rediff.com/money/2011/nov/29iit1.jpg",
        formLink:
            "https://hss.iitm.ac.in/wp-content/uploads/2018/12/DJ-Logo.jpg"),
    Post(
        title: "Title2",
        location: "SAC1",
        description:
            "Janith is also not a good boy. He is from Chemical Engineering Department. ngjngnfvjntnbjscnjnrjgvnjcn f vending numb gob fg bkfgdjnbjgbngsjkrn bjnrjbn njbnjktnbjn bknbkjnjkbn jkn btrn jkrtnb jkrt",
        imgUrl:
            "data:image/jpeg;base64,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",
        formLink:
            "https://hss.iitm.ac.in/wp-content/uploads/2018/12/DJ-Logo.jpg"),
    Post(
        title: "Title3",
        location: "OAT2",
        description:
            "Yatharth is a good boy. He is from Biotech Department. ngjngnfvjntnbjscnjnrjgvnjcn f vending numb gob fg bkfgdjnbjgbngsjkrn bjnrjbn njbnjktnbjn bknbkjnjkbn jkn btrn jkrtnb jkrt",
        imgUrl:
            "https://static.toiimg.com/thumb/msid-73226031,width-1200,height-900,resizemode-4/.jpg",
        formLink:
            "https://hss.iitm.ac.in/wp-content/uploads/2018/12/DJ-Logo.jpg"),
    Post(
        title: "Title4",
        location: "SAC2",
        description:
            "Janith is a good boy. He is from Chemical Engineering Department. ngjngnfvjntnbjscnjnrjgvnjcn f vjnjbnsgvnb fnmb gbgjbn fg bkfg",
        imgUrl: "https://hss.iitm.ac.in/wp-content/uploads/2018/12/DJ-Logo.jpg",
        formLink:
            "https://hss.iitm.ac.in/wp-content/uploads/2018/12/DJ-Logo.jpg")
  ];

  var ScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ScaffoldKey,
      appBar: AppBar(
        title: Text(
          "All Events",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 20.0),
        ),
        actions: [
          IconButton(
              onPressed: () => ScaffoldKey.currentState?.openEndDrawer(),
              icon: Icon(Icons.filter_alt_outlined)),
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => AddPostEvents()));
              },
              icon: Icon(Icons.add_box))
        ],
        backgroundColor: Colors.blue[900],
        elevation: 0.0,
      ),
      backgroundColor: Colors.grey[300],
      body: Container(
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter,
        //     stops: [
        //       0.1,
        //       0.3,
        //       04,
        //       0.6,
        //       0.9
        //     ],
        //     colors: [
        //       Colors.purpleAccent,
        //       Colors.blue,
        //       Colors.lightBlueAccent,
        //       Colors.lightBlueAccent,
        //       Colors.blueAccent
        //     ]
        //   )
        // ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5.0,10.0,5.0,0.0),
          child: ListView(
            children: [
              Column(
                children: posts.map((post) => PostCard(
                  post: post,
                  index: posts.indexOf(post),
                )).toList(),
              ),
            ],
          ),
        ),
      ),
      endDrawer: Drawer(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  child: SizedBox(
                    height: 250.0,
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
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
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
