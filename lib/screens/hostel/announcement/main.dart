import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../widgets/helpers/loading.dart';
import '../../../widgets/helpers/error.dart';
import '../shared/hostel_dropdown.dart';
import 'new_announcement.dart';
import 'actions.dart';
import '../../../models/announcement.dart';
import '../../../graphQL/announcements.dart';
import '../../../models/user.dart';
import '../../../widgets/headers/main.dart';
import '../../../widgets/card/main.dart';
import '../../../widgets/utils/main.dart';
import '../../../models/post.dart';

class AnnouncementsPage extends StatefulWidget {
  final UserModel user;
  const AnnouncementsPage({Key? key, required this.user}) : super(key: key);

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  //Variables
  String search = "";
  int take = 10;
  String? selectedHostel;

  late String searchValidationError = "";

  //Controllers
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> variables = {
      "take": take,
      "lastId": "",
      "hostelId": widget.user.hostelId ?? (selectedHostel ?? ""),
      "filters": {"search": search.trim()},
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
                            ),
                          ),
                        ),
                        if (widget.user.permissions
                            .contains("GET_ALL_ANNOUNCEMENTS"))
                          SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: HostelListDropdown(
                                value: selectedHostel,
                                onChanged: (value) {
                                  setState(() {
                                    selectedHostel = value;
                                  });
                                },
                              ),
                            );
                          }, childCount: 1))
                      ];
                    },
                    body: (() {
                      if (result.hasException) {
                        return Error(error: result.exception.toString());
                      }

                      if (result.isLoading && result.data == null) {
                        return const Loading();
                      }

                      final List<PostModel> posts = AnnouncementsModel.fromJson(
                              result.data!["getAnnouncements"]
                                  ["announcementsList"])
                          .toPostsModel();

                      if (posts.isEmpty) {
                        return const Error(
                            message: "No Announcements", error: "");
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
                                      annoucementActions(
                                          widget.user, posts[index], options);
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
                widget.user.permissions.contains("CREATE_ANNOUNCEMENT")
                    ? FloatingActionButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  NewAnnouncementPage(
                                    user: widget.user,
                                    options: options,
                                  )));
                        },
                        child: const Icon(Icons.add))
                    : null,
          );
        });
  }
}
