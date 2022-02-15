import 'package:client/graphQL/query.dart';
import 'package:client/models/query.dart';
import 'package:client/screens/home/Queries/queryCard.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'addQuery.dart';

class QueryHome extends StatefulWidget {
  const QueryHome({Key? key}) : super(key: key);

  @override
  _QueryHomeState createState() => _QueryHomeState();
}

class _QueryHomeState extends State<QueryHome> {
  List<queryClass> posts=[];
  String getQueries = Queries().getMyQueries;
  String searchQueries = Queries().searchQuery;
  late int total;
  int skip=0;
  int take=10;
  bool orderByLikes =false;
  bool display = false;
  TextEditingController searchController = TextEditingController();
  String search = "";
  ScrollController scrollController =ScrollController();
  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
          document: gql(searchQueries),
          variables: {"skip":skip,"take":take,"search":search}
      ),
      builder: (QueryResult result, {fetchMore, refetch}){
        if (result.hasException) {
          print(result.exception.toString());
        }
        if (result.isLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.blue[700],
            ),
          );
        }
        var data=result.data!["searchQueries"]["queryList"];
        total = result.data!["searchQueries"]["total"];
        posts.clear();
        for(var i=0;i<data.length;i++){
          posts.add(queryClass(id: data[i]["id"], title: data[i]["title"], likeCount: data[i]["likeCount"], content: data[i]["content"], createdByName: data[i]["createdBy"]["name"], createdByRoll: data[i]["createdBy"]["roll"], photo:data[i]["photo"]!=null?data[i]["photo"]:"",isLiked: data[i]["isLiked"],createdById: data[i]["createdBy"]["id"], ));
        }
        FetchMoreOptions opts =FetchMoreOptions(
            variables: {"skip":skip+10,"take":take,"search":search},
            updateQuery: (previousResultData,fetchMoreResultData){
              // print("previousResultData:$previousResultData");
              // print("fetchMoreResultData:${fetchMoreResultData!["getNetops"]["total"]}");
              // print("posts:$posts");
              final List<dynamic> repos = [
                ...previousResultData!['searchQueries']['queryList'] as List<dynamic>,
                ...fetchMoreResultData!['searchQueries']['queryList'] as List<dynamic>
              ];
              fetchMoreResultData['searchQueries']['queryList'] = repos;

              return fetchMoreResultData;
            }
        );
        scrollController.addListener(()async {
          var triggerFetchMoreSize =
              0.99 * scrollController.position.maxScrollExtent;
          if (scrollController.position.pixels >
              triggerFetchMoreSize && total>posts.length){
            await fetchMore!(opts);
            scrollController.jumpTo(triggerFetchMoreSize);
          }
        });
        print("after search $posts");

        //Page
        return Scaffold(
          appBar: AppBar(
            title: Text("Queries",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              ),),
            backgroundColor: Color(0xFF5451FD),
            actions: [
            Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if(display)
                SizedBox(
                    width: 80,
                    height: 40,
                    child: TextFormField(
                      controller: searchController,
                      // onChanged: (String value){
                      //   if(value.length>=3){
                      //
                      //   }
                      // },
                    )
                ),
              IconButton(onPressed: (){
                setState(() {
                  display = !display;
                  search=searchController.text;
                  // print("search String $search");
                });
                if(!display){
                  refetch!();
                }
              }, icon: Icon(Icons.search_outlined)),
            ],
          ),
              IconButton(onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => AddQuery(refetchQuery: refetch,)));
              }, icon: Icon(Icons.add,
                size: 28,
              )
              ),
            ],
          ),

          //UI
          body:  SafeArea(
                  child:Column(
                      children:[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 15, 12, 10),
                          child: SizedBox(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * 0.750,
                            width: MediaQuery
                                .of(context)
                                .size
                                .height * 0.550,
                            child: ListView(
                              controller: scrollController,
                              children: posts.map((e) => QueryCard(post: e,refetchQuery: refetch,)).toList(),
                            ),
                          ),
                        )
                      ]
                  )
              ),
        );
        },
    );
  }
}

