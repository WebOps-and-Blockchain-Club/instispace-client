import 'package:client/graphQL/query.dart';
import 'package:client/models/query.dart';
import 'package:client/screens/home/Queries/queryCard.dart';
import 'package:client/widgets/Filters.dart';
import 'package:client/widgets/search.dart';
import 'package:client/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:client/widgets/loading screens.dart';
import 'addQuery.dart';

class QueryHome extends StatefulWidget {
  const QueryHome({Key? key}) : super(key: key);

  @override
  _QueryHomeState createState() => _QueryHomeState();
}

class _QueryHomeState extends State<QueryHome> {
  List<queryClass> posts=[];
  String getMyQueries = Queries().getMyQueries;
  late int total;
  int skip=0;
  int take=10;
  bool orderByLikes =false;
  bool display = false;
  TextEditingController searchController = TextEditingController();
  String search = "";
  late DateTime createdAt;
  ScrollController scrollController =ScrollController();
  var ScaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
          document: gql(getMyQueries),
          variables: {"take":take,"lastEventId": "","search": search, "orderByLikes":orderByLikes}
      ),
      builder: (QueryResult result, {fetchMore, refetch}){
        print("search:$search");
        if (result.hasException) {
          print(result.exception.toString());
        }
        if (result.isLoading) {
          return Scaffold(
            body: Center(
              child: Column(
                children: [
                  PageTitle('Queries', context),
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
        var data=result.data!["getMyQuerys"]["queryList"];
        total = result.data!["getMyQuerys"]["total"];
        posts.clear();
        for(var i=0;i<data.length;i++){
          createdAt = DateTime.parse(data[i]["createdAt"]);
          posts.add(queryClass(id: data[i]["id"], title: data[i]["title"], likeCount: data[i]["likeCount"], content: data[i]["content"], createdByName: (data[i]["createdBy"]["name"]==null)?"":data[i]["createdBy"]["name"], createdByRoll: data[i]["createdBy"]["roll"], photo:data[i]["photo"]!=null?data[i]["photo"]:"",isLiked: data[i]["isLiked"],createdById: data[i]["createdBy"]["id"], ));
        }
        FetchMoreOptions opts =FetchMoreOptions(
            variables: {"take":take,"lastEventId": posts.last.id,"search":search,"orderByLikes":orderByLikes},
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

          //UI
          floatingActionButton: FloatingActionButton(onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context)=> AddQuery(refetchQuery : refetch,)));
            // refetch!();
          },
            child: Icon(Icons.add),
            backgroundColor: Color(0xFFFF0000),
          ),
          backgroundColor: Color(0xFFDFDFDF),
          body:  SafeArea(
                  child:ListView(
                    children: [ Column(
                        children:[
                          PageTitle('Queries', context),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.center,
                              //     children: [
                              //       Expanded(
                              //         flex: 6,
                              //         child: TextFormField(
                              //           controller: searchController,
                              //           // onChanged: (String value){
                              //           //   if(value.length>=3){
                              //           //
                              //           //   }
                              //           // },
                              //         ),
                              //       ),
                              //       IconButton(onPressed: (){
                              //         setState(() {
                              //           display = !display;
                              //           search=searchController.text;
                              //           // print("search String $search");
                              //         });
                              //         if(!display){
                              //           refetch!();
                              //         }
                              //       }, icon: Icon(Icons.search_outlined)),
                              //     ],
                              //   ),
                              // ),

                              Search(search: search, refetch: refetch, ScaffoldKey: ScaffoldKey, page: 'Queries', widget: Filters(filterSettings: {}, refetch: refetch, selectedFilterIds: [], isStarred: false, mostLikeValues: false,page: 'Queries', callback: (bool val) {},), callback: (val) => search = val,),
                              SizedBox(
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.70,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.550,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(10,8,10,10),
                                  child: ListView(
                                    controller: scrollController,
                                    children: posts.map((e) => QueryCard(post: e,refetchQuery: refetch,postCreated: createdAt,)).toList(),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ]
                    ),
                    ]
                  )
              ),
        );
        },
    );
  }
}

