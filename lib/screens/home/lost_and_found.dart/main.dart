import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'new_item.dart';
import 'actions.dart';
import '../../hostel/main.dart';
import '../../../widgets/helpers/loading.dart';
import '../../../widgets/helpers/error.dart';
import '../../../widgets/helpers/navigate.dart';
import '../../../widgets/headers/main.dart';
import '../../../widgets/card/main.dart';
import '../../../widgets/button/icon_button.dart';
import '../../../widgets/utils/main.dart';
import '../../../graphQL/lost_and_found.dart';
import '../../../models/user.dart';
import '../../../models/lost_and_found.dart';
import '../../../models/post.dart';

class LostAndFoundPage extends StatefulWidget {
  final UserModel user;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const LostAndFoundPage(
      {Key? key, required this.user, required this.scaffoldKey})
      : super(key: key);

  @override
  State<LostAndFoundPage> createState() => _LostAndFoundPageState();
}

class _LostAndFoundPageState extends State<LostAndFoundPage> {
  //Variables
  String search = "";
  int skip = 0;
  int take = 10;
  List<String> itemFilter = ["LOST", "FOUND"];

  late String searchValidationError = "";

  //Controllers
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> variables = {
      "take": take,
      "lastId": "",
      "itemsFilter": itemFilter,
      "search": search
    };
    final QueryOptions<Object?> options = QueryOptions(
        document: gql(LostAndFoundGQL.getAll), variables: variables);
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
                              title: "Lost & Found",
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
                                searchValidationError != "" ? 40 : 22,
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
                              chips: [
                                ChipModel(id: "LOST", name: "Lost"),
                                ChipModel(id: "FOUND", name: "Found")
                              ],
                              selectedChips: itemFilter,
                              onChipFilter: (val) {
                                setState(() {
                                  itemFilter = val;
                                });
                                refetch!();
                              },
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

                      final List<PostModel> posts =
                          LostAndFoundItemsModel.fromJson(
                                  result.data!["getItems"]["itemsList"])
                              .toPostsModel();

                      if (posts.isEmpty) {
                        return const Error(error: "No Posts");
                      }

                      final total = result.data!["getItems"]["total"];
                      FetchMoreOptions opts = FetchMoreOptions(
                          variables: {...variables, "lastId": posts.last.id},
                          updateQuery:
                              (previousResultData, fetchMoreResultData) {
                            final List<dynamic> repos = [
                              ...previousResultData!['getItems']['itemsList']
                                  as List<dynamic>,
                              ...fetchMoreResultData!["getItems"]["itemsList"]
                                  as List<dynamic>
                            ];
                            fetchMoreResultData["getItems"]["itemsList"] =
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
                                      lostAndFoundActions(
                                          posts[index], options);
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
                widget.user.permissions.contains("CREATE_ITEM")
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: FloatingActionButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          NewItemPage(
                                            category: "Found",
                                            options: options,
                                          )));
                                },
                                child: const Icon(Icons.lightbulb_outline)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: FloatingActionButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          NewItemPage(
                                            category: "Lost",
                                            options: options,
                                          )));
                                },
                                child: const Icon(Icons.search)),
                          ),
                        ],
                      )
                    : null,
          );
        });
  }
}
