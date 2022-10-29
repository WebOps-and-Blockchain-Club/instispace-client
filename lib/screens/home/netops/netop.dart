import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'actions.dart';
import '../../../models/post.dart';
import '../../../models/netop.dart';
import '../../../widgets/page/post.dart';
import '../../../graphQL/netops.dart';

class NetopPage extends StatefulWidget {
  final String id;
  const NetopPage({Key? key, required this.id}) : super(key: key);

  @override
  State<NetopPage> createState() => _NetopPageState();
}

class _NetopPageState extends State<NetopPage> {
  @override
  Widget build(BuildContext context) {
    final QueryOptions<Object?> options =
        QueryOptions(document: gql(NetopGQL.get), variables: {"id": widget.id});
    return PostPage(
      header: "Networking",
      queryOptions: options,
      toPostsModel: (data) =>
          NetopModel.fromJson(data!["getNetop"]).toPostModel(),
      actions: (post) => PostActions(
        edit: netopEditAction(post, options),
        delete: PostAction(
          id: post.id,
          document: NetopGQL.delete,
          updateCache: (cache, result) {
            Navigator.of(context).pop();
          },
        ),
        like: netopLikeAction(post, options),
        star: netopStarAction(post, options),
        report: PostAction(
            id: post.id,
            document: NetopGQL.report,
            updateCache: (cache, result) {
              Navigator.of(context).pop();
            }),
        comment: netopCommentAction(post),
      ),
    );
  }
}
