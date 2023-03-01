import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '/themes.dart';
import '../post/query.dart';
import '../../../models/post/actions.dart';
import '../../../models/post/query_variable.dart';
import '../../../models/post/main.dart';
import '../../../models/user.dart';
import '../../../services/auth.dart';
import '../../../widgets/button/catList.dart';
import '../../../graphQL/feed.dart';

class HomePage extends StatefulWidget {
  final AuthService auth;
  final UserModel user;
  final Widget appBar;

  const HomePage(
      {Key? key, required this.auth, required this.user, required this.appBar})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  bool show = false;

  int take = 10;

  @override
  Widget build(BuildContext context) {
    final QueryOptions<Object?> options = QueryOptions(
        document: gql(FeedGQL().findPosts()),
        variables: PostQueryVariableModel(categories: feedCategories).toJson(),
        parserFn: (data) => PostsModel.fromJson(data));

    return WillPopScope(
      onWillPop: () async {
        return true;
        // if (_scrollController.offset != 0.0) {
        //   _scrollController.animateTo(0.0,
        //       duration: const Duration(milliseconds: 250),
        //       curve: Curves.easeIn);
        //   return false;
        // } else {
        //   return true;
        // }
      },
      child: Scaffold(
        body: NestedScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                    child: Text(
                      widget.user.name?.toUpperCase() ?? "",
                      style: const TextStyle(
                        color: Color(0xFF3C3C3C),
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      widget.user.role == 'USER'
                          ? widget.user.roll?.toUpperCase() ?? ""
                          : widget.user.role ?? "",
                      style: const TextStyle(
                        color: Color(0xFF3C3C3C),
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        letterSpacing: 2.25,
                      ),
                    ),
                  ),
                ]),
              ),
            ];
          },
          body: PostQuery(options: options),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: ColorPalette.palette(context).secondary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: const Icon(Icons.add, size: 25),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return CategoryList(
                      options: options,
                      categories:
                          feedCategories + forumCategories + lnfCategories);
                });
          },
        ),
      ),
    );
  }
}
