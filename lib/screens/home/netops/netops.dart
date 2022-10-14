import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../widgets/helpers/loading.dart';
import '../../../widgets/helpers/navigate.dart';
import '../../hostel/main.dart';
import 'actions.dart';
import 'new_netop.dart';
import '../tag/select_tags.dart';
import '../../../widgets/helpers/error.dart';
import '../../../widgets/headers/main.dart';
import '../../../widgets/card/main.dart';
import '../../../widgets/button/icon_button.dart';
import '../../../widgets/utils/main.dart';
import '../../../graphQL/netops.dart';
import '../../../models/netop.dart';
import '../../../models/user.dart';
import '../../../models/post.dart';
import '../../../models/tag.dart';

class NetopsPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final UserModel user;
  const NetopsPage({Key? key, required this.scaffoldKey, required this.user})
      : super(key: key);

  @override
  State<NetopsPage> createState() => _NetopsPageState();
}

class _NetopsPageState extends State<NetopsPage> {
  // Constants
  final isStaredTagModel =
      TagModel(id: "isStared", title: "Pinned", category: "Custom");
  final orderByLikesTagModel = TagModel(
      id: "orderByLikes", title: "Likes: High to Low", category: "Custom");

  //Variables
  bool orderByLikes = false;
  bool isStared = false;
  late TagsModel selectedTags = TagsModel.fromJson([]);
  String search = "";
  int skip = 0;
  int take = 10;
  bool _showFab = true;
  late String searchValidationError = "";

  //Controllers
  final ScrollController _scrollController = ScrollController();

  setFilters(TagsModel _selectedTags) {
    setState(() {
      isStared = _selectedTags.contains(isStaredTagModel);
      orderByLikes = _selectedTags.contains(orderByLikesTagModel);
      _selectedTags.remove(isStaredTagModel);
      _selectedTags.remove(orderByLikesTagModel);
      selectedTags = _selectedTags;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> variables = {
      "take": take,
      "lastId": "",
      "sort": {
        "byLikes": orderByLikes ? true : null,
        "stared": null,
        "byComments": null
      },
      "filters": {
        "search": search.trim(),
        "tags": selectedTags.getTagIds(),
        "isStared": isStared ? true : null
      },
    };
    final QueryOptions<Object?> options =
        QueryOptions(document: gql(NetopGQL.getAll), variables: variables);
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
                              title: "Networking",
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
                              onFilterClick: () {
                                if (orderByLikes) {
                                  selectedTags.add(orderByLikesTagModel);
                                }
                                if (isStared) {
                                  selectedTags.add(isStaredTagModel);
                                }
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) => buildSheet(
                                    context,
                                    selectedTags,
                                    (value) {
                                      setFilters(value);
                                      refetch!();
                                    },
                                    CategoryModel(category: "Custom", tags: [
                                      TagModel(
                                          id: "isStared",
                                          title: "Pinned",
                                          category: "Custom"),
                                      TagModel(
                                          id: "orderByLikes",
                                          title: "Likes: High to Low",
                                          category: "Custom")
                                    ]),
                                  ),
                                  isScrollControlled: true,
                                );
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

                      final List<PostModel> posts = NetopsModel.fromJson(
                              result.data!["getNetops"]["netopList"])
                          .toPostsModel();

                      if (posts.isEmpty) {
                        return const Error(error: "No Posts");
                      }

                      final total = result.data!["getNetops"]["total"];
                      FetchMoreOptions opts = FetchMoreOptions(
                          variables: {...variables, "lastId": posts.last.id},
                          updateQuery:
                              (previousResultData, fetchMoreResultData) {
                            final List<dynamic> repos = [
                              ...previousResultData!['getNetops']['netopList']
                                  as List<dynamic>,
                              ...fetchMoreResultData!["getNetops"]["netopList"]
                                  as List<dynamic>
                            ];
                            fetchMoreResultData["getNetops"]["netopList"] =
                                repos;
                            return fetchMoreResultData;
                          });

                      return NotificationListener<UserScrollNotification>(
                        onNotification: (notification) {
                          if (notification.metrics.pixels >
                                  0.8 * notification.metrics.maxScrollExtent &&
                              total > posts.length) {
                            fetchMore!(opts);
                          }
                          final ScrollDirection direction =
                              notification.direction;
                          setState(() {
                            if (direction == ScrollDirection.reverse) {
                              _showFab = false;
                            } else if (direction == ScrollDirection.forward) {
                              _showFab = true;
                            }
                          });
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
                                      netopActions(posts[index], options);
                                  return PostCard(
                                      post: posts[index], actions: actions);
                                }
                              }),
                        ),
                      );
                    }()),
                  ),
                ),
              ),
            ),
            floatingActionButton: AnimatedSlide(
              duration: const Duration(milliseconds: 300),
              offset: _showFab ? Offset.zero : const Offset(0, 2),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _showFab ? 1 : 0,
                child: widget.user.permissions.contains("CREATE_NETOP")
                    ? FloatingActionButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => NewNetopPage(
                                    options: options,
                                  )));
                        },
                        child: const Icon(Icons.add))
                    : null,
              ),
            ),
          );
        });
  }
}
