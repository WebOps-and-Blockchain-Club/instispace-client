import 'package:client/widgets/search_bar.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../themes.dart';
import '../../widgets/helpers/navigate.dart';
import '../home/new_post/main.dart';
import 'mentalHealth_Utils/query.dart';
import '../home/new_post/newPostButton.dart';
import '../../../graphQL/feed.dart';
import '../../../models/category.dart';
import '../../../models/post/query_variable.dart';
import '../../../models/post/main.dart';
import '../../../widgets/primary_filter.dart';
import '../../../widgets/search_bar.dart' as search;

class mentalHealth extends StatefulWidget {
  const mentalHealth(
      {Key? key,
      required this.appBar,
      required this.categories,
      this.createPost = false})
      : super(key: key);
  final Widget appBar;
  final List<PostCategoryModel> categories;
  final bool createPost;

  @override
  State<mentalHealth> createState() => _mentalHealthState();
}

class _mentalHealthState extends State<mentalHealth> {
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
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
                //   child: PrimaryFilter<PostCategoryModel>(
                //     options: categories,
                //     optionIconBuilder: (e) => e.icon,
                //     optionTextBuilder: (e) => e.name,
                //     onSelect: (value) {
                //       setState(() {
                //         selectedCategories = value;
                //       });
                //     },
                //   ),
                // ),
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
      floatingActionButton: FloatingActionButton(
          backgroundColor: ColorPalette.palette(context).secondary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: const Icon(
            Icons.add,
            size: 30,
          ),
          onPressed: () {
            navigate(
                context,
                NewPostWrapper(
                  category: PostCategoryModel(name: 'Help', icon: Icons.help),
                  options: options,
                ));
          }),
    );
  }
}
