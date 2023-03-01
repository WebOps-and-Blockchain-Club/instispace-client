import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'query.dart';
import '../../../graphQL/feed.dart';
import '../../../models/post/query_variable.dart';
import '../../../models/post/actions.dart';
import '../../../models/post/main.dart';
import '../../../widgets/primary_filter.dart';
import '../../../widgets/search_bar.dart';

class PostPage extends StatefulWidget {
  final Widget appBar;
  final List<PostCategoryModel> categories;
  const PostPage({Key? key, required this.appBar, required this.categories})
      : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  late List<PostCategoryModel> selectedCategories = [];
  String search = "";

  @override
  Widget build(BuildContext context) {
    final List<PostCategoryModel> categories = widget.categories;

    final QueryOptions<Object?> options = QueryOptions(
        document: gql(FeedGQL().findPosts()),
        variables: PostQueryVariableModel(
                search: search,
                categories: selectedCategories.isEmpty
                    ? categories
                    : selectedCategories)
            .toJson(),
        parserFn: (data) => PostsModel.fromJson(data));

    return Scaffold(
      body: NestedScrollView(
        // physics: const AlwaysScrollableScrollPhysics(),
        controller: ScrollController(),
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
          return <Widget>[
            // AppBar
            widget.appBar,

            // SearchBar & Categories Filter
            SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SearchBar(
                    onSubmitted: (value) {
                      setState(() {
                        search = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: PrimaryFilter(
                    categories: categories,
                    onCategoryTab: (value) {
                      setState(() {
                        selectedCategories = value;
                      });
                    },
                  ),
                ),
              ]),
            ),
          ];
        },
        body: PostQuery(options: options, categories: widget.categories),
      ),
    );
  }
}