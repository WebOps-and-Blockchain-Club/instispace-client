import 'package:client/screens/home/chooseImages.dart';
import 'package:client/themes.dart';
import 'package:client/widgets/button/catList.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'actions.dart';
import '../../../widgets/card/image_view.dart';
import '../../teasure_hunt/main.dart';
import '../../hostel/main.dart';
import '../../../widgets/helpers/navigate.dart';
import '../../../services/auth.dart';
import '../../../models/user.dart';
import '../../../models/post.dart';
import '../../../widgets/button/icon_button.dart';
import '../../../widgets/card/main.dart';
import '../../../widgets/headers/main.dart';
import '../../../widgets/helpers/error.dart';
import '../../../widgets/utils/image_cache_path.dart';
import '../../../themes.dart';
import '../../../utils/custom_icons.dart';

class HomePage extends StatefulWidget {
  final AuthService auth;
  final UserModel user;
  final Future<void> Function() refetch;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const HomePage(
      {Key? key,
      required this.auth,
      required this.user,
      required this.refetch,
      required this.scaffoldKey})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  bool show = false;

  @override
  Widget build(BuildContext context) {
    final List<HomeModel>? home = widget.user.toHomeModel();
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
            resizeToAvoidBottomInset: false,
            body: SafeArea(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: RefreshIndicator(
                      onRefresh: () => widget.refetch(),
                      child: NestedScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: _scrollController,
                        headerSliverBuilder: (context, innerBoxIsScrolled) {
                          return [
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                return CustomAppBar(
                                  title: "",
                                  leading: IconButton(
                                    onPressed: () => widget
                                        .scaffoldKey.currentState!
                                        .openDrawer(),
                                    icon: Icon(CustomIcons.hamburger),
                                  ),
                                  action: GestureDetector(
                                    onTap: () async {
                                      List<String> images =
                                          await imageCachePath(
                                              [widget.user.photo]);
                                      openImageView(context, 0, images);
                                    },
                                    child: CachedNetworkImage(
                                      imageUrl: widget.user.photo,
                                      placeholder: (_, __) => const Icon(
                                          Icons.account_circle_rounded,
                                          size: 45),
                                      errorWidget: (_, __, ___) => const Icon(
                                          Icons.account_circle_rounded,
                                          size: 45),
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        height: 45,
                                        width: 45,
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
                                );
                              }, childCount: 1),
                            ),
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 7.5),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          widget.user.name!.toUpperCase(),
                                          style: TextStyle(
                                              color: Color(0xFF3C3C3C),
                                              fontFamily: 'Proxima Nova',
                                              fontSize: 30,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          widget.user.roll!.toUpperCase(),
                                          style: TextStyle(
                                              color: Color(0xFF3C3C3C),
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Proxima Nova',
                                              fontSize: 20),
                                        )
                                      ]),
                                );
                              }, childCount: 1),
                            ),
                          ];
                        },
                        body: RefreshIndicator(
                          onRefresh: () => widget.refetch(),
                          child: NestedScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            controller: _scrollController,
                            headerSliverBuilder: (context, innerBoxIsScrolled) {
                              return [
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                      (BuildContext context, int index) {
                                    return CustomAppBar(
                                      title: "InstiSpace",
                                      leading: CustomIconButton(
                                          icon: Icons.menu,
                                          onPressed: () => {
                                                widget.scaffoldKey.currentState!
                                                    .openDrawer()
                                              }),
                                      action: (widget.user.hostelId != null ||
                                              widget.user.permissions
                                                  .contains("HOSTEL_ADMIN"))
                                          ? CustomIconButton(
                                              icon: Icons
                                                  .account_balance_outlined,
                                              onPressed: () => navigate(
                                                  context,
                                                  HostelWrapper(
                                                      user: widget.user)))
                                          : null,
                                    );
                                  }, childCount: 1),
                                ),
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Header(
                                          title: "Hi ${widget.user.name}",
                                          subTitle: "Get InstiSpace feed here"),
                                    );
                                  }, childCount: 1),
                                ),
                              ];
                            },
                            body: RefreshIndicator(
                              onRefresh: () => widget.refetch(),
                              child: Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: (home == null || home.isEmpty)
                                      ? const Error(error: "No Posts")
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: home.length,
                                          itemBuilder: (context, index) =>
                                              Section(
                                                  user: widget.user,
                                                  title: home[index].title,
                                                  posts: home[index].posts))),
                            ),
                          ),
                        ),
                      ),
                    ))),
            floatingActionButton: FloatingActionButton(
              backgroundColor: ColorPalette.palette(context).secondary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: const Icon(Icons.add),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return const CategoryList(categories: [
                        'Queries',
                        'Help',
                        'Announcements',
                        'Opportunities',
                        'Recruitment',
                        'Lost',
                        'Found',
                        'Connect',
                        'Events',
                        'Random'
                      ]);
                    });
              },
            )));
  }
}

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
