import 'package:carousel_slider/carousel_slider.dart';
import 'package:client/graphQL/query.dart';
import 'package:client/models/query.dart';
import 'package:client/widgets/expandDescription.dart';
import 'package:client/screens/home/queries/editQuery.dart';
import 'package:client/widgets/NetOpCard.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:client/widgets/marquee.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'queryComments.dart';
class QueryCard extends StatefulWidget {
  final queryClass post;
  final Future<QueryResult?> Function()? refetchQuery;
  DateTime postCreated; 
  QueryCard({required this.post,required this.refetchQuery,required this.postCreated});
  @override
  _QueryCardState createState() => _QueryCardState();
}

class _QueryCardState extends State<QueryCard> {

  ///GraphQL
  String toggleLike = Queries().toggleLike;
  String getQuery = Queries().getMyQuery;

  ///Variables
  String userId = "";
  late String differenceTime;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _sharedPreference();
  }
  SharedPreferences? prefs;
  void _sharedPreference()async{
    prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs!.getString("id")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    differenceTime = difference(widget.postCreated);
    queryClass post= widget.post;
    return Query(
      options: QueryOptions(
        document: gql(getQuery),
        variables: {"id":post.id},
      ),
      builder: (QueryResult result, {fetchMore, refetch}){
        if (result.hasException) {
          return Text(result.exception.toString());
        }
        if(result.isLoading){
          return const Card(
              clipBehavior: Clip.antiAlias,
              elevation: 5.0,
              color: Color(0xFFFFFFFF),
              child: SizedBox(
                height: 60,
                width: 20,
              )
          );
        }
        int likeCount = result.data!["getMyQuery"]["likeCount"];
        bool isLiked = result.data!["getMyQuery"]["isLiked"];

        return Padding(
          padding: const EdgeInsets.fromLTRB(0,0,0,10),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.5)
            ),
            clipBehavior: Clip.antiAlias,
            elevation: 3,
            color: const Color(0xFFFFFFFF),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ///Title Container
                Container(
                  color: const Color(0xFF42454D),
                  child: Padding(
                    ///Conditional Padding
                    padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
                    child: MarqueeWidget(
                      direction: Axis.horizontal,
                      child: Text(
                        capitalize(post.title),
                        style: TextStyle(
                          ///Conditional Font Size
                          fontWeight: (userId==post.createdById)
                              ? FontWeight.w700
                              : FontWeight.bold,
                          ///Conditional Font Size
                          fontSize: (userId==post.createdById)
                              ? 18
                              : 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                ///Images
                if (post.imgUrl.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15,10,15,0),
                    child: CarouselSlider(
                      items: post.imgUrl.map((item) => Container(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(5,0,5,0),
                          child: Center(
                            child: Image.network(item,fit: BoxFit.contain,width: 400,),
                          ),
                        ),
                      )
                      ).toList(),
                      options: CarouselOptions(
                          enableInfiniteScroll: true,
                          autoPlay: true
                      ),
                    ),
                  ),

                ///Description
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                  child:
                  DescriptionTextWidget(
                    text: post.content,
                  ),
                ),

                ///Creator
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Text('Created by ${post.createdByName}, $differenceTime',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),

                ///Buttons
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 3, 5, 3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ///Like Button
                      Mutation(
                          options:MutationOptions(
                              document: gql(toggleLike)
                          ),
                          builder: (
                              RunMutation runMutation,
                              QueryResult? result,
                              ){
                            if (result!.hasException){
                              return Text(result.exception.toString());
                            }
                            return IconButton(
                              onPressed: (){
                                runMutation({
                                  "id":post.id
                                });
                                refetch!();
                              },
                              icon: const Icon(Icons.thumb_up),
                              color: isLiked? Colors.black:Colors.grey,
                              iconSize: 22,
                            );
                          }
                      ),

                      ///Like Count
                      Text("$likeCount",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),),

                      ///Comment Button
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
                          },
                          icon: const Icon(Icons.comment),
                          color: Colors.grey,
                          iconSize: 22,
                        ),
                      ),

                      ///Edit Button
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
                            },
                            icon: const Icon(Icons.edit),
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
        );
      },
    );
  }
}

///Function to capitalize first letter of Title

String capitalize(String s) {
  if(s!="") {
    return s[0].toUpperCase() + s.substring(1);
  } else{
    return s;
  }
}


