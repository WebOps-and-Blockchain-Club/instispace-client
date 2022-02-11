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
                  collapsed: Card(
                    child: Column(
                      children: [
                        Text(post.title),
                        if(post.photo!='')
                          Image.network(post.photo),
                        Text(post.content),
                        Row(
                          children: [
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
                                  );
                                }
                            ),
                            Text("$likeCount"),
                            IconButton(onPressed: () =>
                            {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => queryComments(post:post),
                                )
                              ),
                              print('commented'),
                            }, icon: Icon(Icons.comment)),
                            if(userId == post.createdById)
                            IconButton(onPressed: () =>
                            {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditQuery(post:post, refetchQuery: widget.refetchQuery,),
                                  )
                              ),
                              print('commented'),
                            }, icon: Icon(Icons.edit))
                          ],
                        ),
                      ],
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
            child:Column(
              children: [
                Text("single Post"),
                Text(post.title),
                if(post.photo!='')
                  Image.network(post.photo),
                Row(
                  children: [
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
                          );
                        }
                    ),
                    Text("$likeCount"),
                    IconButton(onPressed: () =>
                    {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => queryComments(post:post),
                          )
                      ),
                      print('commented'),
                    }, icon: Icon(Icons.comment)),
                  ],
                ),
                Text(post.content),

                if(attachment !=null && attachment != "")
                IconButton(onPressed: (){
                  launch(attachment);
                }, icon: Icon(Icons.attachment)),
              ],
            )
        );
        },
    );
  }
}



