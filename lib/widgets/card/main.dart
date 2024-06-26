import 'package:client/widgets/card/image.dart';
import 'package:flutter/material.dart';

import '../../models/date_time_format.dart';
import '../../models/post.dart';
import '../../utils/string_extension.dart';
import 'description.dart';
import 'action_buttons.dart';
import '../../themes.dart';

/// Common Card widget for Events, Netops, Queries and Lost & Found
class PostCard extends StatefulWidget {
  final PostModel post;
  final PostActions actions;
  const PostCard({Key? key, required this.post, required this.actions})
      : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    final PostModel post = widget.post;
    final PostActions actions = widget.actions;
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
                /*if (post.permissions.contains("EDIT") ||
                    post.permissions.contains("DELETE") ||
                    post.permissions.contains("RESOLVE_ITEM"))
                  PopupMenuButton(
                      child: const Padding(
                        padding: EdgeInsets.only(top: 3, left: 3),
                        child: Icon(Icons.more_vert),
                      ),
                      itemBuilder: (context) {
                        return [
                          if (post.permissions.contains("EDIT"))
                            PopupMenuItem(
                                height: 10,
                                padding: EdgeInsets.zero,
                                child:
                                    EditPostButton(edit: widget.actions.edit)),
                          if (post.permissions.contains("DELETE"))
                            PopupMenuItem(
                                height: 10,
                                padding: EdgeInsets.zero,
                                child:
                                    DeletePostButton(delete: actions.delete)),
                          if (post.permissions.contains("RESOLVE_ITEM"))
                            PopupMenuItem(
                                height: 10,
                                padding: EdgeInsets.zero,
                                child: ResolvePostButton(
                                    resolve: actions.resolve)),
                        ];
                      })*/
              ],
            ),
            // Posted By & Time
            if ((post.createdBy != null && post.createdAt != null) ||
                post.subTitle != null)
              SelectableText(
                  post.subTitle ??
                      'Posted by ${post.createdBy!.name}, ${DateTimeFormatModel.fromString(post.createdAt!).toDiffString()} ago',
                  style: Theme.of(context).textTheme.labelSmall),
            const Divider(),
            //Images
            if (post.imageUrls != null && post.imageUrls!.isNotEmpty)
              ImageCard(imageUrls: post.imageUrls!),

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
              child: Description(content: post.description),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 10),
            //   child: SelectableText(
            //     post.description.capitalize(),
            //     textAlign: TextAlign.justify,
            //     style: Theme.of(context).textTheme.bodyMedium,
            //   ),
            // ),

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

            // Hostels
            if (post.hostels != null && post.hostels!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Wrap(
                  spacing: 3,
                  children: post.hostels!
                      .map((hostel) => Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 3, horizontal: 0),
                            child: Text("#" + hostel.name,
                                style: Theme.of(context).textTheme.labelLarge),
                          ))
                      .toList(),
                ),
              ),

            // CTA
            // if (post.cta != null)
            //   Padding(
            //       padding: const EdgeInsets.only(top: 10),
            //       child: CTAButton(cta: post.cta!)),

            // Actions
            if ((post.permissions.contains("LIKE") && post.like != null) ||
                (post.comments != null) ||
                (post.permissions.contains("SHARE")) ||
                (post.permissions.contains("REPORT")) ||
                (post.permissions.contains("STAR")) ||
                (post.permissions.contains("SET_REMINDER")))
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child:
                    Container(), /*Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: [
                        if (post.permissions.contains("LIKE") &&
                            post.like != null)
                          LikePostButton(
                            like: post.like!,
                            likeAction: actions.like,
                          ),
                        if (post.comments != null)
                          CommentPostButton(
                            comment: post.comments!,
                            commentPage: actions.comment,
                          ),
                        if (post.permissions.contains("SHARE"))
                          SharePostButton(post: post),
                        if (post.permissions.contains("STAR") &&
                            post.star != null)
                          StarPostButton(
                            star: post.star!,
                            starAction: actions.star,
                          ),
                        if (post.permissions.contains("SET_REMINDER"))
                          SetReminderButton(
                            post: post,
                          ),
                      ],
                    ),
                    if (post.permissions.contains("REPORT"))
                      ReportPostButton(
                        report: actions.report,
                      ),
                  ],
                ),*/
              ),
          ],
        ),
      ),
    );
  }
}
