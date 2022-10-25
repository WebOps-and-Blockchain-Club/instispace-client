import 'package:client/models/query.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../events/actions.dart';
import '../../../models/query.dart';
import '../../../models/event.dart';
import '../../../widgets/page/post.dart';
import '../../../graphQL/query.dart';
import 'actions.dart';

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
    //print(options);
    return PostPage(
      header: "Query",
      queryOptions: options,
      toPostsModel: (data) =>
          QueryModel.fromJson(data!["getMyQuery"]).toPostModel(),
      actions: (post) => eventActions(post, options),
    );
  }
}
