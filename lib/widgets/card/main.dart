import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../models/date_time_format.dart';
import '../../models/post.dart';
import '../../utils/string_extension.dart';
import 'action_buttons.dart';
import '../../themes.dart';

/// Common Card widget for Events, Netops, Queries and Lost & Found
class PostCard extends StatefulWidget {
  final PostModel post;
  final Future<QueryResult<Object?>?> Function()? refetch;
  final String deleteMutationDocument;
  const PostCard(
      {Key? key,
      required this.post,
      this.refetch,
      required this.deleteMutationDocument})
      : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Expanded(
                    child: SelectableText(post.title.capitalize(),
                        style: Theme.of(context).textTheme.titleLarge)),
                // Action Menu
                PopupMenuButton(
                    child: const Padding(
                      padding: EdgeInsets.only(top: 3, left: 3),
                      child: Icon(Icons.more_vert),
                    ),
                    itemBuilder: (context) {
                      return [
                        if (post.edit != null)
                          PopupMenuItem(
                              height: 10,
                              padding: EdgeInsets.zero,
                              child: EditPostButton(
                                  navigateTo: post.edit!(widget.refetch))),
                        if (post.delete != null)
                          PopupMenuItem(
                              height: 10,
                              padding: EdgeInsets.zero,
                              child: DeletePostButton(
                                delete: post.delete!,
                                refetch: widget.refetch,
                              )),
                        if (post.star != null)
                          PopupMenuItem(
                            height: 10,
                            padding: EdgeInsets.zero,
                            child: StarPostButton(star: post.star!),
                          ),
                        if (post.setReminderAllowed)
                          PopupMenuItem(
                            height: 10,
                            padding: EdgeInsets.zero,
                            child: SetReminderButton(post: post),
                          ),
                      ];
                    })
              ],
            ),
            // Posted By & Time
            SelectableText(
                'Posted by ${post.createdBy.name}, ${DateTimeFormatModel.fromString(post.createdAt).toDiffString()} ago',
                style: Theme.of(context).textTheme.labelSmall),
            const Divider(),

            // Image
            if (post.imageUrls != null &&
                post.imageUrls!.isNotEmpty &&
                post.imageUrls!.length != 10)
              Container(
                constraints: const BoxConstraints(maxHeight: 250),
                child: Image.network(
                  post.imageUrls!.first,
                  fit: BoxFit.fitWidth,
                  semanticLabel: post.title,
                ),
              ),

            // Time & Location
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (post.time != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                color:
                                    ColorPalette.palette(context).secondary[50],
                                borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: Icon(Icons.timer,
                                color:
                                    ColorPalette.palette(context).secondary)),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: SelectableText(
                              DateTimeFormatModel.fromString(post.time!)
                                  .toFormat(),
                              style: Theme.of(context).textTheme.bodyLarge),
                        )
                      ],
                    ),
                  ),
                if (post.location != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                color:
                                    ColorPalette.palette(context).secondary[50],
                                borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: Icon(Icons.location_city,
                                color:
                                    ColorPalette.palette(context).secondary)),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: SelectableText(post.location!.capitalize(),
                              style: Theme.of(context).textTheme.bodyLarge),
                        )
                      ],
                    ),
                  )
              ],
            ),

            // Description
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: SelectableText(
                post.description.capitalize(),
                textAlign: TextAlign.justify,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),

            // Tags
            if (post.tags != null && post.tags!.tags.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Wrap(
                  spacing: 3,
                  children: post.tags!.tags
                      .map((tag) => TagButton(tag: tag))
                      .toList(),
                ),
              ),

            // CTA
            if (post.cta != null)
              Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: CTAButton(cta: post.cta!)),

            // Actions
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: [
                      if (post.like != null) LikePostButton(like: post.like!),
                      if (post.comment != null)
                        CommentPostButton(comment: post.comment!),
                      if (post.shareAllowed) SharePostButton(post: post),
                    ],
                  ),
                  if (post.report != null)
                    ReportPostButton(
                      report: post.report!,
                      refetch: widget.refetch,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
