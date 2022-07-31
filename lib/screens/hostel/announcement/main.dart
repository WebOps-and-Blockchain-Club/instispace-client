import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'actions.dart';
import '../../../models/announcement.dart';
import '../../../graphQL/announcements.dart';
import '../../../models/user.dart';
import '../../home/tag/select_tags.dart';
import '../../../widgets/headers/main.dart';
import '../../../widgets/card/main.dart';
import '../../../widgets/utils/main.dart';
import '../../../models/post.dart';
import '../../../models/tag.dart';

class AnnouncementsPage extends StatefulWidget {
  final UserModel user;
  const AnnouncementsPage({Key? key, required this.user}) : super(key: key);

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  //Variables
  bool orderByLikes = false;
  bool isStared = false;
  late TagsModel selectedTags = TagsModel.fromJson([]);
  String search = "";
  int skip = 0;
  int take = 10;

  late String searchValidationError = "";

  //Controllers
  final ScrollController _scrollController = ScrollController();

  setFilters(TagsModel _selectedTags) {
    setState(() {
      selectedTags = _selectedTags;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> variables = {
      "take": take,
      "lastId": "",
      "hostelId": widget.user.hostelId ?? "",
      "search": search
    };
    final QueryOptions<Object?> options = QueryOptions(
        document: gql(AnnouncementGQL.getAll), variables: variables);
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
                            return const Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Header(
                                  title: "Announcements",
                                ));
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
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) => buildSheet(
                                      context, selectedTags, (value) {
                                    setFilters(value);
                                    refetch!();
                                  }, null),
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
                        return SelectableText(result.exception.toString());
                      }

                      if (result.isLoading && result.data == null) {
                        return const Text('Loading');
                      }

                      final List<PostModel> posts = AnnouncementsModel.fromJson(
                              result.data!["getAnnouncements"]
                                  ["announcementsList"])
                          .toPostsModel();

                      if (posts.isEmpty) {
                        return const Text('No posts');
                      }

                      final total = result.data!["getAnnouncements"]["total"];
                      FetchMoreOptions opts = FetchMoreOptions(
                          variables: {...variables, "lastId": posts.last.id},
                          updateQuery:
                              (previousResultData, fetchMoreResultData) {
                            final List<dynamic> repos = [
                              ...previousResultData!['getAnnouncements']
                                  ['announcementsList'] as List<dynamic>,
                              ...fetchMoreResultData!["getAnnouncements"]
                                  ["announcementsList"] as List<dynamic>
                            ];
                            fetchMoreResultData["getAnnouncements"]
                                ["announcementsList"] = repos;
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
                                      annoucementActions(posts[index], options);
                                  //Show hostels in tag card
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
            // floatingActionButton:
            //     widget.user.permissions.contains("CREATE_ANNOUNCEMENT")
            //         ? FloatingActionButton(
            //             onPressed: () {
            //               // Navigator.of(context).push(MaterialPageRoute(
            //               //     builder: (BuildContext context) => NewEvent(
            //               //           options: options,
            //               //         )));
            //             },
            //             child: const Icon(Icons.add))
            //         : null,
          );
        });
  }
}