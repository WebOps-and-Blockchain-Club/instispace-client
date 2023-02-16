import 'package:client/screens/home/feed/actions.dart';
import 'package:client/themes.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../events/actions.dart';
import '../events/new_event.dart';
import '../../../widgets/buttom_sheet/main.dart';
import '../../../widgets/card/postcard.dart';
import '../../../widgets/helpers/loading.dart';
import '../../../widgets/helpers/error.dart';
import '../../../widgets/helpers/navigate.dart';
import '../../hostel/main.dart';
import '../../../utils/custom_icons.dart';
import '../tag/select_tags.dart';
import '../../../widgets/headers/main.dart';
//import '../../../widgets/card/main.dart';
import '../../../widgets/button/icon_button.dart';
import '../../../widgets/utils/main.dart';
import '../../../graphQL/events.dart';
import '../../../graphQL/feed.dart';
import '../../../models/user.dart';
import '../../../models/event.dart';
import '../../../models/postModel.dart';
//import '../../../models/post.dart';
import '../../../models/category.dart';
import '../../../models/tag.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../widgets/utils/image_cache_path.dart';
import '../../../widgets/card/image_view.dart';

class FeedPage extends StatefulWidget {
  final UserModel user;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String title;
  const FeedPage(
      {Key? key,
      required this.user,
      required this.scaffoldKey,
      required this.title})
      : super(key: key);
  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final isStaredTagModel =
      TagModel(id: "isStared", title: "Pinned", category: "Custom");
  final orderByLikesTagModel = TagModel(
      id: "orderByLikes", title: "Likes: High to Low", category: "Custom");

  //Variables

  late List<PostCategoryModel> selectedCategories = [];
  bool orderByLikes = false;
  bool isStared = false;
  late TagsModel selectedTags = TagsModel.fromJson([]);
  String search = "";
  int skip = 0;
  int take = 10;
  bool _showSearchBar = true;

  late String searchValidationError = "";

  //Controllers

  final ScrollController _scrollController = ScrollController();

  PostCategoryModel? typeOfPost(PostModel post) {
    for (var cat in feedCategories) {
      if (cat.name.toLowerCase() == post.category.toLowerCase()) return cat;
    }
    for (var cat in forumCategories) {
      if (cat.name.toLowerCase() == post.category.toLowerCase()) return cat;
    }
    return null;
  }

  List<String> postCategoryModeltoString(List<PostCategoryModel> cats) {
    List<String> s = [];
    for (var cat in cats) {
      s.add(cat.name);
    }
    return s;
  }

  setFilters(TagsModel _selectedTags) {
    setState(() {
      isStared = _selectedTags.contains(isStaredTagModel);
      orderByLikes = _selectedTags.contains(orderByLikesTagModel);
      _selectedTags.remove(isStaredTagModel);
      _selectedTags.remove(orderByLikesTagModel);
      selectedTags = _selectedTags;
    });
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _scaffoldKey = widget.scaffoldKey;
    List<PostCategoryModel> categories =
        widget.title.toLowerCase() == 'feed' ? feedCategories : forumCategories;
    final Map<String, dynamic> variables = {
      "take": take,
      "lastEventId": "",
      "orderInput": {
        "byLikes": orderByLikes ? true : false,
        "byComments": false
      },
      "filteringCondition": {
        "search": search.trim(),
        "posttobeApproved": false,
        "isSaved": false,
        "showOldPost": false,
        "isLiked": false,
        "categories": postCategoryModeltoString(selectedCategories),
      },
    };
    final QueryOptions<Object?> options =
        QueryOptions(document: gql(FeedGQL().findPosts), variables: variables);
    return Query(
        options: options,
        builder: (QueryResult result, {FetchMore? fetchMore, refetch}) {
          //print(result);
          return Scaffold(
            //resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: RefreshIndicator(
                  onRefresh: () => refetch!(),
                  child: NestedScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _scrollController,
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            return AppBar(
                                primary: true,
                                centerTitle: true,
                                title: Text(
                                  widget.title.toUpperCase(),
                                  style: TextStyle(
                                      letterSpacing: 2.64,
                                      color: Color(0xFF3C3C3C),
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700),
                                ),
                                leading: IconButton(
                                  onPressed: () => widget
                                      .scaffoldKey.currentState!
                                      .openDrawer(),
                                  icon: Icon(
                                    CustomIcons.hamburger,
                                    size: 22,
                                    color: Color(0xFF3C3C3C),
                                  ),
                                ),
                                actions: [
                                  GestureDetector(
                                    onTap: () async {
                                      List<String> images =
                                          await imageCachePath(
                                              [widget.user.photo]);
                                      openImageView(context, 0, images);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(
                                        7.5,
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "https://source.unsplash.com/Mv9hjnEUHR4",
                                        placeholder: (_, __) => const Icon(
                                            Icons.account_circle_rounded,
                                            size: 58),
                                        errorWidget: (_, __, ___) => const Icon(
                                            Icons.account_circle_rounded,
                                            size: 58),
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          height: 58,
                                          width: 58,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]);
                          }, childCount: 1),
                        ),
                        // SliverPersistentHeader(
                        //   pinned: true,
                        //   floating: true,
                        //   delegate: SearchBarDelegate(
                        //     additionalHeight:
                        //         searchValidationError != "" ? 18 : 0,
                        //     searchUI: SearchBar(
                        //       padding:
                        //           const EdgeInsets.symmetric(vertical: 10.0),
                        //       onSubmitted: (value) {
                        //         if (value.isEmpty || value.length >= 4) {
                        //           setState(() {
                        //             search = value;
                        //             searchValidationError = "";
                        //           });
                        //           refetch!();
                        //         } else {
                        //           setState(() {
                        //             searchValidationError =
                        //                 "Enter at least 4 characters";
                        //           });
                        //         }
                        //       },
                        //       error: searchValidationError,
                        //       onFilterClick: () {
                        //         if (orderByLikes) {
                        //           selectedTags.add(orderByLikesTagModel);
                        //         }
                        //         if (isStared) {
                        //           selectedTags.add(isStaredTagModel);
                        //         }
                        //         showModalBottomSheet(
                        //           context: context,
                        //           builder: (BuildContext context) => buildSheet(
                        //               context,
                        //               (controller) => SelectTags(
                        //                     selectedTags: selectedTags,
                        //                     controller: controller,
                        //                     callback: (value) {
                        //                       setState(() {
                        //                         selectedTags = value;
                        //                       });
                        //                     },
                        //                     additionalCategory: CategoryModel(
                        //                         category: "Custom",
                        //                         tags: [
                        //                           TagModel(
                        //                               id: "isStared",
                        //                               title: "Saved",
                        //                               category: "Custom"),
                        //                           TagModel(
                        //                               id: "orderByLikes",
                        //                               title:
                        //                                   "Likes: High to Low",
                        //                               category: "Custom")
                        //                         ]),
                        //                   )),
                        //           isScrollControlled: true,
                        //         );
                        //       },
                        //     ),
                        //   ),
                        // )
                      ];
                    },
                    body: (() {
                      if (result.hasException) {
                        return Error(error: result.exception.toString());
                      }

                      if (result.isLoading && result.data == null) {
                        return const Loading();
                      }
                      if (result.data!['findPosts']['total'] == 0) {
                        return Container(
                          child: Text('NO POSTS'),
                        );
                      }
                      final List<PostModel> posts = [];
                      for (var map in result.data!['findPosts']['list']) {
                        posts.add(PostModel.fromJson(map));
                      }
                      if (posts.isEmpty) {
                        return Container();
                      }

                      final total = result.data!["findPosts"]["total"];
                      FetchMoreOptions opts = FetchMoreOptions(
                          variables: {
                            ...variables,
                            "lastEventId": posts.last.id
                          },
                          updateQuery:
                              (previousResultData, fetchMoreResultData) {
                            final List<dynamic> repos = [
                              ...previousResultData!['findPosts']['list']
                                  as List<dynamic>,
                              ...fetchMoreResultData!["findPosts"]["list"]
                                  as List<dynamic>
                            ];
                            fetchMoreResultData["findPosts"]["list"] = repos;
                            return fetchMoreResultData;
                          });

                      return NotificationListener<UserScrollNotification>(
                        onNotification: (notification) {
                          /*if (notification.metrics.pixels >
                                  0.8 * notification.metrics.maxScrollExtent &&
                              total > posts.length) {
                            fetchMore!(opts);
                          }*/

                          final ScrollDirection direction =
                              notification.direction;
                          setState(() {
                            if (direction == ScrollDirection.reverse) {
                              _showSearchBar = false;
                            } else if (direction == ScrollDirection.forward) {
                              _showSearchBar = true;
                            }
                          });

                          return true;
                        },
                        child: RefreshIndicator(
                          onRefresh: () {
                            return refetch!();
                          },
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 22,
                                ),
                                SearchBar(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  onSubmitted: (value) {
                                    if (value.isEmpty || value.length >= 4) {
                                      setState(() {
                                        search = value;
                                        searchValidationError = "";
                                      });
                                      refetch!();
                                    } else {
                                      setState(() {
                                        searchValidationError =
                                            "Enter at least 4 characters";
                                      });
                                    }
                                  },
                                  error: searchValidationError,
                                  onFilterClick: () {
                                    if (orderByLikes) {
                                      selectedTags.add(orderByLikesTagModel);
                                    }
                                    if (isStared) {
                                      selectedTags.add(isStaredTagModel);
                                    }
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          buildSheet(
                                              context,
                                              (controller) => SelectTags(
                                                    selectedTags: selectedTags,
                                                    controller: controller,
                                                    callback: (value) {
                                                      setState(() {
                                                        selectedTags = value;
                                                      });
                                                    },
                                                    additionalCategory:
                                                        CategoryModel(
                                                            category: "Custom",
                                                            tags: [
                                                          TagModel(
                                                              id: "isStared",
                                                              title: "Saved",
                                                              category:
                                                                  "Custom"),
                                                          TagModel(
                                                              id:
                                                                  "orderByLikes",
                                                              title:
                                                                  "Likes: High to Low",
                                                              category:
                                                                  "Custom")
                                                        ]),
                                                  )),
                                      isScrollControlled: true,
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                SizedBox(
                                  height: 32,
                                  child: ListView.builder(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      physics: const ClampingScrollPhysics(),
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: categories.length,
                                      itemBuilder: (BuildContext context,
                                              int index) =>
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                //print(feategories);
                                                setState(() {
                                                  if (selectedCategories
                                                      .contains(
                                                          categories[index]))
                                                    selectedCategories.remove(
                                                        categories[index]);
                                                  else
                                                    selectedCategories
                                                        .add(categories[index]);
                                                });
                                              },
                                              child: AnimatedContainer(
                                                duration:
                                                    Duration(milliseconds: 200),
                                                decoration: BoxDecoration(
                                                    color: selectedCategories
                                                            .contains(
                                                                categories[
                                                                    index])
                                                        ? Colors.black
                                                        : Color(0xFFEEEEEE),
                                                    borderRadius:
                                                        BorderRadiusDirectional
                                                            .circular(15)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        categories[index].icon,
                                                        size: 15,
                                                        color: selectedCategories
                                                                .contains(
                                                                    categories[
                                                                        index])
                                                            ? Colors.white
                                                            : Color(0xFF505050),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        categories[index].name,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: selectedCategories
                                                                    .contains(
                                                                        categories[
                                                                            index])
                                                                ? Colors.white
                                                                : Color(
                                                                    0xFF505050)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                for (var index = 0;
                                    index < posts.length;
                                    index++)
                                  if ((widget.title.toLowerCase() == "forum" &&
                                          forumCategories.contains(
                                              typeOfPost(posts[index]))) ||
                                      (widget.title.toLowerCase() == "feed" &&
                                          feedCategories.contains(
                                              typeOfPost(posts[index]))))
                                    Container(
                                        child: PostCard(
                                      post: posts[index],
                                      actions:
                                          postActions(posts[index], options),
                                      scaffoldKey: _scaffoldKey,
                                    ))
                              ],
                            ),
                          ),
                        ),
                      );
                    }()),
                  ),
                ),
              ),
            ),
            /*floatingActionButton: AnimatedSlide(
              duration: const Duration(milliseconds: 300),
              offset: _showFab ? Offset.zero : const Offset(0, 2),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _showFab ? 1 : 0,
                child: widget.user.permissions.contains("CREATE_EVENT")
                    ? FloatingActionButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => NewEvent(
                                    options: options,
                                  )));
                        },
                        child: const Icon(Icons.add))
                    : null,
              ),
            ),*/
          );
        });
  }
}
