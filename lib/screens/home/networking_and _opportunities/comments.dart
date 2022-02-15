import 'package:client/graphQL/netops.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../models/post.dart';
import 'package:client/models/commentclass.dart';

class Comments extends StatefulWidget {
  final NetOpPost post;
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
  String getNetop= netopsQuery().getNetop;
  @override
  Widget build(BuildContext context) {
    List<Comment> comments = [];
    String createComments =netopsQuery().createComment;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Comments',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),),
        backgroundColor:Color(0xFF5451FD),
      ),

      body: Query(
        options:QueryOptions(
          document: gql(getNetop),
          variables: {"getNetopNetopId":widget.post.id}
        ),
        builder: (QueryResult result, {fetchMore, refetch}){
          comments.clear();
          if (result.hasException) {
            print(result.exception.toString());
            return Text(result.exception.toString());
          }
          for(var j=0;j<result.data!["getNetop"]["comments"].length;j++){
            // print("message: ${netopList[i]["comments"][j]["content"]}, id: ${netopList[i]["comments"][j]["id"]}");
            comments.add(
                Comment(
                  message: result.data!["getNetop"]["comments"][j]["content"],
                  id: result.data!["getNetop"]["comments"][j]["id"],
                  name: "Name",
                    // result.data!["getNetop"]["comments"][j]["createdBy"]["name"]
                )
            );
          }

          return ListView(
            children: [
              SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.73,
                width: MediaQuery
                    .of(context)
                    .size
                    .height * 0.8,
                child: ListView(
                  children: [
                    Column(
                      children : comments.map((comment) => Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: Card(
                          color: Color(0xFFDEDDFF),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                child: Row(
                                  children: [
                                    //PP
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(10, 10, 5, 0),
                                      child: Container(
                                        height:30.0,
                                        width: 30.0,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                                        ),
                                      ),
                                    ),

                                    //Name
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(5, 6, 10, 0),
                                      child: Text(
                                        comment.name,
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              //Comment
                              Padding(
                                padding: const EdgeInsets.fromLTRB(12, 5, 10, 8),
                                child: Row(
                                  children: [
                                    Text(
                                      comment.message,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )).toList(),
                    )
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 10, 10),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 5.0, 12.0, 0.0),
                      child: Container(
                        height: 35.0,
                        width: 35.0,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        ),
                        child: CircleAvatar(
                          radius: 30.0,
                          backgroundImage: NetworkImage('https://images.unsplash.com/photo-1638975983437-2f5fea7540da?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=388&q=80'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 16),
                      child: SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.64,
                        child: TextFormField(
                          controller: commentController,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Write a comment',
                          ),
                        ),
                      ),
                    ),

                    Mutation(
                      options: MutationOptions(
                          document: gql(createComments),
                          onCompleted: (dynamic resultData){
                            print("comment result data: $resultData");
                            refetch!();
                            commentController.clear();
                          }
                      ),
                      builder: (
                          RunMutation runMutation,
                          QueryResult? result,
                          ){
                        if (result!.hasException){
                          print(result.exception.toString());
                        }
                        if(result.isLoading){
                          return Scaffold(
                            appBar:AppBar(
                              title: Text('Comments'),
                              backgroundColor:Color(0xFFE6CCA9),
                            ),
                            body: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        return IconButton(
                          onPressed: ()
                          {
                            print(widget.post.id);
                            runMutation(
                                {
                                  "content":commentController.text,
                                  "id":widget.post.id,
                                }
                            );
                          },
                          icon: Icon(Icons.send),
                          iconSize: 24,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      )
    );
  }
}
