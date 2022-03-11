import 'package:client/graphQL/query.dart';
import 'package:client/models/query.dart';
import 'package:client/screens/home/queries/queryCard.dart';
import 'package:client/widgets/filters.dart';
import 'package:client/widgets/search.dart';
import 'package:client/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:client/widgets/loadingScreens.dart';
import 'addQuery.dart';

class QueryHome extends StatefulWidget {
  const QueryHome({Key? key}) : super(key: key);

  @override
  _QueryHomeState createState() => _QueryHomeState();
}

class _QueryHomeState extends State<QueryHome> {

  ///GraphQL
  String getMyQueries = Queries().getMyQueries;

  ///Variables
  List<queryClass> posts=[];
  late int total;
  int skip=0;
  int take=10;
  bool orderByLikes =false;
  bool display = false;
  String search = "";
  late DateTime createdAt;

  ///Controllers
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController =ScrollController();
  ScrollController scrollController1 =ScrollController();

  ///Keys
  var ScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
          document: gql(getMyQueries),
          variables: {"take":take,"lastEventId": "","search": search, "orderByLikes":orderByLikes}
      ),
      builder: (QueryResult result, {fetchMore, refetch}) {
        if (result.hasException) {
          return Text(result.exception.toString());
        }

        ///Loading Screen
        if (result.isLoading) {
          return Scaffold(
            body: Center(
              child: Column(
                children: [
                  PageTitle('Queries', context),
                  Expanded(
                      child: ListView.separated(
                          itemBuilder: (context, index) => const NewCardSkeleton(),
                          separatorBuilder: (context, index) =>
                          const SizedBox(height: 6,),
                          itemCount: 5)
                  )
                ],
              ),
            ),
          );
        }

        ///Empty Screen
        if (result.data!["getMyQuerys"]["queryList"] == null ||
            result.data!["getMyQuerys"]["queryList"].isEmpty) {
          return Scaffold(
            body: Center(
              child: Column(
                children: [
                  PageTitle('Queries', context),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 250, 0, 0),
                    child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          'No queries yet !!',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.w600
                          ),
                          textAlign: TextAlign.center,
                        )
                    ),
                  ),
                ],
              ),
            ),
            ///Floating Action Button to add Query
            floatingActionButton: FloatingActionButton(onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          AddQuery(refetchQuery: refetch,)));
            },
              child: const Icon(Icons.add),
              backgroundColor: const Color(0xFFFF0000),
            ),
          );
        }
        else {
          var data = result.data!["getMyQuerys"]["queryList"];
          total = result.data!["getMyQuerys"]["total"];
          posts.clear();
          for (var i = 0; i < data.length; i++) {
            List<String> imageUrls=[];
            if(data[i]["photo"]!=null && data[i]["photo"]!="")
            {imageUrls=data[i]["photo"].split(" AND ");}
            createdAt = DateTime.parse(data[i]["createdAt"]);
            posts.add(queryClass(id: data[i]["id"],
              title: data[i]["title"],
              likeCount: data[i]["likeCount"],
              content: data[i]["content"],
              createdByName: data[i]["createdBy"]["name"],
              createdByRoll: data[i]["createdBy"]["roll"],
              imgUrl: imageUrls,
              isLiked: data[i]["isLiked"],
              createdById: data[i]["createdBy"]["id"],));
          }
          FetchMoreOptions opts = FetchMoreOptions(
              variables: {
                "take": take,
                "lastEventId": posts.last.id,
                "search": search,
                "orderByLikes": orderByLikes
              },
              updateQuery: (previousResultData, fetchMoreResultData) {
                final List<dynamic> repos = [
                  ...previousResultData!['searchQueries']['queryList'] as List<
                      dynamic>,
                  ...fetchMoreResultData!['searchQueries']['queryList'] as List<
                      dynamic>
                ];
                fetchMoreResultData['searchQueries']['queryList'] = repos;

                return fetchMoreResultData;
              }
          );
          scrollController.addListener(() async {
            var triggerFetchMoreSize =
                0.99 * scrollController.position.maxScrollExtent;
            if (scrollController.position.pixels >
                triggerFetchMoreSize && total > posts.length) {
              await fetchMore!(opts);
              scrollController.jumpTo(triggerFetchMoreSize);
            }
          });

          return Scaffold(

            ///Floating Action Button to add Query
            floatingActionButton: FloatingActionButton(onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          AddQuery(refetchQuery: refetch,)));
            },
              child: const Icon(Icons.add),
              backgroundColor: const Color(0xFFFF0000),
            ),

            ///Background Colour of screen
            backgroundColor: const Color(0xFFDFDFDF),

            body: SafeArea(
                child: RefreshIndicator(
                  onRefresh: () {
                    return refetch!();
                  },
                  color: const Color(0xFF2B2E35),
                  child: ListView(
                    controller: scrollController,
                      children: [ Column(
                          children: [
                            /// Heading
                            PageTitle('Queries', context),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ///Search bar and filter button
                                Search(
                                    search: search,
                                    refetch: refetch,
                                    ScaffoldKey: ScaffoldKey,
                                    page: 'queries',
                                    widget: Filters(filterSettings: const {},
                                      refetch: refetch,
                                      selectedFilterIds: const [],
                                      isStarred: false,
                                      mostLikeValues: false,
                                      page: 'queries',
                                      callback: (bool val) {},
                                    ),
                                    callback: (val) =>
                                        setState(() {
                                          search = val;
                                        })
                                ),

                                ///Listing queries
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
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 8, 10, 10),
                                    child: RefreshIndicator(
                                      color: const Color(0xFF2B2E35),
                                      onRefresh: () {
                                        return refetch!();
                                      },
                                      child: ListView(
                                        controller: scrollController1,
                                        children: posts.map((e) => QueryCard(
                                          post: e,
                                          refetchQuery: refetch,
                                          postCreated: createdAt,)).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ]
                      ),
                      ]
                  ),
                )
            ),
          );
        }
      },
    );
  }
}

