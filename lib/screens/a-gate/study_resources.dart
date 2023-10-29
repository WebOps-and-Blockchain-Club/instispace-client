import 'package:client/graphQL/feed.dart';
import 'package:client/models/post/main.dart';
import 'package:client/models/post/query_variable.dart';
import 'package:client/screens/home/new_post/main.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../models/category.dart';
import '../../utils/custom_icons.dart';
import '../../widgets/helpers/navigate.dart';
import '../home/post/main.dart';

class StudyResourcesScreen extends StatefulWidget {
  const StudyResourcesScreen({super.key});
  @override
  State<StudyResourcesScreen> createState() => _StudyResourcesScreenState();
}

class _StudyResourcesScreenState extends State<StudyResourcesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: _scaffoldKey,
      body: PostPage(
        appBar: SliverAppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        // appBar: HomeAppBar(
        //   title: "Forum",
        //   // scaffoldKey: _scaffoldKey,
        //   user: widget.user,
        // ),
        categories: [
          PostCategoryModel(
              name: "Study Resources", icon: CustomIcons.opportunities)
        ],
        createPost: false,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigate(
              context,
              NewPostWrapper(
                options: QueryOptions(
                    document: gql(FeedGQL().findPosts()),
                    variables: PostQueryVariableModel(
                      showNewPost: true,
                      search: '',
                      categories: [
                        PostCategoryModel(
                            name: "Study Resources",
                            icon: CustomIcons.opportunities)
                      ],
                    ).toJson(),
                    parserFn: (data) => PostsModel.fromJson(data)),
                category: PostCategoryModel(
                    name: "Study Resources", icon: CustomIcons.opportunities),
              ));
        },
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.add),
      ),
    );
    ;
  }
}
