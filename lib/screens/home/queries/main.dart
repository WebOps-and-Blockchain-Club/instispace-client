import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../widgets/helpers/loading.dart';
import '../../../widgets/helpers/error.dart';
import '../../../widgets/helpers/navigate.dart';
import '../../hostel/main.dart';
import 'actions.dart';
import 'new_query.dart';
import '../../../widgets/headers/main.dart';
import '../../../widgets/card/main.dart';
import '../../../widgets/button/icon_button.dart';
import '../../../widgets/utils/main.dart';
import '../../../graphQL/query.dart';
import '../../../models/user.dart';
import '../../../models/query.dart';
import '../../../models/post.dart';

class QueriesPage extends StatefulWidget {
  final UserModel user;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const QueriesPage({Key? key, required this.user, required this.scaffoldKey})
      : super(key: key);

  @override
  State<QueriesPage> createState() => _QueriesPageState();
}

class _QueriesPageState extends State<QueriesPage> {
  //Variables
  String search = "";
  int skip = 0;
  int take = 10;

  late String searchValidationError = "";

  //Controllers
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> variables = {
      "take": take,
      "lastId": "",
      "sort": {"stared": null, "byComments": null},
      "filters": {"search": search.trim()},
    };
    final QueryOptions<Object?> options =
        QueryOptions(document: gql(QueryGQL.getAll), variables: variables);
    return Query(
        options: options,
        builder: (QueryResult result, {FetchMore? fetchMore, refetch}) {
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: RefreshIndicator(
                  onRefresh: () => refetch!(),
                  child: NestedScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _scrollController,
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            return CustomAppBar(
                              title: "Queries",
                              leading: CustomIconButton(
                                  icon: Icons.menu,
                                  onPressed: () => widget
                                      .scaffoldKey.currentState!
                                      .openDrawer()),
                              action: (widget.user.hostelId != null ||
                                      widget.user.permissions
                                          .contains("HOSTEL_ADMIN"))
                                  ? CustomIconButton(
                                      icon: Icons.account_balance_outlined,
                                      onPressed: () => navigate(context,
                                          HostelWrapper(user: widget.user)))
                                  : null,
                            );
                          }, childCount: 1),
                        ),
                        SliverPersistentHeader(
                          pinned: true,
                          floating: true,
                          delegate: SearchBarDelegate(
                            additionalHeight:
                                searchValidationError != "" ? 18 : 0,
                            searchUI: SearchBar(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              onSubmitted: (value) {
                                if (value.isEmpty || value.length >= 4) {
                                  setState(() {
                                    search = value;
                                    searchValidationError = "";
                                  });
                                  refetch!();
                                } else {
                                  setState(() {
                                    searchValidationError =
                                        "Enter atleast 4 characters";
                                  });
                                }
                              },
                              error: searchValidationError,
                            ),
                          ),
                        )
                      ];
                    },
                    body: (() {
                      if (result.hasException) {
                        return Error(error: result.exception.toString());
                      }

                      if (result.isLoading && result.data == null) {
                        return const Loading();
                      }

                      final List<PostModel> posts = QueriesModel.fromJson(
                              result.data!["getMyQuerys"]["queryList"])
                          .toPostsModel();

                      if (posts.isEmpty) {
                        return const Error(
                            message: "No Queries Found", error: "");
                      }

                      final total = result.data!["getMyQuerys"]["total"];
                      FetchMoreOptions opts = FetchMoreOptions(
                          variables: {...variables, "lastId": posts.last.id},
                          updateQuery:
                              (previousResultData, fetchMoreResultData) {
                            final List<dynamic> repos = [
                              ...previousResultData!['getMyQuerys']['queryList']
                                  as List<dynamic>,
                              ...fetchMoreResultData!["getMyQuerys"]
                                  ["queryList"] as List<dynamic>
                            ];
                            fetchMoreResultData["getMyQuerys"]["queryList"] =
                                repos;
                            return fetchMoreResultData;
                          });

                      return NotificationListener<ScrollNotification>(
                        onNotification: (notification) {
                          if (notification.metrics.pixels >
                                  0.8 * notification.metrics.maxScrollExtent &&
                              total > posts.length) {
                            fetchMore!(opts);
                          }
                          return true;
                        },
                        child: RefreshIndicator(
                          onRefresh: () {
                            return refetch!();
                          },
                          child: ListView.builder(
                              itemCount: posts.length + 1,
                              itemBuilder: (context, index) {
                                if (posts.length == index) {
                                  if (total == posts.length) {
                                    return const Center(
                                        child: Text("No More Posts"));
                                  } else if (result.isLoading) {
                                    return const Center(
                                      child: Text("Loading"),
                                    );
                                  }
                                  return Center(
                                    child: TextButton(
                                        onPressed: () => fetchMore!(opts),
                                        child: const Text("Load More")),
                                  );
                                } else {
                                  final PostActions actions =
                                      queryActions(posts[index], options);
                                  return PostCard(
                                    post: posts[index],
                                    actions: actions,
                                  );
                                }
                              }),
                        ),
                      );
                    }()),
                  ),
                ),
              ),
            ),
            floatingActionButton:
                widget.user.permissions.contains("CREATE_QUERY")
                    ? FloatingActionButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => NewQueryPage(
                                    options: options,
                                  )));
                        },
                        child: const Icon(Icons.add))
                    : null,
          );
        });
  }
}
