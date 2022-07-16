import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'get_user.dart';
import '../../widgets/button/icon_button.dart';
import '../../widgets/headers/main.dart';
import '../../widgets/utils/main.dart';
import '../../graphQL/user.dart';

class SearchUser extends StatefulWidget {
  const SearchUser({Key? key}) : super(key: key);

  @override
  State<SearchUser> createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  //Controllers
  final ScrollController _scrollController = ScrollController();

  late String searchValidationError = "";

  final TextEditingController search = TextEditingController();
  final int take = 20;
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> defaultVariables = {
      "search": search.text,
      "take": take,
      "skip": 0
    };
    return SafeArea(
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: NestedScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return CustomAppBar(
                          title: "Find People",
                          leading: CustomIconButton(
                            icon: Icons.arrow_back,
                            onPressed: () => Navigator.of(context).pop(),
                          ));
                    }, childCount: 1),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    floating: true,
                    delegate: ContestTabHeader(
                      SearchBar(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        onSubmitted: (value) {
                          if (value.isEmpty || value.length >= 4) {
                            setState(() {
                              search.text = value;
                            });
                          } else {
                            // setState(() {
                            //   searchValidationError =
                            //       "Enter atleast 4 characters";
                            // });
                          }
                        },
                        // searchValidationError: searchValidationError,
                      ),
                    ),
                  )
                ];
              },
              body: (search.text == "")
                  ? const Text("Enter the  string to search")
                  : Query(
                      options: QueryOptions(
                          document: gql(UserGQL().searchUser),
                          variables: defaultVariables),
                      builder: (QueryResult result,
                          {FetchMore? fetchMore, refetch}) {
                        if (result.hasException) {
                          return SelectableText(result.exception.toString());
                        }

                        if (result.isLoading && result.data == null) {
                          return const Text('Loading');
                        }

                        final List<dynamic> users = result
                            .data!["searchLDAPUser"]["list"]
                            .map((_user) => {
                                  "name": _user["name"],
                                  "roll": _user["roll"],
                                  "department": _user["department"]
                                })
                            .toList();

                        if (users.isEmpty) {
                          return const Text('No user');
                        }
                        final total = result.data!["searchLDAPUser"]["total"];
                        FetchMoreOptions opts = FetchMoreOptions(
                            variables: {
                              ...defaultVariables,
                              "skip": users.length
                            },
                            updateQuery:
                                (previousResultData, fetchMoreResultData) {
                              final List<dynamic> repos = [
                                ...previousResultData!["searchLDAPUser"]["list"]
                                    as List<dynamic>,
                                ...fetchMoreResultData!["searchLDAPUser"]
                                    ["list"] as List<dynamic>
                              ];
                              fetchMoreResultData["searchLDAPUser"]["list"] =
                                  repos;
                              return fetchMoreResultData;
                            });

                        return NotificationListener<ScrollNotification>(
                          onNotification: (notification) {
                            if (notification.metrics.pixels >
                                    0.8 *
                                        notification.metrics.maxScrollExtent &&
                                total > users.length) {
                              fetchMore!(opts);
                            }
                            return true;
                          },
                          child: RefreshIndicator(
                            onRefresh: () {
                              return refetch!();
                            },
                            child: ListView.builder(
                                itemCount: users.length + 1,
                                itemBuilder: (context, index) {
                                  if (users.length == index) {
                                    if (total == users.length) {
                                      return const Center(
                                          child: Text("No More Users"));
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
                                    return UserCard(user: users[index]);
                                  }
                                }),
                          ),
                        );
                      }),
            ),
          ),
        ),
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final Map<String, dynamic> user;
  const UserCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          leading: CachedNetworkImage(
            imageUrl: "",
            placeholder: (_, __) => const SizedBox(
              child: CircularProgressIndicator(),
              width: 30,
            ),
            errorWidget: (_, __, ___) =>
                const Icon(Icons.account_circle_rounded),
            width: 60,
            height: 60,
            imageBuilder: (_, imageProvider) => CircleAvatar(
              backgroundImage: imageProvider,
            ),
          ),
          style: ListTileStyle.list,
          title: Text(user["name"]!),
          textColor: Colors.black,
          subtitle: Text(
              "${(user["roll"] as String).toUpperCase()}\n${user["department"]}"),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => GetUser(
                    userDetails: {"roll": user["roll"]!, "name": user["name"]!},
                  ))),
        ),
      ),
    );
  }
}
