import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import './card/main.dart';
import '../../../models/post/main.dart';

class PostQuery extends StatefulWidget {
  final QueryOptions<Object?> options;
  const PostQuery({Key? key, required this.options}) : super(key: key);

  @override
  State<PostQuery> createState() => _PostQueryState();
}

class _PostQueryState extends State<PostQuery> {
  @override
  Widget build(BuildContext context) {
    final options = widget.options;
    return Query(
      options: options,
      builder: (result, {fetchMore, refetch}) {
        // print('\n\n\n\n${options.variables["filteringCondition"]["categories"]}');
        return RefreshIndicator(
          onRefresh: () {
            return refetch!();
          },
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 10),
            children: [
              if (result.data != null)
                ...(() {
                  final List<PostModel> posts =
                      PostsModel.fromJson(result.data!["findPosts"]["list"])
                          .posts;
                  final total = result.data!["findPosts"]["total"];

                  FetchMoreOptions opts = FetchMoreOptions(
                    variables: {...options.variables, "lastId": posts.last.id},
                    updateQuery: (previousResultData, fetchMoreResultData) {
                      final List<dynamic> repos = [
                        ...previousResultData!['findPosts']['list']
                            as List<dynamic>,
                        ...fetchMoreResultData!["findPosts"]["list"]
                            as List<dynamic>
                      ];
                      fetchMoreResultData["findPosts"]["list"] = repos;
                      return fetchMoreResultData;
                    },
                  );

                  return [
                    // No posts
                    if (posts.isEmpty) const Text("No Posts"),

                    // Display the post list
                    if (posts.isNotEmpty)
                      NotificationListener<UserScrollNotification>(
                        onNotification: (notification) {
                          if (notification.metrics.pixels >
                                  0.8 * notification.metrics.maxScrollExtent &&
                              total > posts.length) {
                            fetchMore!(opts);
                          }
                          return true;
                        },
                        child: PostListView(posts: posts, options: options),
                      ),

                    //Fetch More Loader
                    // small
                    if (result.isLoading) const Text("Loading more items"),

                    //End of Post
                    // new widget
                    if (total == posts.length) const Text("View Older Posts")
                  ];
                }()),

              //Error Display
              // snackbar
              if (result.hasException && result.data != null)
                Text(result.exception.toString()),

              // full screen
              if (result.hasException && result.data == null)
                Text(result.exception.toString()),

              //Loading Display
              //full screen
              if (result.isLoading && result.data == null)
                const Text("Loading"),
            ],
          ),
        );
      },
    );
  }
}

class PostListView extends StatefulWidget {
  final List<PostModel> posts;
  final QueryOptions<Object?> options;
  const PostListView({Key? key, required this.posts, required this.options})
      : super(key: key);

  @override
  State<PostListView> createState() => _PostListViewState();
}

class _PostListViewState extends State<PostListView> {
  @override
  Widget build(BuildContext context) {
    final posts = widget.posts;
    return ListView.builder(
      itemCount: posts.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) => PostCard(
        post: posts[index],
        options: widget.options,
      ),
    );
  }
}
