import 'package:client/models/user.dart';
import 'package:client/widgets/search_bar.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:graphql_flutter/graphql_flutter.dart';

import 'query.dart';
import '../new_post/newPostButton.dart';
import '../../../graphQL/feed.dart';
import '../../../models/category.dart';
import '../../../models/post/query_variable.dart';
import '../../../models/post/main.dart';
import '../../../widgets/primary_filter.dart';
import '../../../widgets/search_bar.dart' as search;

class PostPage extends StatefulWidget {
  final Widget appBar;
  final List<PostCategoryModel> categories;
  final bool createPost;
  final UserModel user;
  const PostPage(
      {Key? key,
      required this.appBar,
      required this.categories,
      required this.user,
      this.createPost = false})
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
                showNewPost: true,
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
                  child: PrimaryFilter<PostCategoryModel>(
                    options: categories,
                    optionIconBuilder: (e) => e.icon,
                    optionTextBuilder: (e) => e.name,
                    onSelect: (value) {
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
        body: PostQuery(
          options: options,
          categories: selectedCategories.isNotEmpty
              ? selectedCategories
              : widget.categories,
        ),
      ),
      floatingActionButton: widget.createPost
          ? NewPostButton(
              options: options,
              categories: widget.categories,
              user: widget.user)
          : null,
    );
  }
}
