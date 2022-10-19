import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../models/post.dart';
import '../../widgets/helpers/error.dart';
import '../../widgets/helpers/loading.dart';
import '../button/icon_button.dart';
import '../card/main.dart';
import '../headers/main.dart';

class PostPage extends StatefulWidget {
  final String header;
  final QueryOptions<Object?> queryOptions;
  final PostModel Function(Map<String, dynamic>?) toPostsModel;
  final PostActions Function(PostModel) actions;
  const PostPage(
      {Key? key,
      required this.header,
      required this.queryOptions,
      required this.toPostsModel,
      required this.actions})
      : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    return Query(
        options: widget.queryOptions,
        builder: (QueryResult result, {FetchMore? fetchMore, refetch}) {
          return Scaffold(
            appBar: AppBar(
                title: CustomAppBar(
                    title: widget.header,
                    leading: CustomIconButton(
                      icon: Icons.arrow_back,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )),
                automaticallyImplyLeading: false),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: RefreshIndicator(
                    onRefresh: () => refetch!(),
                    child: Stack(
                      children: [
                        ListView(),
                        (() {
                          if (result.hasException) {
                            return Error(error: result.exception.toString());
                          }

                          if (result.isLoading && result.data == null) {
                            return const Loading();
                          }

                          final PostModel post =
                              widget.toPostsModel(result.data);

                          return PostCard(
                            post: post,
                            actions: widget.actions(post),
                          );
                        }())
                      ],
                    )),
              ),
            ),
          );
        });
  }
}
