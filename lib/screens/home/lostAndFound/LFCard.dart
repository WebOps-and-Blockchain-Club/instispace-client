import 'package:client/graphQL/LnF.dart';
import 'package:client/models/L&Fclass.dart';
import 'package:client/screens/home/lostAndFound/editFound.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'editLost.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:client/widgets/marquee.dart';

class LFCard extends StatelessWidget {
  final Future<QueryResult?> Function()? refetchPosts;
  final LnF post ;
  final String userId;
  LFCard({required this.post,required this.userId,required this.refetchPosts});
  String resolveItem = LnFQuery().resolveItem;

  List<String> testimages = ['https://picsum.photos/250','https://picsum.photos/251'];

  // List<String> testTitles (category, name) = ['$category a $name'];

  @override
  Widget build(BuildContext context) {
    var time=dateTimeString(post.time);
    var a;
    var category;
    if(post.category=="FOUND"){
      a="to claim";
      category="Found";
    }
    else {
      a="if you find";
      category="Lost";
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.5),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //Title Container
            Container(
              color: const Color(0xFF42454D),
              child: Padding(
                //Conditional Padding
                padding: (userId==post.createdId)
                    ? const EdgeInsets.fromLTRB(18, 0, 0, 0)
                    : const EdgeInsets.fromLTRB(18, 10, 0, 10),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  ///Title, Resolve and edit button
                  children: [
                    ///Title
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.55,
                      child: MarqueeWidget(
                        direction: Axis.horizontal,
                        child: Text("$category a ${post.what}",
                          style: TextStyle(
                            //Conditional Font Size
                            fontWeight: (userId==post.createdId)
                                ? FontWeight.w700
                                : FontWeight.bold,
                            //Conditional Font Size
                            fontSize: (userId==post.createdId)
                                ? 18
                                : 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    if(userId==post.createdId)
                    Row(
                      children: [
                        ///Resolved Button
                        Mutation(
                          options: MutationOptions(
                            document: gql(resolveItem),
                            onCompleted: (result){
                              // print(result);
                              if(result["resolveItem"]){
                                refetchPosts!();
                              }
                            }
                          ),
                          builder: (RunMutation runMutation,
                              QueryResult? result,){
                            if (result!.hasException){
                              print(result.exception.toString());
                            }
                            if(result.isLoading){
                              return Center(
                                  child: LoadingAnimationWidget.threeRotatingDots(
                                    color: Colors.white,
                                    size: 20,
                                  ));
                            }
                            return IconButton(
                                onPressed: (){
                                  runMutation({
                                    "resolveItemItemId":post.id,
                                  });
                                },
                              icon: const Icon(Icons.check_circle_outline),
                              iconSize: 24,
                              color: Colors.white,
                              // color: Color(0xFFFF0000),
                            );
                          },
                        ),

                        ///Edit Button
                        IconButton(
                          onPressed:()async{
                            if(post.category=="LOST") {
                              await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (BuildContext context)=> EditLost(post: post,refetchPost: refetchPosts,)));
                            }
                            if(post.category=="FOUND") {
                              await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (BuildContext context)=> EditFound(post: post,refetchPost: refetchPosts,)));
                            }
                            refetchPosts!();
                          },
                          icon: const Icon(Icons.edit),
                          iconSize: 24,
                          color: Colors.white,
                          // color: Color(0xFFFF0000),
                        )
                      ],
                    ),
                  ],
                )
              ),
            ),

            ///Image Container
            if(post.imageUrl.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: CarouselSlider(
                items: post.imageUrl.map((item) => Container(
                  child: Center(
                    child: Image.network(item,
                      fit: BoxFit.contain,
                    ),
                  ),
                )
                ).toList(),
                options: CarouselOptions(
                  enableInfiniteScroll: true,
                  autoPlay: true,
                ),
              ),
            ),

            ///Location & Time & Contact
              Material(
              elevation: 3,
              child: Container(
                color: Color(0xFFFFFFFF),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("At ${post.location} & ${time}",
                      style: const TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                        child: Text("Please contact me at ${post.contact} $a the item.",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                        child: Text(
                          '$category by Anshul Mehta',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  String dateTimeString(String utcDateTime) {
    if (utcDateTime == "") {
      return "";
    }
    var parseDateTime = DateTime.parse(utcDateTime);
    final localDateTime = parseDateTime.toLocal();

    var dateTimeFormat = DateFormat("dd/MM/yyyy hh:mm aaa");

    return dateTimeFormat.format(localDateTime);
  }
}

