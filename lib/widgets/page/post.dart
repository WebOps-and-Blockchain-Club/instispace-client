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
                    child: () {
                      if (result.hasException && result.data == null) {
                        return Center(
                            child: Error(
                          error: result.exception.toString(),
                          onRefresh: refetch,
                        ));
                      }

                      if (result.hasException && result.data != null) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          // Use Future.delayed to delay the execution of showDialog
                          Future.delayed(Duration.zero, () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Center(child: Text("Error")),
                                  content: Text(formatErrorMessage(
                                      result.exception.toString(), context)),
                                  actions: [
                                    TextButton(
                                      child: const Text("Ok"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    TextButton(
                                      child: const Text("Retry"),
                                      onPressed: () {
                                        refetch!();
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          });
                        });
                      }

                      if (result.isLoading && result.data == null) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      final PostModel post = widget.toPostsModel(result.data);

                      return ListView(
                        children: [
                          PostCard(
                            post: post,
                            actions: widget.actions(post),
                          ),
                        ],
                      );
                    }(),
                  ),
                ),
              ));
        });
  }
}
