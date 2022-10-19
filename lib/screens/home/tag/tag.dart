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
import '../../../widgets/section/main.dart';
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

                      if ((tag.events == null ||
                              (tag.events != null && tag.events!.isEmpty)) &&
                          (tag.netops == null ||
                              (tag.netops != null && tag.netops!.isEmpty))) {
                        return const Error(error: "No Posts");
                      }

                      return ListView(
                        children: [
                          if (tag.events != null && tag.events!.isNotEmpty)
                            Section(
                              title: "Events",
                              child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: tag.events!.length,
                                  itemBuilder: (context, index) {
                                    final PostActions actions = tagPostActions(
                                        "Events", tag.events![index], options);
                                    return PostCard(
                                      post: tag.events![index],
                                      actions: actions,
                                    );
                                  }),
                            ),
                          if (tag.netops != null && tag.netops!.isNotEmpty)
                            Section(
                              title: "Networking & Opportunities",
                              child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: tag.netops!.length,
                                  itemBuilder: (context, index) {
                                    final PostActions actions = tagPostActions(
                                        "Networking & Opportunities",
                                        tag.netops![index],
                                        options);
                                    return PostCard(
                                      post: tag.netops![index],
                                      actions: actions,
                                    );
                                  }),
                            ),
                        ],
                      );
                    }())),
              ),
            ),
          );
        });
  }
}
