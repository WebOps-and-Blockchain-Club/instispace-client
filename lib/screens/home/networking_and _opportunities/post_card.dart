import 'package:client/graphQL/netops.dart';
import 'package:client/screens/home/networking_and%20_opportunities/editpost.dart';
import 'package:client/screens/home/networking_and%20_opportunities/singlepost.dart';
import 'package:client/widgets/NetOpCards.dart';
import 'package:client/widgets/tagButtons.dart';
import 'package:client/widgets/titles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../models/post.dart';
import '../../../models/tag.dart';
import 'package:client/screens/home/networking_and _opportunities/comments.dart';
import 'package:expandable/expandable.dart';



class PostCard extends StatefulWidget {
  final NetOpPost post;
  final Future<QueryResult?> Function()? refetchPosts;
  PostCard({required this.post,required this.refetchPosts});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  String reportNetop=netopsQuery().reportNetop;
  String toggleLike = netopsQuery().toggleLike;
  String toggleStar=netopsQuery().toggleStar;
  String deleteNetop=netopsQuery().deleteNetop;
  late bool isLiked;
  late bool isStarred;
  String getNetop= netopsQuery().getNetop;
  late String createdId;
  late String userId;
  late DateTime createdAt;
  TextEditingController reportController =TextEditingController();
  @override
  Widget build(BuildContext context) {
    List<Tag>tags = widget.post.tags;
    DateTime dateTime = DateTime.parse(widget.post.endTime);
    var likeCount;
          return Query(
              options: QueryOptions(
                document: gql(getNetop),
                variables: {"getNetopNetopId":widget.post.id},
              ),
              builder:(QueryResult result, {fetchMore, refetch}){
                if (result.hasException) {
                  print(result.exception.toString());
                  return Text(result.exception.toString());
                }
                if(result.isLoading){
                  return const Card(
                      clipBehavior: Clip.antiAlias,
                      elevation: 5.0,
                      color: const Color(0xFFF9F6F2),
                    child: SizedBox(
                      height: 60,
                      width: 20,
                    )
                  );
                }
                likeCount=result.data!["getNetop"]["likeCount"];
                isLiked=result.data!["getNetop"]["isLiked"];
                isStarred=result.data!["getNetop"]["isStared"];
                createdId=result.data!["getNetop"]["createdBy"]["id"];
                userId=result.data!["getMe"]["id"];
                createdAt = DateTime.parse(result.data!["getNetop"]['createdAt']);
                // print("createdId:$createdId");
                // print("userID:$userId");

                var values = widget.post;
                return Padding(
                          padding: const EdgeInsets.fromLTRB(0,0,0,10),
                          child: NetopsCard(context, refetch, widget.refetchPosts, isStarred,isLiked,likeCount,createdAt, tags, userId, createdId, reportController, values,'NetopsSection'),
                        );
                  // ),
              }
          );
        }
  }



