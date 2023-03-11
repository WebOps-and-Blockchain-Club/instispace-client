import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '/graphQL/post.dart';
import '../../../models/post/main.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/helpers/error.dart';
import 'card/main.dart';

class SinglePostScreen extends StatefulWidget {
  final String id;
  const SinglePostScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<SinglePostScreen> createState() => _SinglePostScreenState();
}

class _SinglePostScreenState extends State<SinglePostScreen> {
  @override
  Widget build(BuildContext context) {
    final options = QueryOptions(
        document: gql(PostGQl.getOne),
        variables: {
          "postid": widget.id,
        },
        parserFn: (data) => PostModel.fromJson(data['findOnePost']));
    return Scaffold(
        body: NestedScrollView(
      // physics: const AlwaysScrollableScrollPhysics(),
      controller: ScrollController(),
      floatHeaderSlivers: true,
      headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
        return <Widget>[
          // AppBar
          secondaryAppBar(title: 'Post'),
        ];
      },
      body: Query(
        options: options,
        builder: (result, {fetchMore, refetch}) {
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

          final PostModel? post = result.parsedData as PostModel?;

          if (post == null) {
            return Center(
              child: Error(
                error: '',
                message: 'No data found.',
                onRefresh: refetch,
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () {
              return refetch!();
            },
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: PostCard(
                    post: post,
                    options: options,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ));
  }
}
