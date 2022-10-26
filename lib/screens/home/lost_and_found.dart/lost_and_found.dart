import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'actions.dart';
import '../../../models/lost_and_found.dart';
import '../../../widgets/page/post.dart';
import '../../../graphQL/lost_and_found.dart';

class LostnFoundPage extends StatefulWidget {
  final String id;
  const LostnFoundPage({Key? key, required this.id}) : super(key: key);

  @override
  State<LostnFoundPage> createState() => _LostnFoundPageState();
}

class _LostnFoundPageState extends State<LostnFoundPage> {
  @override
  Widget build(BuildContext context) {
    final QueryOptions<Object?> options = QueryOptions(
        document: gql(LostAndFoundGQL.get), variables: {"id": widget.id});
    return PostPage(
      header: "Lost and Found",
      queryOptions: options,
      toPostsModel: (data) =>
          LostAndFoundItemModel.fromJson(data!["getItem"]).toPostModel(),
      actions: (post) => lostAndFoundActions(post, options),
    );
  }
}
