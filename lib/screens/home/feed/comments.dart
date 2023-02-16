import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../../../models/postModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../widgets/utils/image_cache_path.dart';
import '../../../widgets/card/image_view.dart';
import '../../../utils/custom_icons.dart';

class Comments extends StatefulWidget {
  final PostModel post;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const Comments({Key? key, required this.post, required this.scaffoldKey})
      : super(key: key);

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    PostModel post = widget.post;
    return Scaffold(
        //resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
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
                                'COMMENTS',
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
                            );
                          }, childCount: 1),
                        )
                      ];
                    },
                    body: ListView.builder(
                      itemBuilder: (context, index) =>
                          Container(),
                    )))));
  }
}
