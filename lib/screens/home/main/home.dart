import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../database/academic.dart';
import '../../../models/academic/course.dart';
import '../../../models/category.dart';
import '../../academics/time_table.dart';
import '../post/query.dart';
import '../../../models/post/query_variable.dart';
import '../../../models/post/main.dart';
import '../../../models/user.dart';
import '../../../services/auth.dart';
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

              SliverList(
                delegate: SliverChildListDelegate([
                  FutureBuilder<SlotModel?>(
                      future: AcademicDatabaseService.instance.fetchNextClass(),
                      builder: (context, snapshot) {
                        if ((snapshot.hasData ||
                                snapshot.connectionState ==
                                    ConnectionState.done) &&
                            snapshot.data != null) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 30),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Text(
                                  'Upcoming Class',
                                  style: TextStyle(
                                    color: Color(0xFF3C3C3C),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    letterSpacing: 2.25,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 20, right: 20.0, left: 20),
                                child: SlotCard(slot: snapshot.data!),
                              ),
                            ],
                          );
                        } else {
                          return Container();
                        }
                      })
                ]),
              ),

              SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 30),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Insti Posts',
                      style: TextStyle(
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
          body: PostQuery(
            options: options,
            endofwidget: false,
          ),
        ),
      ),
    );
  }
}
