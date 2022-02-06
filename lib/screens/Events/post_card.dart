import 'package:client/graphQL/events.dart';
import 'package:client/models/tag.dart';
import 'package:client/screens/Events/editEvent.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'post.dart';
import 'singlepost.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final num index;
  final Future<QueryResult?> Function()? refetchPosts;
  PostCard({required this.post,required this.index,required this.refetchPosts});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  String toggleLike = eventsQuery().toggleLike;
  String toggleStar=eventsQuery().toggleStar;
  String deleteEvent=eventsQuery().deleteEvent;
  String getEvent = eventsQuery().getEvent;
  late String createdId;
  late String userId;
  late bool isLiked;
  late bool isStarred;
  @override
  Widget build(BuildContext context) {
    List<Tag>tags = widget.post.tags;
    DateTime dateTime = DateTime.parse(widget.post.time);
    var likeCount;
    return Query(
        options: QueryOptions(
            document: gql(getEvent),
          variables: {"eventId":widget.post.id},
        ),
        builder: (QueryResult result, {fetchMore, refetch}){
          if (result.hasException) {
            print(result.exception.toString());
            return Text(result.exception.toString());
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
          likeCount=result.data!["getEvent"]["likeCount"];
          isLiked=result.data!["getEvent"]["isLiked"];
          isStarred=result.data!["getEvent"]["isStared"];
          createdId=result.data!["getEvent"]["createdBy"]["id"];
          userId=result.data!["getMe"]["id"];
          return ExpandableNotifier(
            child: ScrollOnExpand(
              child: ExpandablePanel(
                  theme: ExpandableThemeData(
                    tapBodyToCollapse: true,
                    tapBodyToExpand: true,
                  ),
                  expanded: SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 1,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 1,
                      child: SinglePost(post: widget.post,isStarred: isStarred,refetch: refetch,)),
                  collapsed: Card(
                      clipBehavior: Clip.antiAlias,
                      elevation: 5.0,
                      color: Color(0xFFF9F6F2),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                            10.0, 0.0, 10.0, 5.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Text(
                                        widget.post.title,
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                        ),
                                      ),
                                      if(userId==createdId)
                                        SizedBox(
                                          width: 60,
                                          height: 20,
                                          child: ElevatedButton(
                                            child: Text('edit'),
                                            onPressed: (){
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext context)=> EditPostEvents(post: widget.post,refetchPosts: widget.refetchPosts,)));
                                            },
                                          ),
                                        ),
                                      if(userId==createdId)
                                        Mutation(
                                            options: MutationOptions(
                                                document: gql(deleteEvent)
                                            ),
                                            builder:(
                                                RunMutation runMutation,
                                                QueryResult? result,
                                                ){
                                              if (result!.hasException){
                                                print(result.exception.toString());
                                              }
                                              if(result.isLoading){
                                                return CircularProgressIndicator();
                                              }
                                              return SizedBox(
                                                width: 75,
                                                height: 20,
                                                child: ElevatedButton(
                                                    onPressed: (){
                                                      runMutation({
                                                        "eventId":widget.post.id
                                                      });
                                                    },
                                                    child: Text('delete')),
                                              );
                                            }
                                        ),
                                      Mutation(
                                          options:MutationOptions(
                                              document: gql(toggleStar)
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
                                                  "eventId":widget.post.id
                                                });
                                                refetch!();
                                              },
                                              icon: isStarred?Icon(Icons.star):Icon(Icons.star_border),
                                              color: isStarred? Colors.amber:Colors.grey,
                                            );
                                          }
                                      ),
                                    ],
                                  ),
                                  if(widget.post.imgUrl.isEmpty)
                                    Text(
                                      widget.post.description.length > 250
                                          ? widget.post.description.substring(
                                          0, 250) + '...'
                                          : widget.post.description,
                                      style: TextStyle(
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  if(widget.post.imgUrl.isNotEmpty)
                                    CarouselSlider(
                                      items: widget.post.imgUrl.map((item) => Container(
                                        child: Center(
                                          child: Image.network(item,fit: BoxFit.cover,width: 400,),
                                        ),
                                      )
                                      ).toList(),
                                      options: CarouselOptions(
                                        enableInfiniteScroll: false,
                                      ),
                                    ),
                                  Row(
                                    children: [
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              IconButton(onPressed: () =>
                                              {
                                                print(dateTime),
                                                print('shared')
                                              }, icon: Icon(Icons.share)),

                                              IconButton(onPressed: () =>
                                              {
                                                print('remainder added')
                                              },
                                                  icon: Icon(
                                                      Icons.access_alarm)),
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
                                                          "eventId":widget.post.id
                                                        });
                                                        refetch!();
                                                        print("isLiked:$isLiked");
                                                      },
                                                      icon: Icon(Icons.thumb_up),
                                                      color: isLiked? Colors.blue:Colors.grey,
                                                    );
                                                  }
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(left: 20.0),
                                                child: Text(
                                                  "$likeCount likes",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 240.0,
                                                height: 30.0,
                                                child: ListView(
                                                  scrollDirection: Axis
                                                      .horizontal,
                                                  children: tags.map((tag) =>
                                                      SizedBox(
                                                        height: 25.0,
                                                        child: Padding(
                                                          padding: const EdgeInsets
                                                              .fromLTRB(
                                                              2.0, 0.0, 2.0,
                                                              0.0),
                                                          child: ElevatedButton(
                                                              onPressed: () =>
                                                              {
                                                              },
                                                              style: ButtonStyle(
                                                                  backgroundColor: MaterialStateProperty
                                                                      .all(
                                                                      Colors
                                                                          .grey),
                                                                  shape: MaterialStateProperty
                                                                      .all<
                                                                      RoundedRectangleBorder>(
                                                                      RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius
                                                                            .circular(
                                                                            30.0),
                                                                      ))
                                                              ),
                                                              child: Text(
                                                                tag.Tag_name,
                                                              )),
                                                        ),
                                                      )).toList(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      // SizedBox(
                                      //     width: 120,
                                      //     height: 50,
                                      //     child: Container(
                                      //       decoration: BoxDecoration(
                                      //         color: Colors.grey,
                                      //         borderRadius: BorderRadius
                                      //             .circular(10.0),
                                      //       ),
                                      //       child: Padding(
                                      //         padding: const EdgeInsets
                                      //             .fromLTRB(2.0, 8.0, 8.0, 0.0),
                                      //         child: Column(
                                      //           children: [
                                      //             Text(time),
                                      //             Text(date),
                                      //           ],
                                      //         ),
                                      //       ),
                                      //     )
                                      // )
                                    ],
                                  ),

                                ],
                              ),
                            ]
                        ),
                      )
                  ),
                  builder: (_, collapsed, expanded) =>
                      Expandable(
                        collapsed: collapsed, expanded: expanded,)
              ),
            ),
            // ),
          );

          // return Padding(
          //   padding: const EdgeInsets.fromLTRB(5.0,0.0,5.0,5.0),
          //   child: Card(
          //     color: Color(0xFFF9F6F2),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.stretch,
          //       children: [
          //         Image.network(widget.post.imgUrl!,height: 200.0),
          //         SizedBox(
          //           height: 6.0,
          //         ),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Padding(
          //               padding: const EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 5.0),
          //               child: Text(
          //                 widget.post.title,
          //                 style: TextStyle(
          //                   color: Colors.black,
          //                   fontSize: 30.0,
          //                 ),
          //               ),
          //             ),
          //             Row(
          //               children: [
          //                 Mutation(
          //                     options:MutationOptions(
          //                         document: gql(toggleLike)
          //                     ),
          //                     builder: (
          //                         RunMutation runMutation,
          //                         QueryResult? result,
          //                         ){
          //                       if (result!.hasException){
          //                         print(result.exception.toString());
          //                       }
          //                       return IconButton(
          //                         onPressed: (){
          //                           runMutation({
          //                             "eventId":widget.post.id
          //                           });
          //                           refetch!();
          //                           print("isLiked:$isLiked");
          //                         },
          //                         icon: Icon(Icons.thumb_up),
          //                         color: isLiked? Colors.blue:Colors.grey,
          //                       );
          //                     }
          //                 ),
          //                 IconButton(onPressed: () => {}, icon: Icon(Icons.access_alarm)),
          //                 IconButton(onPressed: () => {}, icon: Icon(Icons.share))
          //               ],
          //             )
          //           ],
          //         ),
          //         SizedBox(
          //           height: 6.0,
          //         ),
          //         Padding(
          //           padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
          //           child: Flexible(
          //             child: Text(
          //               widget.post.description,
          //               overflow: TextOverflow.ellipsis,
          //               // trimLines: 2,
          //               // trimMode: TrimMode.Line,
          //               // trimCollapsedText: "Read More",
          //               // trimExpandedText: "Read Less",
          //               style: TextStyle(
          //                 color: Colors.black,
          //                 fontSize: 15.0,
          //               ),
          //             ),
          //           ),
          //         ),
          //         SizedBox(
          //           height: 10.0,
          //         ),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Padding(
          //               padding: const EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 5.0),
          //               child: Text(
          //                 widget.post.location,
          //                 style: TextStyle(
          //                   color: Colors.black,
          //                   fontSize: 15.0,
          //                 ),
          //               ),
          //             ),
          //             SizedBox(
          //               height: 6.0,
          //             ),
          //             Text("24 Dec | 15:00",
          //               style: TextStyle(
          //                 color: Colors.black,
          //                 fontSize: 15.0,
          //               ),),
          //           ],
          //         ),
          //         SizedBox(
          //           height: 10.0,
          //         ),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.start,
          //           children: [
          //             Padding(
          //               padding: const EdgeInsets.fromLTRB(2.0,0.0,0.0,0.0),
          //               child: ElevatedButton(
          //                 onPressed: () {},
          //                 child: Text("Tag 1",
          //                   style: TextStyle(
          //                       color: Colors.white
          //                   ),),
          //               ),
          //             ),
          //             Padding(
          //               padding: const EdgeInsets.fromLTRB(2.0,0.0,0.0,0.0),
          //               child: ElevatedButton(
          //                 onPressed: () {},
          //                 child: Text("Tag 2",
          //                   style: TextStyle(
          //                       color: Colors.white
          //                   ),),
          //               ),
          //             ),
          //             Padding(
          //               padding: const EdgeInsets.fromLTRB(2.0,0.0,0.0,0.0),
          //               child: ElevatedButton(
          //                 onPressed: () {},
          //                 child: Text("Tag 3",
          //                   style: TextStyle(
          //                       color: Colors.white
          //                   ),),
          //               ),
          //             )
          //           ],
          //         ),
          //         ButtonBar(
          //           alignment: MainAxisAlignment.start,
          //           children: [
          //             TextButton(
          //                 onPressed: () => {
          //                   Navigator.push(
          //                     context,
          //                     MaterialPageRoute(builder: (context) => SinglePost(post:widget.post)),
          //                   ),
          //                 },
          //                 child: Text(
          //                   'More Details',
          //                 )
          //             ),
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // );
        }
    );
  }
}