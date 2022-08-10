import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../graphQL/tag.dart';
import '../../../models/tag.dart';
import '../../../models/post.dart';
import '../../../widgets/button/icon_button.dart';
import '../../../widgets/card/main.dart';
import '../../../widgets/headers/main.dart';
import '../../../widgets/helpers/loading.dart';
import '../../../widgets/helpers/error.dart';
import 'actions.dart';

class TagPage extends StatefulWidget {
  final TagModel tag;
  const TagPage({Key? key, required this.tag}) : super(key: key);

  @override
  State<TagPage> createState() => _TagPageState();
}

class _TagPageState extends State<TagPage> {
  @override
  Widget build(BuildContext context) {
    final QueryOptions<Object?> options = QueryOptions(
      document: gql(TagGQL.get),
      variables: {"tag": widget.tag.id},
    );
    return Query(
        options: options,
        builder: (QueryResult result, {FetchMore? fetchMore, refetch}) {
          return Scaffold(
            appBar: AppBar(
                title: CustomAppBar(
                    title: widget.tag.title,
                    leading: CustomIconButton(
                      icon: Icons.arrow_back,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )),
                automaticallyImplyLeading: false),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: RefreshIndicator(
                    onRefresh: () => refetch!(),
                    child: (() {
                      if (result.hasException) {
                        return Error(error: result.exception.toString());
                      }

                      if (result.isLoading && result.data == null) {
                        return const Loading();
                      }

                      final TagModel tag =
                          TagModel.fromJson(result.data!["getTag"]);

                      if (tag.events == null && tag.netops == null) {
                        return const Error(error: "No Posts");
                      }

                      return ListView(
                        children: [
                          if (tag.events != null && tag.events!.isNotEmpty)
                            Section(
                              title: "Events",
                              posts: tag.events!,
                              options: options,
                            ),
                          if (tag.netops != null && tag.netops!.isNotEmpty)
                            Section(
                              title: "Networking & Opportunities",
                              posts: tag.netops!,
                              options: options,
                            )
                        ],
                      );
                    }())),
              ),
            ),
          );
        });
  }
}

class Section extends StatefulWidget {
  final String title;
  final List<PostModel> posts;
  final QueryOptions<Object?> options;
  const Section(
      {Key? key,
      required this.title,
      required this.posts,
      required this.options})
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
                    final PostActions actions = tagPostActions(
                        widget.title, widget.posts[index], widget.options);
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
