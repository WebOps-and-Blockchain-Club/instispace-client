import 'package:client/graphQL/events.dart';
import 'package:client/models/tag.dart';
import 'package:client/screens/Events/editEvent.dart';
import 'package:client/screens/tagPage.dart';
import 'package:client/widgets/NetOpCards.dart';
import 'package:client/widgets/eventCards.dart';
import 'package:client/widgets/tagButtons.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  TextEditingController reportController = TextEditingController();
  late String createdId;
  late String userId;
  late bool isLiked;
  late bool isStarred;
  String month = '';
  String date = '';
  String year = '';
  late DateTime createdAt;

  @override
  Widget build(BuildContext context) {
    var values = widget.post;
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
            return const Card(
                clipBehavior: Clip.antiAlias,
                elevation: 5.0,
                color: Color(0xFF5451FD),
                child: SizedBox(
                  height: 60,
                  width: 20,
                )
            );
          }
          print("tags: ${widget.post.tags}");
          likeCount=result.data!["getEvent"]["likeCount"];
          isLiked=result.data!["getEvent"]["isLiked"];
          isStarred=result.data!["getEvent"]["isStared"];
          createdAt = DateTime.parse(result.data!['getEvent']['createdAt']);
          createdId=result.data!["getEvent"]["createdBy"]["id"];
          userId=result.data!["getMe"]["id"];


          return Padding(
                padding: const EdgeInsets.fromLTRB(2,2,2,3),
              child: EventsCard(context, refetch, widget.refetchPosts,createdAt, tags, widget.post, userId, createdId),
          );

        }
    );
  }
}