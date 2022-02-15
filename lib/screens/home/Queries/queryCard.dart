import 'package:client/graphQL/query.dart';
import 'package:client/models/query.dart';
import 'package:client/screens/home/Queries/editPost.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:expandable/expandable.dart';

import 'comments.dart';
class QueryCard extends StatefulWidget {
  final queryClass post;
  final Future<QueryResult?> Function()? refetchQuery;
  QueryCard({required this.post,required this.refetchQuery});
  @override
  _QueryCardState createState() => _QueryCardState();
}

class _QueryCardState extends State<QueryCard> {
  String toggleLike = Queries().toggleLike;
  String getQuery = Queries().getMyQuery;
  late String userId;
  @override
  Widget build(BuildContext context) {
    queryClass post= widget.post;
    return Query(
      options: QueryOptions(
        document: gql(getQuery),
        variables: {"id":post.id},
      ),
      builder: (QueryResult result, {fetchMore, refetch}){
        if (result.hasException) {
          print(result.exception.toString());
        }
        if(result.isLoading){
          return Card(
              clipBehavior: Clip.antiAlias,
              elevation: 5.0,
              color: Color(0xFFF9F6F2),
              child: SizedBox(
                height: 60,
                width: 20,
              )
          );
        }
        int likeCount = result.data!["getMyQuery"]["likeCount"];
        bool isLiked = result.data!["getMyQuery"]["isLiked"];
        userId = result.data!["getMe"]["id"];

        return ExpandableNotifier(
            child: ScrollOnExpand(
              child: ExpandablePanel(
                  theme: ExpandableThemeData(
                    tapBodyToCollapse: true,
                    tapBodyToExpand: true,
                  ),

                  expanded: singleQuery(post: post,),

                  //Short Card
                  collapsed: Padding(
                    padding: const EdgeInsets.fromLTRB(2, 3, 2, 3),
                    child: Card(
                      color: Color(0xFFDEDDFF),
                      child: Column(
                        children: [
                          //Title
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                            child: Row(
                              children: [
                                Text(post.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xFF000000),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          //Image
                          if(post.photo!='')
                            Image.network(post.photo),

                          //Description
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                            child: Container(
                              child: Text(post.content,
                                style: TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.normal,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),

                          //Buttons
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 3, 5, 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    //Like Button
                                    Mutation(
                                        options:MutationOptions(
                                            document: gql(toggleLike)
                                        ),
                                        builder: (
                                            RunMutation runMutation,
                                            QueryResult? result,
                                            ){
                                          if (result!.hasException){
                                            print(result.exception.toString());
                                          }
                                          return IconButton(
                                            onPressed: (){
                                              runMutation({
                                                "id":post.id
                                              });
                                              refetch!();
                                              print("isLiked:$isLiked");
                                            },
                                            icon: Icon(Icons.thumb_up),
                                            color: isLiked? Colors.blue:Colors.grey,
                                            iconSize: 22,
                                          );
                                        }
                                    ),

                                    //Like Count
                                    Text("$likeCount",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),),

                                    //Comment Button
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                      child: IconButton(
                                        onPressed: () =>
                                        {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => queryComments(post:post),
                                              )
                                          ),
                                          print('commented'),
                                        },
                                        icon: Icon(Icons.comment),
                                        color: Colors.grey,
                                        iconSize: 22,
                                      ),
                                    ),
                                  ],
                                ),

                                //Edit Button
                                if(userId == post.createdById)
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                  child: IconButton(
                                    onPressed: () =>
                                      {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EditQuery(post:post, refetchQuery: widget.refetchQuery,),
                                            )
                                        ),
                                        print('commented'),
                                      },
                                    icon: Icon(Icons.edit),
                                    color: Colors.grey,
                                    iconSize: 22,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  builder: (_, collapsed, expanded) =>
                      Expandable(
                        collapsed: collapsed, expanded: expanded,)
              ),
            )
        );
      },
    );
  }
}
class singleQuery extends StatefulWidget {
  final queryClass post;
  singleQuery({required this.post});

  @override
  _singleQueryState createState() => _singleQueryState();
}

class _singleQueryState extends State<singleQuery> {
  String toggleLike = Queries().toggleLike;
  String getQuery = Queries().getMyQuery;
  @override
  Widget build(BuildContext context) {
    queryClass post =widget.post;
    return Query(
      options: QueryOptions(
        document: gql(getQuery),
        variables: {"id":post.id},
      ),
      builder:(QueryResult result, {fetchMore, refetch}){
        if (result.hasException) {
          print(result.exception.toString());
        }
        if (result.isLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.blue[700],
            ),
          );
        }
        var attachment = result.data!["getMyQuery"]["attachments"];
        int likeCount = result.data!["getMyQuery"]["likeCount"];
        bool isLiked = result.data!["getMyQuery"]["isLiked"];

        return SafeArea(
            child:Padding(
              padding: const EdgeInsets.fromLTRB(3, 2, 3, 3),
              child: Card(
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(8)
                // ),
                color: Color(0xFFDEDDFF),
                child: Column(
                  children: [
                    //Title
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                      child: Row(
                        children: [
                          Text(post.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF000000),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //Image
                    if(post.photo!='')
                      Image.network(post.photo),

                    //Buttons
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 3, 5, 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              //Like Button
                              Mutation(
                                  options:MutationOptions(
                                      document: gql(toggleLike)
                                  ),
                                  builder: (
                                      RunMutation runMutation,
                                      QueryResult? result,
                                      ){
                                    if (result!.hasException){
                                      print(result.exception.toString());
                                    }
                                    return IconButton(
                                      onPressed: (){
                                        runMutation({
                                          "id":post.id
                                        });
                                        refetch!();
                                        print("isLiked:$isLiked");
                                      },
                                      icon: Icon(Icons.thumb_up),
                                      color: isLiked? Colors.blue:Colors.grey,
                                      iconSize: 22,
                                    );
                                  }
                              ),

                              //Like Count
                              Text("$likeCount",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),),

                              //Comment Button
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                child: IconButton(
                                  onPressed: () =>
                                  {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => queryComments(post:post),
                                        )
                                    ),
                                    print('commented'),
                                  },
                                  icon: Icon(Icons.comment),
                                  color: Colors.grey,
                                  iconSize: 22,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    //Description
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                      child: Container(
                        child: Text(post.content,
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),

                    if(attachment !=null && attachment != "")
                    IconButton(onPressed: (){
                      launch(attachment);
                    }, icon: Icon(Icons.attachment)),
                  ],
                ),
              ),
            )
        );
        },
    );
  }
}



