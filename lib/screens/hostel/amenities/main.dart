import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'new_amenity.dart';
import 'actions.dart';
import '../shared/hostel_dropdown.dart';
import '../../../widgets/utils/main.dart';
import '../../../graphQL/amenities.dart';
import '../../../models/user.dart';
import '../../../widgets/headers/main.dart';
import '../../../widgets/card/main.dart';
import '../../../models/amenities.dart';
import '../../../models/post.dart';

class AmenitiesPage extends StatefulWidget {
  final UserModel user;
  const AmenitiesPage({Key? key, required this.user}) : super(key: key);

  @override
  State<AmenitiesPage> createState() => _AmenitiesPageState();
}

class _AmenitiesPageState extends State<AmenitiesPage> {
  //Controllers
  final ScrollController _scrollController = ScrollController();
  String search = "";
  String? selectedHostel;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> variables = {
      "hostelId": widget.user.hostelId ?? (selectedHostel ?? ""),
    };
    final QueryOptions<Object?> options =
        QueryOptions(document: gql(AmenitiesGQL.getAll), variables: variables);
    return Query(
        options: options,
        builder: (QueryResult result, {FetchMore? fetchMore, refetch}) {
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
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
                            return const Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Header(
                                  title: "Amenities",
                                ));
                          }, childCount: 1),
                        ),
                        SliverPersistentHeader(
                          pinned: true,
                          floating: true,
                          delegate: SearchBarDelegate(
                            additionalHeight: 0,
                            searchUI: SearchBar(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              onSubmitted: (value) {
                                setState(() {
                                  search = value;
                                });
                              },
                            ),
                          ),
                        ),
                        if (widget.user.permissions
                            .contains("GET_ALL_AMENITIES"))
                          SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  (BuildContext contaxt, int index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: HostelListDropdown(
                                  value: selectedHostel,
                                  onChanged: (val) {
                                    setState(() {
                                      selectedHostel = val;
                                    });
                                  }),
                            );
                          }, childCount: 1))
                      ];
                    },
                    body: (() {
                      if (result.hasException) {
                        return SelectableText(result.exception.toString());
                      }

                      if (result.isLoading && result.data == null) {
                        return const Text('Loading');
                      }

                      final List<PostModel> posts =
                          AmenitiesModel.fromJson(result.data!["getAmenities"])
                              .toPostsModel();

                      if (posts.isEmpty) {
                        return const Text('No posts');
                      }

                      return RefreshIndicator(
                        onRefresh: () {
                          return refetch!();
                        },
                        child: ListView.builder(
                            itemCount: posts.length,
                            itemBuilder: (context, index) {
                              final PostActions actions = amenitiesActions(
                                  widget.user, posts[index], options);
                              //Show hostels in tag card
                              return PostCard(
                                post: posts[index],
                                actions: actions,
                              );
                            }),
                      );
                    }()),
                  ),
                ),
              ),
            ),
            floatingActionButton:
                widget.user.permissions.contains("CREATE_AMENITY")
                    ? FloatingActionButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => NewAmenityPage(
                                  user: widget.user, options: options)));
                        },
                        child: const Icon(Icons.add))
                    : null,
          );
        });
  }
}
