import 'package:client/graphQL/home.dart';
import 'package:client/graphQL/netops.dart';
import 'package:client/models/homeClasses.dart';
import 'package:client/models/tag.dart';
import 'package:flutter/material.dart';
import 'package:client/models/tag.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class EventsHomeCard extends StatefulWidget {
  final eventsClass events;
  EventsHomeCard({required this.events});
  @override
  _EventsHomeCardState createState() => _EventsHomeCardState();
}

class _EventsHomeCardState extends State<EventsHomeCard> {

  String toggleStar=netopsQuery().toggleStar;
  String toggelStarEvent = homeQuery().toggelStarEvent;
  String getMeHome = homeQuery().getMeHome;
  late bool isStared;


  @override
  Widget build(BuildContext context) {
    isStared = widget.events.isStared;
    List<Tag>tags = widget.events.tags;
    return Query(
        options: QueryOptions(
        document: gql(getMeHome),
    ),
    builder:(QueryResult result, {fetchMore, refetch}) {
      if (result.hasException) {
        print(result.exception.toString());
        return Text(result.exception.toString());
      }
      if (result.isLoading) {
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
      return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
        child: Card(
          color: Colors.blue[800],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0)),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.events.title
                  ),
                  Mutation(
                      options:MutationOptions(
                          document: gql(toggelStarEvent)
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
                              "eventId":widget.events.id
                            });
                            refetch!();
                          },
                          icon: isStared?Icon(Icons.star):Icon(Icons.star_border),
                          color: isStared? Colors.amber:Colors.grey,
                        );
                      }
                  ),
                ],
              ),
              // Text(
              //   widget.events.location
              // ),
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
        ),
      );
    }
    );
  }
}



class NetOpHomeCard extends StatefulWidget {
  final eventsClass netops;
  NetOpHomeCard({required this.netops});

  @override
  _NetOpHomeCardState createState() => _NetOpHomeCardState();
}

class _NetOpHomeCardState extends State<NetOpHomeCard> {

  String toggleStar=netopsQuery().toggleStar;
  String toggelStarEvent = homeQuery().toggelStarEvent;
  String getMeHome = homeQuery().getMeHome;
  late bool isStared;

  @override
  Widget build(BuildContext context) {
    isStared = widget.netops.isStared;
    List<Tag>tags = widget.netops.tags;
    return Query(
        options: QueryOptions(
        document: gql(getMeHome),
    ),
    builder:(QueryResult result, {fetchMore, refetch}) {
    if (result.hasException) {
    print(result.exception.toString());
    return Text(result.exception.toString());
    }
    if (result.isLoading) {
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
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
      child: Card(
        color: Colors.blue[800],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    widget.netops.title
                ),
                Mutation(
                    options:MutationOptions(
                        document: gql(toggelStarEvent)
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
                            "eventId":widget.netops.id
                          });
                          refetch!();
                        },
                        icon: isStared?Icon(Icons.star):Icon(Icons.star_border),
                        color: isStared? Colors.amber:Colors.grey,
                      );
                    }
                ),
              ],
            ),
            // Text(
            //     widget.netops.location
            // ),
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
      ),
    );
    });
  }
}




