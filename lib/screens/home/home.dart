import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../services/auth.dart';
import '../../models/post.dart';
import '../../graphQL/events.dart';
import '../../widgets/button/icon_button.dart';
import '../../widgets/card/main.dart';
import '../../widgets/headers/main.dart';
import 'hostelSection/hostel.dart';

class HomePage extends StatefulWidget {
  final AuthService auth;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const HomePage({Key? key, required this.auth, required this.scaffoldKey})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final AuthService auth = widget.auth;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: RefreshIndicator(
            onRefresh: () => auth.clearUser(),
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
                                  widget.scaffoldKey.currentState!.openDrawer()
                                }),
                        action: CustomIconButton(
                            icon: Icons.account_balance_outlined,
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const HostelHome()))),
                      );
                    }, childCount: 1),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Header(
                            title: "Hi ${auth.user!.name}",
                            subTitle: "Get InstiSpace feeds here"),
                      );
                    }, childCount: 1),
                  ),
                ];
              },
              body: RefreshIndicator(
                onRefresh: () => auth.clearUser(),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        if (auth.user != null &&
                            (auth.user!.announcements == null ||
                                auth.user!.announcements!.isEmpty) &&
                            (auth.user!.events == null ||
                                auth.user!.events!.isEmpty) &&
                            (auth.user!.netops == null ||
                                auth.user!.netops!.isEmpty))
                          const Text("No Posts"),
                        if (auth.user != null &&
                            auth.user!.announcements != null &&
                            auth.user!.announcements!.isNotEmpty)
                          Section(
                              title: "Announcements",
                              posts: auth.user!.announcements!
                                  .map((e) => e.toPostModel())
                                  .toList()),
                        if (auth.user != null &&
                            auth.user!.events != null &&
                            auth.user!.events!.isNotEmpty)
                          Section(
                              title: "Events",
                              posts: auth.user!.events!
                                  .map((e) => e.toPostModel())
                                  .toList()),
                        if (auth.user != null &&
                            auth.user!.netops != null &&
                            auth.user!.netops!.isNotEmpty)
                          Section(
                              title: "Networking & Opportunities",
                              posts: auth.user!.netops!
                                  .map((e) => e.toPostModel())
                                  .toList()),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          auth.logout();
        },
        backgroundColor: const Color(0xFF2f247b),
        child: const Icon(Icons.logout),
        elevation: 5,
      ),
    );
  }
}

class Section extends StatefulWidget {
  final String title;
  final List<PostModel> posts;
  final Future<QueryResult<Object?>?> Function()? refetch;
  const Section(
      {Key? key, required this.title, required this.posts, this.refetch})
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
                  style: const TextStyle(
                      color: Color(0xFF2f247b),
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
                isMinimized
                    ? const Icon(
                        Icons.arrow_drop_down,
                        color: Color(0xFF2f247b),
                      )
                    : const Icon(
                        Icons.arrow_drop_up,
                        color: Color(0xFF2f247b),
                      )
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
                    return PostCard(
                      post: widget.posts[index],
                      refetch: widget.refetch,
                      deleteMutationDocument: EventGQL().delete,
                    );
                  }),
            ),
          ),
      ],
    );
  }
}
