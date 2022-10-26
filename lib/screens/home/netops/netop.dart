import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'actions.dart';
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
    final QueryOptions<Object?> options = QueryOptions(
        document: gql(NetopGQL.get), variables: {"id": widget.id});
    return PostPage(
      header: "Networking",
      queryOptions: options,
      toPostsModel: (data) =>
          NetopModel.fromJson(data!["getNetop"]).toPostModel(),
      actions: (post) => netopActions(post, options),
    );
  }
}
