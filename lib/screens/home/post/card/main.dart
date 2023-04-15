import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/graphQL/badge.dart';
import 'package:client/models/event_points.dart';
import 'package:client/models/post/query_variable.dart';
import 'package:client/screens/badges/show_qr.dart';
import 'package:client/screens/super_user/approve_post.dart';
import 'package:client/widgets/card/image_view.dart';
import 'package:client/widgets/helpers/navigate.dart';
import 'package:client/widgets/profile_icon.dart';
import 'package:client/widgets/utils/image_cache_path.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '/utils/string_extension.dart';
import '../../new_post/main.dart';
import '../../new_post/newPost.dart';
import '../../../../models/date_time_format.dart';
import '../../../../models/post/main.dart';
import '../../../../utils/custom_icons.dart';
import '../../../../widgets/card.dart';
import '../../../../widgets/card/action_buttons.dart';
import '../../../../widgets/card/description.dart';
import '../../../../widgets/card/image.dart';

class PostCard extends StatefulWidget {
  final PostModel post;
  final QueryOptions<Object?> options;
  const PostCard({Key? key, required this.post, required this.options})
      : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with SingleTickerProviderStateMixin {
  GlobalKey key = GlobalKey();
  bool _showContent = false;
  @override
  Widget build(BuildContext context) {
    PostModel post = widget.post;
    final isSuperUserPage =
        (post.reports != null && post.reports!.isNotEmpty) ||
            ["TO_BE_APPROVED", "APPROVED", "REJECTED"].contains(post.status);
    return CustomCard(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Card Header
        Row(
          children: [
            if (post.createdBy.role != 'USER' &&
                post.createdBy.role != 'MODERATOR')
              Container(
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 5,
                    spreadRadius: 1,
                  )
                ]),
                child: ProfileIconWidget(photo: post.createdBy.photo),
              ),
            Expanded(
              child: Text(
                post.title ?? "",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
            GestureDetector(
              onTap: () => navigate(
                  context,
                  SuperUserPostPage(
                      title: post.category.name,
                      filterVariables:
                          PostQueryVariableModel(categories: [post.category]))),
              child: Container(
                margin: const EdgeInsets.only(left: 5),
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.white,
                  child: Icon(
                    post.category.icon,
                    color: Colors.lightBlue,
                  ),
                ),
              ),
            ),
          ],
        ),

        // Post Body
        Column(
          children: [
            if (post.photo != null && post.photo!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ImageCard(
                  imageUrls: post.photo!,
                ),
              ),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState: !_showContent
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstCurve: Curves.easeOut,
              secondCurve: Curves.easeIn,
              firstChild: post.photo != null &&
                      post.photo!.isNotEmpty &&
                      !isSuperUserPage
                  ? Container()
                  : PostBodyWidget(post: post),
              secondChild: PostBodyWidget(post: post),
            ),
          ],
        ),

        //Action Buttons
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Row(
            children: [
              // const SizedBox(width: 5),
              if (post.permissions.contains('Upvote_Downvote'))
                Padding(
                  padding: const EdgeInsets.only(right: 0.0),
                  child: VotePostButton(
                    postId: post.id,
                    like: post.like,
                    dislike: post.dislike,
                  ),
                ),
              // if (post.permissions.contains('Upvote_Downvote'))
              //   Padding(
              //     padding: const EdgeInsets.only(right: 10.0),
              //     child: DisLikePostButton(
              //       postId: post.id,
              //       dislike: post.dislike!,
              //     ),
              //   ),
              if (post.permissions.contains('Like') && post.like != null)
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: LikePostButton(postId: post.id, like: post.like!),
                ),
              if (post.permissions.contains('Comment'))
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: CommentPostButton(
                    postId: post.id,
                    comment: post.comments!,
                  ),
                ),
              if (post.permissions.contains('Share'))
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: SharePostButton(post: post),
                ),
              // if (post.permissions.contains('Set_Reminder'))
              //   Padding(
              //     padding: const EdgeInsets.only(right: 10.0),
              //     child: SetReminderButton(post: post),
              //   ),
              // Padding(
              //   padding: const EdgeInsets.only(right: 10.0),
              //   child: SavePostButton(postId: post.id, save: post.saved!),
              // ),
              if (post.permissions.contains('Report') &&
                  !post.permissions.contains('Edit'))
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: ReportPostButton(
                      postId: post.id, options: widget.options),
                ),
              if (post.permissions.contains('Edit')) ...[
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: InkWell(
                      child: const Icon(
                        CustomIcons.edit,
                        size: 20,
                      ),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => NewPostWrapper(
                              category: post.category,
                              post: post,
                              options: widget.options,
                            ),
                          ))),
                ),
                 
                Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: InkWell(
                      child: const Icon(Icons.qr_code),
                      onTap: () {
                        if (widget.post.points == null) {
                          showDialogForQR(context, widget.post.id);
                        }
                        else {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ShowQRPage(
                              post: post,
                            ),
                          ));
                        }
                      },
                      //child: const Icon(Icons.qr_code)
                    )),
              ],
              const Spacer(),
              if (post.photo != null &&
                  post.photo!.isNotEmpty &&
                  !isSuperUserPage)
                IconButton(
                  onPressed: () {
                    setState(() {
                      _showContent = !_showContent;
                    });
                  },
                  icon: Icon(
                    _showContent
                        ? CustomIcons.dropdown_close
                        : CustomIcons.dropdown,
                    size: 8,
                    color: const Color(0xFF383838),
                  ),
                )
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    ));
  }
}

class PostBodyWidget extends StatefulWidget {
  final PostModel post;
  const PostBodyWidget({Key? key, required this.post}) : super(key: key);

  @override
  State<PostBodyWidget> createState() => _PostBodyWidgetState();
}

class _PostBodyWidgetState extends State<PostBodyWidget> {
  String? status;
  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 10),
        //Time
        if (post.eventTime != null && post.eventTime != "")
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              // 'DATE - 7th Feb 9:00 PM ',
              DateTimeFormatModel.fromString(post.eventTime!)
                  .toFormat("dd MMM h:mm a"),
              style: const TextStyle(
                  fontSize: 19,
                  color: Colors.lightBlue,
                  fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
          ),

        //  Location
        if (post.location != null && post.location != "")
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              "VENUE - ${post.location!}",
              style: const TextStyle(
                  fontSize: 19,
                  color: Colors.lightBlue,
                  fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
          ),

        //Description
        if (post.content != null && post.content != "")
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Description(content: post.content!),
          ),

        if (post.attachement != null && post.attachement!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: GestureDetector(
                onTap: () async {
                  final List<String> attachments =
                      await imageCachePath(post.attachement!);

                  openImageView(context, 0, attachments);
                },
                child: Row(
                  children: [
                    const Icon(
                      CustomIcons.attachment,
                      color: Color(0xFF342f81),
                      size: 15,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Attachement (${post.attachement!.length})',
                      style: const TextStyle(
                          color: Color(0xFF342f81), fontSize: 15),
                    ),
                  ],
                )),
          ),

        //Created by and created at
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Text(
            "${post.createdBy.name}, ${DateTimeFormatModel.fromString(post.createdAt).toDiffString()} ago", // should change it such that when clicked it opens profile page.
            style: const TextStyle(color: Colors.black45),
            textAlign: TextAlign.left,
          ),
        ),

        //Tags
        if (post.tags != null && post.tags!.tags.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Wrap(
              spacing: 3,
              children:
                  post.tags!.tags.map((tag) => TagButton(tag: tag)).toList(),
            ),
          ),

        if (post.link != null)
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CTAButton(cta: post.link!),
              ],
            ),
          ),

        //Display Approve or reject button
        if ((post.reports != null && post.reports!.isNotEmpty) ||
            ["TO_BE_APPROVED", "APPROVED", "REJECTED"].contains(post.status))
          Column(
            children: [
              const Divider(),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SelectableText(
                  'Status: ${widget.post.status!.capitalize()}',
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              if (post.reports != null && post.reports!.isNotEmpty)
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: post.reports!.length,
                  itemBuilder: (context, index) {
                    final reports = post.reports!;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SelectableText(
                            reports[index].description.capitalize(),
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          SelectableText(
                              'Reported by ${reports[index].createdBy.name}, ${DateTimeFormatModel.fromString(reports[index].createdAt).toDiffString()} ago',
                              style: Theme.of(context).textTheme.labelSmall),
                        ],
                      ),
                    );
                  },
                ),
              //Report action button
              if (post.reports != null && post.reports!.isNotEmpty)
                SuperUserActionButton(post: post, type: 'report'),

              //Approve post action
              if (["TO_BE_APPROVED", "APPROVED", "REJECTED"]
                  .contains(post.status))
                SuperUserActionButton(post: post),

              const Divider(),
            ],
          )
      ],
    );
  }
}
