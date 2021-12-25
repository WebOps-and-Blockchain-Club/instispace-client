import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'post.dart';



class SinglePost extends StatelessWidget {
  final Post post;
  SinglePost({required this.post});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          post.title,
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
            Image.network(post.imgUrl,height: 255.0),
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(2.0,0.0,0.0,0.0),
                  child: RaisedButton(
                    onPressed: () {},
                    child: Text("Tag 1",
                      style: TextStyle(
                          color: Colors.white
                      ),),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)
                    ),
                    color: Colors.grey,),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(2.0,0.0,0.0,0.0),
                  child: RaisedButton(
                    onPressed: () {},
                    child: Text("Tag 2",
                      style: TextStyle(
                          color: Colors.white
                      ),),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)
                    ),
                    color: Colors.grey,),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(2.0,0.0,0.0,0.0),
                  child: RaisedButton(
                    onPressed: () {},
                    child: Text("Tag 3",
                      style: TextStyle(
                          color: Colors.white
                      ),),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)
                    ),
                    color: Colors.grey,),
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
            RaisedButton(
              onPressed: () => {},
              child: Text("Know More"),
              color: Color(0xFFE6CCA9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1500.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}
