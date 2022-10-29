import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'actions.dart';
import '../../../models/post.dart';
import '../../../models/query.dart';
import '../../../widgets/page/post.dart';
import '../../../graphQL/query.dart';

class QueryPage extends StatefulWidget {
  final String id;
  const QueryPage({Key? key, required this.id}) : super(key: key);

  @override
  State<QueryPage> createState() => _QueryPageState();
}

class _QueryPageState extends State<QueryPage> {
  @override
  Widget build(BuildContext context) {
    final QueryOptions<Object?> options = QueryOptions(
        document: gql(QueryGQL().get), variables: {"myQueryId": widget.id});
    return PostPage(
      header: "Query",
      queryOptions: options,
      toPostsModel: (data) =>
          QueryModel.fromJson(data!["getMyQuery"]).toPostModel(),
      actions: (post) => PostActions(
        edit: editQueryAction(post, options),
        delete: PostAction(
          id: post.id,
          document: QueryGQL.delete,
          updateCache: (cache, result) {
            Navigator.of(context).pop();
          },
        ),
        like: likeQueryAction(post, options),
        report: PostAction(
            id: post.id,
            document: QueryGQL.report,
            updateCache: (cache, result) {
              Navigator.of(context).pop();
            }),
        comment: commentQueryAction(post),
      ),
    );
  }
}
