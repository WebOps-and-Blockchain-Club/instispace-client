import 'package:client/graphQL/home.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../models/post.dart';
import '../models/tag.dart';
import '../widgets/Filters.dart';
import '../widgets/loading screens.dart';
import '../widgets/search.dart';
import '../widgets/text.dart';
import 'Events/post.dart';
import 'home/homeCards.dart';

class TagPage extends StatefulWidget {
  final String tagId;
  final String tagName;
  TagPage({required this.tagId,required this.tagName});
  @override
  _TagPageState createState() => _TagPageState();
}

class _TagPageState extends State<TagPage> {

  String getTag = homeQuery().getTag;
  Map all = {};
  String search = '';
  bool isStarred = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
        return Scaffold(
          appBar: AppBar(
            title: Text(
                widget.tagName,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
            ),
            backgroundColor: Color(0xFF2B2E35),
          ),
          body: Center(
            child: Column(
              children: [
                Expanded(
                    child: ListView.separated(
                        itemBuilder: (context, index) => NewCardSkeleton(),
                        separatorBuilder: (context, index) => const SizedBox(height: 6,),
                        itemCount: 5)
                )
              ],
            ),
          ),
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
          createdById: result.data!["getTag"]["events"][i]["createdBy"]['id'],
          createdByName: '',
          likeCount: result.data!["getTag"]["events"][i]["likeCount"],
          imgUrl: [],
          linkName: result.data!["getTag"]["events"][i]["linkName"],
          description: result.data!["getTag"]["events"][i]["content"],
          time: result.data!["getTag"]["events"][i]["time"],
          location: result.data!["getTag"]["events"][i]["location"],
          linkToAction: result.data!["getTag"]["events"][i]["linkToAction"],
          isLiked: result.data!["getTag"]["events"][i]["isLiked"],
          isStarred: result.data!["getTag"]["events"][i]["isStared"],
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
          createdByName: '',
          comments: [], like_counter: 0, endTime: '', attachment: '', imgUrl: '', linkToAction: '', linkName: '',
          description: result.data!["getTag"]["netops"][i]["content"],
          isLiked: result.data!['getTag']['netops'][i]['isLiked'],
          isStarred: result.data!['getTag']['netops'][i]['isStared'],

        ),()=>"netop");
      }
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            widget.tagName,
            style: const TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
          backgroundColor: Color(0xFF2B2E35),
          elevation: 0.0,
        ),
        backgroundColor: Color(0xFFDFDFDF),
        body: ListView(
          children: [Column(
            children: [
              // SizedBox(
              //   height: MediaQuery.of(context).size.height*0.06,
              //   width: MediaQuery.of(context).size.width*1,
              //   child: Search(
              //     search: '',
              //     refetch: refetch,
              //     ScaffoldKey: _scaffoldKey,
              //     page: 'Netops',
              //     widget: Filters(
              //       mostLikeValues: false,
              //       isStarred: false,
              //       selectedFilterIds: [],
              //       filterSettings: all,
              //       refetch: refetch,
              //       page: 'Netops', callback: (bool val) {isStarred = val;},
              //     ), callback: (val) => search = val,
              //   ),
              // ),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.9,
                child: ListView(
                  shrinkWrap: true,
                    children :[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10,10,10,10),
                        child: Column(
                          children: all.keys.map((e) => cardFunction(all[e],e,refetch)
                          ).toList(),
                        ),
                      ),
                      if(result.isLoading)
                        Center(
                            child: CircularProgressIndicator(color: Colors.lightBlueAccent,)
                        ),
                    ]
                ),
              ),
            ],
          ),
          ]
        ),
      );
    }
    );
  }
  Widget cardFunction (String category, post, refetch){
    if(category == "event"){
      return EventsHomeCard(events: post,refetchPosts: refetch,);
    }
    else if(category == "netop"){
      return NetOpHomeCard(netops: post,refetchPosts: refetch,);
    }
    return Container();
  }
}
