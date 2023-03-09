import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../models/category.dart';
import '../home/post/query.dart';
import '../../models/post/main.dart';
import '../../models/post/query_variable.dart';
import '../../../graphQL/feed.dart';

class SuperUserPostPage extends StatefulWidget {
  final String title;
  final PostQueryVariableModel filterVariables;

  const SuperUserPostPage(
      {Key? key, required this.title, required this.filterVariables})
      : super(key: key);

  @override
  State<SuperUserPostPage> createState() => _SuperUserPostPageState();
}

class _SuperUserPostPageState extends State<SuperUserPostPage> {
  late List<PostCategoryModel> selectedCategories = [];
  String search = "";
  int take = 10;

  @override
  Widget build(BuildContext context) {
    final QueryOptions<Object?> options = QueryOptions(
      document: gql(FeedGQL().findPosts(
          relations:
              widget.filterVariables.viewReportedPosts ? ["REPORT"] : null)),
      variables: widget.filterVariables.toJson(),
      parserFn: (data) => PostsModel.fromJson(data),
    );

    return Scaffold(
      body: NestedScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: ScrollController(),
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
          return <Widget>[
            // AppBar
            SliverAppBar(
              centerTitle: true,
              title: Text(
                widget.title,
                style: const TextStyle(
                    letterSpacing: 2.64,
                    color: Color(0xFF3C3C3C),
                    fontSize: 24,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ];
        },
        body: PostQuery(
          options: options,
          endofwidget: false,
        ),
      ),
    );
  }
}
