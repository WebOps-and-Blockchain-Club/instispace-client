import 'package:client/models/post/actions.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../graphQL/user.dart';
import '../../../services/auth.dart';
import '/themes.dart';
import 'actions.dart';
import '../post/query.dart';
import '../../../widgets/button/catList.dart';
import '../../../graphQL/feed.dart';
import '../../../models/user.dart';
import '../../../models/post.dart';
import '../../../widgets/card/main.dart';

class HomePage extends StatefulWidget {
  final AuthService auth;
  final UserModel user;
  final Widget appBar;
  // final Future<void> Function() refetch;
  // final GlobalKey<ScaffoldState> scaffoldKey;

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
    // final List<HomeModel>? home = widget.user.toHomeModel();
    final Map<String, dynamic> variables = {
      "take": take,
      "lastEventId": "",
      "orderInput": {"byLikes": false, "byComments": false},
      "filteringCondition": {
        "search": null,
        "posttobeApproved": false,
        "isSaved": false,
        "showOldPost": false,
        "isLiked": false,
        "categories": null,
      },
    };
    final QueryOptions<Object?> options =
        QueryOptions(document: gql(FeedGQL().findPosts), variables: variables);

    return WillPopScope(
      onWillPop: () async {
        if (_scrollController.offset != 0.0) {
          _scrollController.animateTo(0.0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeIn);
          return false;
        } else {
          return true;
        }
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
                      widget.user.name!.toUpperCase(),
                      // "JANITH",
                      style: const TextStyle(
                        color: Color(0xFF3C3C3C),
                        fontFamily: 'Proxima Nova',
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.64,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      widget.user.roll!.toUpperCase(),
                      // "MM19B035",
                      style: const TextStyle(
                        color: Color(0xFF3C3C3C),
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Proxima Nova',
                        fontSize: 20,
                        letterSpacing: 2.64,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                ]),
              ),
            ];
          },
          body: Query(
            options: QueryOptions(document: gql(UserGQL().getMe)),
            builder: (result, {fetchMore, refetch}) {
              print("\n\n\n\ngetme query called");
              if (result.hasException) {
                return Text(result.exception.toString());
              }

              if (result.isLoading) {
                return const Text(
                  "Connecting to InstiSpace...",
                );
              }

              final UserModel user = UserModel.fromJson(result.data!["getMe"]);

              // widget.auth.updateUser(user);

              return PostQuery(options: options);
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: ColorPalette.palette(context).secondary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: const Icon(Icons.add),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return CategoryList(categories: [
                    PostCategoryModel.fromJson("Events"),
                    PostCategoryModel.fromJson("Recruitment"),
                    PostCategoryModel.fromJson("Announcements"),
                    PostCategoryModel.fromJson("Opportunities"),
                    PostCategoryModel.fromJson("Queries"),
                    PostCategoryModel.fromJson("Connect"),
                    PostCategoryModel.fromJson("Help"),
                    PostCategoryModel.fromJson("Random Thoughts"),
                    PostCategoryModel.fromJson("Lost"),
                    PostCategoryModel.fromJson("Found"),
                  ]);
                });
          },
        ),
      ),
    );
  }
}
/*
class Section extends StatefulWidget {
  final String title;
  final List<PostModel> posts;
  final UserModel user;
  const Section(
      {Key? key, required this.title, required this.posts, required this.user})
      : super(key: key);

  @override
  State<Section> createState() => _SectionState();
}

class _SectionState extends State<Section> {
  bool isMinimized = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: InkWell(
            onTap: () => setState(() {
              isMinimized = !isMinimized;
            }),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                isMinimized
                    ? const Icon(Icons.arrow_drop_down)
                    : const Icon(Icons.arrow_drop_up)
              ],
            ),
          ),
        ),
        if (!isMinimized)
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.posts.length,
                  itemBuilder: (context, index) {
                    final PostActions actions = homePostActions(
                        widget.user, widget.title, widget.posts[index]);
                    return PostCard(
                      post: widget.posts[index],
                      actions: actions,
                    );
                  }),
            ),
          ),
      ],
    );
  }
}
*/