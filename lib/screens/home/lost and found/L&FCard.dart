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
          Container(
            color: Colors.indigo,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    "$category a ${post.what}",
                  ),
                  if(userId==post.createdId)
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
                      return ElevatedButton(
                          onPressed: (){
                            runMutation({
                              "resolveItemItemId":post.id,
                            });
                            refetchPosts!();
                          },
                          child: Text("resolved")
                      );
                    },
                  ),
                  if(userId==post.createdId)
                  IconButton(
                      onPressed:()async{
                        if(post.category=="LOST")
                        await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (BuildContext context)=> EditLost(post: post,refetchPost: refetchPosts,)));
                        if(post.category=="FOUND")
                         await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (BuildContext context)=> EditFound(post: post,refetchPost: refetchPosts,)));
                        refetchPosts!();
                      },
                      icon:Icon(Icons.edit),
                  )
                ],
              )
            ),
          ),
          if(post.imageUrl.isNotEmpty)
          CarouselSlider(
              items: post.imageUrl.map((item) => Container(
                child: Center(
                  child: Image.network(item,fit: BoxFit.cover,width: 400,),
                ),
              )
              ).toList(),
              options: CarouselOptions(
                enableInfiniteScroll: false,
              ),
          ),
          Container(
            color: Colors.indigo,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("at ${post.location} & ${time}"),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Please contact me at ${post.contact} $a the item"),
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

    var dateTimeFormat = DateFormat("dd/MM/yyyy hh:mm:ss aaa");

    return dateTimeFormat.format(localDateTime);
  }
}

