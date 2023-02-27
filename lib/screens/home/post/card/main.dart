import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/screens/home/new_post/main.dart';
import 'package:client/screens/home/new_post/newPost.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

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
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
      child: CustomCard(
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
                  child: CachedNetworkImage(
                    imageUrl: post.createdBy.photo,
                    placeholder: (_, __) =>
                        const Icon(Icons.account_circle_rounded, size: 40),
                    errorWidget: (_, __, ___) =>
                        const Icon(Icons.account_circle_rounded, size: 40),
                    imageBuilder: (context, imageProvider) => Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: Text(
                  post.title ?? "",
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w700),
                ),
              ),
              Container(
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
                firstChild: post.photo != null && post.photo!.isNotEmpty
                    ? Container()
                    : postBodyWidgets(post),
                secondChild: postBodyWidgets(post),
              ),
            ],
          ),

          //Action Buttons
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(right: 10.0),
                //   child: LikePostButton(
                //     postId: post.id,
                //     like: post.like!,
                //     type: 'upvote',
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(right: 10.0),
                //   child: DisLikePostButton(
                //     postId: post.id,
                //     like: post.like!,
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: LikePostButton(postId: post.id, like: post.like!),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: CommentPostButton(
                    postId: post.id,
                    comment: post.comments!,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: SharePostButton(post: post),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(right: 10.0),
                //   child: SetReminderButton(post: post),
                // ),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: SavePostButton(postId: post.id, save: post.saved!),
                ),

                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () =>
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => NewPostScreen(
                              category: post.category,
                              fieldConfiguration:
                                  getCreatePostFields[post.category.name]!,
                              post: post,
                            ),
                          ))),
                ),

                // Padding(
                //   padding: const EdgeInsets.only(right: 10.0),
                //   child: ReportPostButton(
                //       postId: post.id, options: widget.options),
                // ),
                const Spacer(),
                if (post.photo != null && post.photo!.isNotEmpty)
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
        ],
      )),
    );
  }
}

Widget postBodyWidgets(PostModel post) {
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
            /*[
              TagModel(id: "id", title: "title", category: "category"),
              TagModel(id: "id", title: "title", category: "category"),
              TagModel(id: "id", title: "title", category: "category"),
              TagModel(id: "id", title: "title", category: "category"),
              TagModel(id: "id", title: "title", category: "category"),
              TagModel(id: "id", title: "title", category: "category")
            ].map((tag) => TagButton(tag: tag)).toList(),*/
          ),
        )
    ],
  );
}
