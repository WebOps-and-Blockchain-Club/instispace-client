import 'package:client/graphQL/netops.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../models/post.dart';
import 'package:client/models/commentclass.dart';

class Comments extends StatefulWidget {
  final Post post;
  Comments({required this.post});

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  TextEditingController commentController = TextEditingController();
  @override
  void dispose(){
    commentController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    List<Comment> comments = widget.post.comments;
    String createComments =netopsQuery().createComment;
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
                            // child: CircleAvatar(
                            //   radius: 50.0,
                            //   backgroundImage: NetworkImage(comment.profile_pic_url),
                            // ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Column(
                            children: [
                              // Text(
                              //   comment.id,
                              //   style: TextStyle(
                              //     fontSize: 20.0,
                              //     fontWeight: FontWeight.bold,
                              //   ),
                              // ),
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
                    controller: commentController,
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'write a comment'
                    ),
                  ),
                ),
              ),
              Mutation(
                options: MutationOptions(
                  document: gql(createComments)
                ),
                builder: (
                    RunMutation runMutation,
                    QueryResult? result,
                    ){
                  if (result!.hasException){
                    print(result.exception.toString());
                  }
                  if(result.isLoading){}
                  return IconButton(onPressed: (){
                    print(widget.post.id);
                    runMutation(
                      {
                        "content":commentController.text,
                        "netopId":widget.post.id,
                      }
                    );
                    setState(() {

                    });
                  }, icon: Icon(Icons.send));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
