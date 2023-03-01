import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '/widgets/helpers/navigate.dart';
import '/widgets/helpers/error.dart';
import './card/main.dart';
import '../../../models/post/actions.dart';
import '../../super_user/approve_post.dart';
import '../../../models/post/main.dart';

class PostQuery extends StatefulWidget {
  final QueryOptions<Object?> options;
  final List<PostCategoryModel>? categories;

  const PostQuery({Key? key, required this.options, this.categories})
      : super(key: key);

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
        if (result.hasException) {
          return Center(
            child: Text(formatErrorMessage(result.exception.toString())),
          );
        }

        if (result.hasException && result.data != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(formatErrorMessage(result.exception.toString()))),
          );
        }

        if (result.isLoading && result.data == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final PostsModel resultParsedData = result.parsedData as PostsModel;
        final List<PostModel> posts = resultParsedData.posts;
        final int total = resultParsedData.total;

        if (posts.isEmpty) {
          return const Center(
            child: Error(error: '', message: 'No data found.'),
          );
        }

        FetchMoreOptions opts = FetchMoreOptions(
          variables: {...options.variables, "lastEventId": posts.last.id},
          updateQuery: (previousResultData, fetchMoreResultData) {
            final List<dynamic> repos = [
              ...previousResultData!['findPosts']['list'] as List<dynamic>,
              ...fetchMoreResultData!["findPosts"]["list"] as List<dynamic>
            ];
            fetchMoreResultData["findPosts"]["list"] = repos;
            return fetchMoreResultData;
          },
        );

        return RefreshIndicator(
          onRefresh: () {
            return refetch!();
          },
          child: NotificationListener<UserScrollNotification>(
              onNotification: (notification) {
                if (notification.metrics.pixels >
                        0.8 * notification.metrics.maxScrollExtent &&
                    total > posts.length) {
                  fetchMore!(opts);
                }
                return true;
              },
              child: PostListView(
                posts: posts,
                options: options,
                endOfListWidget: Padding(
                  padding: const EdgeInsets.all(20),
                  child: result.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : total == posts.length
                          ? TextButton(
                              onPressed: () {
                                navigate(
                                    context,
                                    SuperUserPostPage(
                                      title: 'OLDER POST',
                                      type: 'oldPost',
                                      categories: widget.categories,
                                    ));
                              },
                              child: const Text("View Older Posts"))
                          : TextButton(
                              onPressed: fetchMore != null
                                  ? () => fetchMore(opts)
                                  : null,
                              child: const Text("Load More")),
                ),
              )),
        );
      },
    );
  }
}

class PostListView extends StatefulWidget {
  final List<PostModel> posts;
  final QueryOptions<Object?> options;
  final Widget? endOfListWidget;
  const PostListView(
      {Key? key,
      required this.posts,
      required this.options,
      this.endOfListWidget})
      : super(key: key);

  @override
  State<PostListView> createState() => _PostListViewState();
}

class _PostListViewState extends State<PostListView> {
  @override
  Widget build(BuildContext context) {
    final posts = widget.posts;
    return ListView.builder(
      itemCount: posts.length + (widget.endOfListWidget != null ? 1 : 0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) => index == posts.length
          ? widget.endOfListWidget!
          : Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 30),
              child: PostCard(
                post: posts[index],
                options: widget.options,
              ),
            ),
    );
  }
}