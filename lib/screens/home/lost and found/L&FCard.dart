import 'package:client/graphQL/LnF.dart';
import 'package:client/screens/home/lost%20and%20found/LFclass.dart';
import 'package:client/screens/home/lost%20and%20found/editFound.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'editLost.dart';
import 'package:carousel_slider/carousel_slider.dart';

class LFCard extends StatelessWidget {
  final Future<QueryResult?> Function()? refetchPosts;
  final LnF post ;
  final String userId;
  LFCard({required this.post,required this.userId,required this.refetchPosts});
  String resolveItem = LnFQuery().resolveItem;
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
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //Title Container
          Container(
            color: const Color(0xFF6B7AFF),
            child: Padding(
              //Conditional Padding
              padding: (userId==post.createdId)
                  ? const EdgeInsets.fromLTRB(10, 0, 0, 0)
                  : const EdgeInsets.fromLTRB(10, 8, 0, 8),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                //Title Row
                children: [
                  //Title
                  Text(
                    "$category a ${post.what}",
                    style: TextStyle(
                      //Conditional Font Size
                      fontWeight: (userId==post.createdId)
                          ? FontWeight.w700
                          : FontWeight.bold,
                      //Conditional Font Size
                      fontSize: (userId==post.createdId)
                          ? 18
                          : 16,
                      color: Colors.white,
                    ),
                  ),

                  //User Icons
                  if(userId==post.createdId)
                  Row(
                    children: [
                      //Resolved Button
                      Mutation(
                        options: MutationOptions(
                          document: gql(resolveItem)
                        ),
                        builder: (RunMutation runMutation,
                            QueryResult? result,){
                          if (result!.hasException){
                            print(result.exception.toString());
                          }
                          if(result.isLoading){
                            return CircularProgressIndicator();
                          }
                          return IconButton(
                              onPressed: (){
                                runMutation({
                                  "resolveItemItemId":post.id,
                                });
                                refetchPosts!();
                              },
                            icon: Icon(Icons.check_circle_outline),
                            iconSize: 24,
                            color: Colors.white,
                          );
                        },
                      ),

                      //Edit Button
                      IconButton(
                        onPressed:()async{
                          if(post.category=="LOST")
                            await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (BuildContext context)=> EditLost(post: post,refetchPost: refetchPosts,)));
                          if(post.category=="FOUND") {
                            await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (BuildContext context)=> EditFound(post: post,refetchPost: refetchPosts,)));
                          }
                          refetchPosts!();
                        },
                        icon:Icon(Icons.edit),
                        iconSize: 24,
                        color: Colors.white,
                      )
                    ],
                  ),
                ],
              )
            ),
          ),

          //Image Container
          if(post.imageUrl.isNotEmpty)
          CarouselSlider(
              items: post.imageUrl.map((item) => Container(
                child: Center(
                  child: Image.network(item,
                    fit: BoxFit.cover,),
                ),
              )
              ).toList(),
              options: CarouselOptions(
                enableInfiniteScroll: false,
              ),
          ),

          //Location & Time & Contact
          Container(
            color: Color(0xFFDEDDFF),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("At ${post.location} & ${time}",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),),
                  SizedBox(
                    height: 8,
                  ),
                  Text("Please contact me at ${post.contact} $a the item",
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          )
        ],
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

