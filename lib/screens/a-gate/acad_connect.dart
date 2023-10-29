import 'package:client/graphQL/tag.dart';
import 'package:client/graphQL/user.dart';
import 'package:client/screens/home/new_post/newPostButton.dart';
import 'package:client/services/client.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../graphQL/feed.dart';
import '../../models/category.dart';
import '../../models/post/main.dart';
import '../../models/post/query_variable.dart';
import '../../models/tag.dart';
import '../../utils/custom_icons.dart';
import '../../widgets/helpers/navigate.dart';
import '../home/new_post/main.dart';
import '../super_user/approve_post.dart';

class AcadConnectScreen extends StatelessWidget {
  const AcadConnectScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PostListByTag("Acad Connect"),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigate(
              context,
              NewPostWrapper(
                prefilledTag: ('Acad Connect'),
                options: QueryOptions(
                    document: gql(FeedGQL().findPosts()),
                    variables: PostQueryVariableModel(
                      showNewPost: true,
                      search: '',
                      categories: [
                        PostCategoryModel(
                            name: "Query", icon: CustomIcons.queries)
                      ],
                    ).toJson(),
                    parserFn: (data) => PostsModel.fromJson(data)),
                category:
                    PostCategoryModel(name: "Query", icon: CustomIcons.queries),
              ));
        },
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class PostListByTag extends StatelessWidget {
  const PostListByTag(this.name, {super.key});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(document: gql(r"""
query GetTagByName($name: String!) {
  getTagByName(name: $name) {
    id
  }
}
    """), variables: {
        'name': name,
      }),
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
          title: 'A GATE',
          filterVariables: PostQueryVariableModel(
            tags: [TagModel(id: id, title: name, category: 'Query')],
          ),
        );
      },
    );
  }
}
