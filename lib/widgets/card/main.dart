import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

import '../../models/date_time_format.dart';
import '../../models/post.dart';
import '../../utils/string_extension.dart';
import 'action_buttons.dart';

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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      shadowColor: Colors.purple[50],
      clipBehavior: Clip.antiAlias,
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
                    child: SelectableText(
                  post.title.capitalize(),
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2f247b)),
                )),
                // Action Menu
                PopupMenuButton(
                    child: const Padding(
                      padding: EdgeInsets.only(top: 3, left: 3),
                      child: Icon(
                        Icons.more_vert,
                        color: Color(0xFF2f247b),
                      ),
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
            if (post.footer != null)
              SelectableText(
                post.footer!,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            const Divider(
              color: Color(0xFF2f247b),
              thickness: 2,
            ),

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
                                color: Colors.purple[50],
                                borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: const Icon(
                              Icons.timer,
                              color: Colors.purple,
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: SelectableText(
                              DateTimeFormatModel.fromString(post.time!)
                                  .toFormat()),
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
                                color: Colors.purple[50],
                                borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: const Icon(
                              Icons.location_city,
                              color: Colors.purple,
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: SelectableText(
                            post.location!.capitalize(),
                            style: const TextStyle(fontSize: 15),
                          ),
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

String dateTimeString(String utcDateTime) {
  if (utcDateTime == "") {
    return "";
  }
  var parseDateTime = DateTime.parse(utcDateTime);
  final localDateTime = parseDateTime.toLocal();

  var dateTimeFormat = DateFormat("dd/MM/yyyy hh:mm:ss aaa");

  return dateTimeFormat.format(localDateTime);
}
