import 'package:client/graphQL/tag.dart';
import 'package:client/graphQL/user.dart';
import 'package:client/services/client.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../models/post/query_variable.dart';
import '../../models/tag.dart';
import '../super_user/approve_post.dart';

class AcadConnectScreen extends StatelessWidget {
  const AcadConnectScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PostListByTag("Acad Connet"),
    );
  }
}

class PostListByTag extends StatelessWidget {
  const PostListByTag(this.name, {super.key});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql("""
        query GetTagByName {
          getTagByName(name:"Acad Connect") {
            id
          }
        }
    """),
      ),
      builder: (QueryResult result, {fetchMore, refetch}) {
        if (result.hasException) {
          return Text('Error: ${result.exception.toString()}');
        }

        if (result.isLoading) {
          return CircularProgressIndicator();
        }

        final responseData = result.data;

        String id = responseData?['getTagByName']['id'];

        return SuperUserPostPage(
          title: 'Acad Connect',
          filterVariables: PostQueryVariableModel(
            tags: [TagModel(id: id, title: name, category: 'Query')],
          ),
        );
      },
    );
  }
}
