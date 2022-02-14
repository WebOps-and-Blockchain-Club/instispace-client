import 'package:client/graphQL/home.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../models/post.dart';
import '../models/tag.dart';
import 'Events/post.dart';
import 'home/homeCards.dart';

class TagPage extends StatefulWidget {
  final String tagId;
  TagPage({required this.tagId});
  @override
  _TagPageState createState() => _TagPageState();
}

class _TagPageState extends State<TagPage> {

  String getTag = homeQuery().getTag;
  Map all = {};
  late String tagName;
  @override
  Widget build(BuildContext context) {
   return Query(
        options: QueryOptions(
        document: gql(getTag),
          variables: {"tag": widget.tagId},
    ),
    builder:(QueryResult result, {fetchMore, refetch}) {
      if (result.hasException) {
        print(result.exception.toString());
        return Text(result.exception.toString());
      }
      if (result.isLoading) {
        return const Card(
            clipBehavior: Clip.antiAlias,
            elevation: 5.0,
            color: Color(0xFFF9F6F2),
            child: SizedBox(
              height: 60,
              width: 20,
            )
        );
      }

      all.clear();
      for (var i = 0; i < result.data!["getTag"]["events"].length; i++) {
        List<Tag> tags = [];
        for(var k=0;k < result.data!["getTag"]["events"][i]["tags"].length;k++){
          // print("Tag_name: ${netopList[i]["tags"][k]["title"]}, category: ${netopList[i]["tags"][k]["category"]}");
          tags.add(
            Tag(
              Tag_name: result.data!["getTag"]["events"][i]["tags"][k]["title"],
              category: result.data!["getTag"]["events"][i]["tags"][k]["category"],
              id: result.data!["getTag"]["events"][i]["tags"][k]["id"],
            ),
          );
        }
        all.putIfAbsent(Post(
          title: result.data!["getTag"]["events"][i]["title"],
          tags: tags,
          id: result.data!["getTag"]["events"][i]["id"],
          createdById: '',
          likeCount: 0,
          imgUrl: [],
          linkName: '',
          description: '',
          time: result.data!["getTag"]["events"][i]["time"],
          location: result.data!["getTag"]["events"][i]["location"],
          linkToAction: '',
          // location: result.data!["getMe"]["getHome"]["events"][i]["location"],
        ),
              () => "event",
        );
      }
      for (var i = 0; i < result.data!["getTag"]["netops"].length; i++) {
        List<Tag> tags = [];
        for(var k=0;k < result.data!["getTag"]["netops"][i]["tags"].length;k++){
          // print("Tag_name: ${netopList[i]["tags"][k]["title"]}, category: ${netopList[i]["tags"][k]["category"]}");
          tags.add(
            Tag(
              Tag_name: result.data!["getTag"]["netops"][i]["tags"][k]["title"],
              category: result.data!["getTag"]["netops"][i]["tags"][k]["category"],
              id: result.data!["getTag"]["netops"][i]["tags"][k]["id"],
            ),
          );
        }
        all.putIfAbsent(NetOpPost(
          title: result.data!["getTag"]["netops"][i]["title"],
          tags: tags,
          id: result.data!["getTag"]["netops"][i]["id"],
          comments: [], like_counter: 0, endTime: '', attachment: '', imgUrl: '', linkToAction: '', linkName: '',
          description: result.data!["getTag"]["netops"][i]["content"],

        ),()=>"netop");
      }
      tagName = result.data!["getTag"]["title"];
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Events and Netop under $tagName",
            style: const TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
          elevation: 0.0,
          automaticallyImplyLeading: false,
        ),
        body: SizedBox(
          height: 500,
          child: ListView(
              children :[
                Column(
                  children: all.keys.map((e) => cardFunction(all[e],e)
                  ).toList(),
                )
              ]
          ),
        ),
      );
    }
    );
  }
  Widget cardFunction (String category, post){
    if(category == "event"){
      return EventsHomeCard(events: post);
    }
    else if(category == "netop"){
      return NetOpHomeCard(netops: post);
    }
    return Container();
  }
}
