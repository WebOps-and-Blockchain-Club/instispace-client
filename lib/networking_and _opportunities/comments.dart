import 'package:flutter/material.dart';
import 'post.dart';
import 'commentclass.dart';

class Comments extends StatelessWidget {
  final Post post;
  Comments({required this.post});
  @override
  Widget build(BuildContext context) {
    List<Comment> comments = post.comments;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Comments'),
          backgroundColor:Color(0xFFE6CCA9),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 570.0,
            width: 400.0,
            child: ListView(
              children: [
                Column(
                  children : comments.map((comment) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Row(
                        children: [
                          Container(
                            height: 50.0,
                            width: 50.0,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.all(Radius.circular(50.0)),
                            ),
                            child: CircleAvatar(
                              radius: 50.0,
                              backgroundImage: NetworkImage(comment.profile_pic_url),
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Column(
                            children: [
                              Text(
                                comment.Name,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                comment.message,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )).toList(),
                )
              ],
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(4.0, 0.0, 2.0, 0.0),
                child: Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  ),
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundImage: NetworkImage('https://images.unsplash.com/photo-1638975983437-2f5fea7540da?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=388&q=80'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 16),
                child: SizedBox(
                  width: 270.0,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'write a comment'
                    ),
                  ),
                ),
              ),
              IconButton(onPressed: ()=>{}, icon: Icon(Icons.send))
            ],
          ),
        ],
      ),
    );
  }
}
