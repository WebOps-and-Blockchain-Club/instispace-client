import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../hostelSection/hostel.dart';
import 'new_event.dart';
import '../../../widgets/headers/main.dart';
import '../../../widgets/card/main.dart';
import '../../../widgets/button/icon_button.dart';
import '../../../widgets/utils/main.dart';
import '../tag/select_tags.dart';
import '../../../graphQL/events.dart';
import '../../../models/event.dart';
import '../../../models/post.dart';
import '../../../models/tag.dart';

class EventsPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const EventsPage({Key? key, required this.scaffoldKey}) : super(key: key);

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
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
      "orderByLikes": orderByLikes,
      "filteringCondition": {
        "tags": selectedTags.getTagIds(),
        "isStared": isStared
      },
      "search": search
    };
    return Query(
        options: QueryOptions(
            document: gql(EventGQL().getAll), variables: variables),
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
                              title: "Events",
                              leading: CustomIconButton(
                                  icon: Icons.menu,
                                  onPressed: () => widget
                                      .scaffoldKey.currentState!
                                      .openDrawer()),
                              action: CustomIconButton(
                                  icon: Icons.account_balance_outlined,
                                  onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const HostelHome()))),
                            );
                          }, childCount: 1),
                        ),
                        SliverPersistentHeader(
                          pinned: true,
                          floating: true,
                          delegate: ContestTabHeader(
                            SearchBar(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              onSubmitted: (value) {
                                setState(() {
                                  search = value;
                                });
                                refetch!();
                              },
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
                    body: scaffoldBody(result, refetch, variables, fetchMore),
                  ),
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => NewEvent(
                            refetch: refetch,
                          )));
                },
                child: const Icon(Icons.add)),
          );
        });
  }
}

Widget scaffoldBody(
    QueryResult result,
    Future<QueryResult<Object?>?> Function()? refetch,
    Map<String, dynamic> defaultVariables,
    FetchMore? fetchMore) {
  if (result.hasException) {
    return SelectableText(result.exception.toString());
  }

  if (result.isLoading && result.data == null) {
    return const Text('Loading');
  }

  final List<PostModel> posts =
      EventsModel.fromJson(result.data!["getEvents"]["list"]).toPostsModel();

  if (posts.isEmpty) {
    return const Text('No posts');
  }

  final total = result.data!["getEvents"]["total"];
  FetchMoreOptions opts = FetchMoreOptions(
      variables: {...defaultVariables, "lastId": posts.last.id},
      updateQuery: (previousResultData, fetchMoreResultData) {
        final List<dynamic> repos = [
          ...previousResultData!['getEvents']['list'] as List<dynamic>,
          ...fetchMoreResultData!["getEvents"]["list"] as List<dynamic>
        ];
        fetchMoreResultData["getEvents"]["list"] = repos;
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
                return const Center(child: Text("No More Posts"));
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
              return PostCard(
                post: posts[index],
                refetch: refetch,
                deleteMutationDocument: EventGQL().delete,
              );
            }
          }),
    ),
  );
}
