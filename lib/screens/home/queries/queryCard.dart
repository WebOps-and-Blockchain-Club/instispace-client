import 'package:carousel_slider/carousel_slider.dart';
import 'package:client/graphQL/query.dart';
import 'package:client/models/query.dart';
import 'package:client/widgets/expandDescription.dart';
import 'package:client/screens/home/queries/editQuery.dart';
import 'package:client/widgets/NetOpCard.dart';
import 'package:client/widgets/imageView.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:client/widgets/marquee.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../widgets/deleteAlert.dart';
import 'queryComments.dart';


class QueryCard extends StatefulWidget {
  final queryClass post;
  final Future<QueryResult?> Function()? refetchQuery;
  QueryCard({required this.post,required this.refetchQuery});
  @override
  _QueryCardState createState() => _QueryCardState();
}

class _QueryCardState extends State<QueryCard> {

  ///GraphQL
  String toggleLike = Queries().toggleLike;
  String getQuery = Queries().getMyQuery;
  String reportQuery = Queries().reportMyQuery;
  String deleteQuery = Queries().deleteQuery;
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
    differenceTime = difference(widget.post.createdAt);
    queryClass post= widget.post;
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
            Container(
              color: const Color(0xFF42454D),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    ///Conditional Padding
                    padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width*0.6,
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
                  Row(
                    children: [
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
                            color: Colors.white,
                            iconSize: 22,
                          ),
                        ),
                      ///Delete Button
                      if(userId == post.createdById)
                        Mutation(
                            options: MutationOptions(
                                document: gql(deleteQuery),
                                onCompleted: (result) {
                                  print('result: $result');
                                  if(result["deleteMyQuery"]){
                                    widget.refetchQuery!();
                                    Navigator.pop(context);
                                  }
                                }),
                            builder: (
                                RunMutation runMutation,
                                QueryResult? result,
                                ) {
                              if (result!.hasException) {
                                print(result.exception.toString());
                              }
                              if (result.isLoading) {
                                return Center(
                                    child: LoadingAnimationWidget
                                        .threeRotatingDots(
                                      color: Colors.white,
                                      size: 20,
                                    ));
                              }
                              return IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context)=>DeleteAlert(
                                        deleteButton: ElevatedButton(
                                          onPressed: (){
                                            print("id:${post.id}");
                                            runMutation({"id": post.id});
                                          }, child: const Text('Delete'),
                                        ),
                                        context: context),
                                  );
                                },
                                icon: const Icon(Icons.delete_outline),
                                color: Colors.white,
                              );
                            }),
                    ],
                  )
                ],
              ),
            ),

            ///Images
            if (post.imgUrl.isNotEmpty )
              Padding(
                padding: const EdgeInsets.fromLTRB(15,10,15,0),
                child: CarouselSlider(
                  items: post.imgUrl.map((item) => Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5,0,5,0),
                      child: GestureDetector(
                        child: Center(
                          child: Image.network(item,fit: BoxFit.contain,width: 400,),
                        ),
                        onTap: () {
                          openImageView(context, post.imgUrl.indexOf(item), post.imgUrl);
                        },
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
                  /// Like Button and Like Count
                  Row(
                    children: [
                      ///Like Icon
                      Mutation(
                          options:MutationOptions(
                              document: gql(toggleLike),
                              onCompleted: (result){
                                // print(result);
                                if(result['toggleLikeQuery']){
                                }
                              }
                          ),
                          builder: (
                              RunMutation runMutation,
                              QueryResult? result,
                              ){
                            if (result!.hasException){
                              print(result.exception.toString());
                            }
                            return Ink(
                              decoration: const ShapeDecoration(
                                  color: Color(0xFFFFFF),
                                  shape: CircleBorder(
                                    side: BorderSide.none,
                                  )
                              ),
                              height: MediaQuery.of(context).size.height*0.05,
                              width: MediaQuery.of(context).size.width*0.1,
                              child: Center(
                                child: IconButton(
                                  onPressed: ()
                                  {
                                    runMutation({
                                      "id": post.id
                                    });
                                    setState(() {
                                      post.isLiked = !post.isLiked;
                                      print("istLiked :${post.isLiked}");
                                      if(post.isLiked){
                                        post.likeCount = post.likeCount+1;
                                        print("likeCOunt: ${post.likeCount}");
                                      }
                                      else{
                                        post.likeCount = post.likeCount-1;
                                        print("likeCOunt: ${post.likeCount}");
                                      }
                                    });
                                  },
                                  icon: const Icon(Icons.thumb_up),
                                  iconSize: 20,
                                  color: post.isLiked? const Color(0xFF42454D):Colors.grey,
                                ),
                              ),
                            );
                          }
                      ),

                      ///Like Count
                      Text(
                        "${post.likeCount}",
                        style: const TextStyle(
                          color: Color(0xFF42454D),
                          fontWeight: FontWeight.w400,
                          fontSize: 10.0,
                        ),
                      ),
                    ],
                  ),

                  ///Comment Button
                  Row(
                    children: [
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
                      ///Comment Count
                      Text(
                        "${post.commentCount}",
                        style: const TextStyle(
                          color: Color(0xFF42454D),
                          fontWeight: FontWeight.w400,
                          fontSize: 10.0,
                        ),
                      ),
                    ],
                  ),

                  ///Report Button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,0,14,0),
                    child: Ink(
                      decoration: const ShapeDecoration(
                          color: Colors.white,
                          shape: CircleBorder(
                            side: BorderSide.none,
                          )
                      ),
                      height: MediaQuery.of(context).size.height*0.05,
                      width: MediaQuery.of(context).size.width*0.1,
                      child: Center(
                        child: IconButton(
                          onPressed: () =>
                          {
                            showAlertDialog(context,reportQuery,post.id)
                          },
                          icon: const Icon(Icons.report),
                          iconSize: 20,
                          color:Colors.grey,
                          // color: const Color(0xFF021096),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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

