import 'package:client/graphQL/feed.dart';
import 'package:client/services/image_picker.dart';
import 'package:client/widgets/card.dart';
import 'package:client/widgets/card/image.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import '../../../models/date_time_format.dart';
import '../../../models/post/actions.dart';
import '../../../utils/custom_icons.dart';
import '../../../widgets/card/description.dart';
import '../../../widgets/helpers/error.dart';

class CommentsPage extends StatefulWidget {
  final String postId;
  final CommentsModel comments;

  const CommentsPage({Key? key, required this.postId, required this.comments})
      : super(key: key);

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final TextEditingController comment = TextEditingController();

  late List<CommentModel> comments;

  @override
  void initState() {
    comments = widget.comments.comments;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "COMMENTS",
          style: TextStyle(
              letterSpacing: 1,
              color: Theme.of(context).brightness == Brightness.dark ? Color.fromARGB(209, 255, 255, 255) : Color(0xFF3C3C3C),
              fontSize: 20,
              fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: widget.comments.comments.length,
                itemBuilder: (context, index) {
                  final CommentModel comment = widget.comments.comments[index];
                  return Padding(
                    padding: EdgeInsets.only(
                        right: 20.0,
                        left: 20.0,
                        top: index == 0 ? 20.0 : 0,
                        bottom: 20),
                    child: CustomCard(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Images
                        if (comment.images != null &&
                            comment.images!.isNotEmpty &&
                            comment.images!.first != "")
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Container(
                                margin: const EdgeInsets.all(10),
                                child: ImageCard(
                                  imageUrls: comment.images!,
                                )),
                          ),

                        // Description
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Description(content: comment.content),
                        ),

                        // Posted By & Time
                        SelectableText(
                          '${comment.createdBy.name}, ${DateTimeFormatModel.fromString(comment.createdAt).toDiffString()} ago',
                          style: const TextStyle(color: Colors.black45),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    )),
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0, left: 20.0, top: 0.0),
            child: CreateComment(
                postId: widget.postId,
                updateComments: (CommentModel comment) {
                  setState(() {
                    comments.add(comment);
                  });
                }),
          ),
        ],
      ),
    );
  }
}

class LikeCommentButton extends StatefulWidget {
  final String commentId;
  final LikeModel like;
  const LikeCommentButton(
      {Key? key, required this.commentId, required this.like})
      : super(key: key);

  @override
  State<LikeCommentButton> createState() => _LikeCommentButtonState();
}

class _LikeCommentButtonState extends State<LikeCommentButton> {
  @override
  Widget build(BuildContext context) {
    final like = widget.like;
    return Mutation(
        options: MutationOptions(
            document: gql(FeedGQL().toggleLikeComment),
            update: (cache, result) {
              if (result != null && (!result.hasException)) {
                final Map<String, dynamic> updated = {
                  "__typename": "Comments",
                  "id": widget.commentId,
                  "isLiked": !(like.isLikedByUser),
                  "likeCount":
                      like.isLikedByUser ? like.count - 1 : like.count + 1
                };
                cache.writeFragment(
                  Fragment(document: gql('''
                      fragment LikeField on Comments {
                        id
                        isLiked
                        likeCount
                      }
                    ''')).asRequest(idFields: {
                    '__typename': updated['__typename'],
                    'id': updated['id'],
                  }),
                  data: updated,
                  broadcast: false,
                );
              }
            }),
        builder: (
          RunMutation runMutation,
          QueryResult? result,
        ) =>
            Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    color: Colors.black,
                    child: IconButton(
                      padding: EdgeInsets.all(0),
                      icon: widget.like.isLikedByUser
                          ? const Icon(
                              CustomIcons.likefilled,
                              color: Colors.red,
                              size: 15,
                            )
                          : const Icon(
                              CustomIcons.like,
                              size: 15,
                            ),
                      onPressed: () {
                        if (!(result != null && result.isLoading)) {
                          runMutation({"commentId": widget.commentId});
                        }
                      },
                    ),
                  ),
                  Text(widget.like.count.toString(),
                      style: Theme.of(context).textTheme.labelLarge)
                ],
              ),
            ));
  }
}

class CreateComment extends StatefulWidget {
  final String postId;
  final Function updateComments;
  const CreateComment(
      {Key? key, required this.postId, required this.updateComments})
      : super(key: key);

  @override
  State<CreateComment> createState() => _CreateCommentState();
}

class _CreateCommentState extends State<CreateComment> {
  final TextEditingController comment = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Mutation(
        options: MutationOptions(
            document: gql(FeedGQL().createComment),
            update: (cache, result) {
              if (result != null) {
                var data = cache.readFragment(Fragment(document: gql('''
                      fragment PostCommentField on Post{
                        id
                        postComments {
                          id
                          createdAt
                          createdBy {
                            id
                            roll
                            role
                            name
                            photo
                          }
                          content
                          isLiked
                          isDisliked
                          likeCount
                          isHidden
                        }
                      }
                    ''')).asRequest(idFields: {
                  '__typename': "Post",
                  'id': widget.postId,
                }));
                final Map<String, dynamic> updated = {
                  "__typename": "Post",
                  "id": widget.postId,
                  "postComments":
                      data!["postComments"] + [result.data!["createComment"]],
                };
                cache.writeFragment(
                  Fragment(document: gql('''
                      fragment PostCommentField on Post {
                        id
                        postComments {
                          content
                          createdBy {
                            name
                            id
                          }
                        }
                      }
                    ''')).asRequest(idFields: {
                    '__typename': "Post",
                    'id': widget.postId,
                  }),
                  data: updated,
                  broadcast: false,
                );
                widget.updateComments(
                    CommentModel.fromJson(result.data!["createComment"]));
                comment.clear();
              }
            }),
        builder: (
          RunMutation runMutation,
          QueryResult? result,
        ) {
          return ChangeNotifierProvider(
              create: (_) => ImagePickerService(noOfImages: 4),
              child: Consumer<ImagePickerService>(
                  builder: (context, imagePickerService, child) {
                if (result != null &&
                    result.data != null &&
                    result.data!["createComment"] != null) {
                  imagePickerService.clearPreview();
                }
                return Container(
                  padding: const EdgeInsets.fromLTRB(6, 0, 6, 6),
                  margin: const EdgeInsets.only(bottom: 30),
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromARGB(255, 192, 192, 192),
                            offset: Offset(1, 1),
                            blurRadius: 10,
                            spreadRadius: 0.0)
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              imagePickerService.previewImages(),
                              const SizedBox(height: 10),
                              TextField(
                                controller: comment,
                                maxLength: 3000,
                                minLines: 1,
                                maxLines: null,
                                decoration: InputDecoration(
                                  counterText: "",
                                  prefixIcon:
                                      imagePickerService.pickImageIconButton(
                                    context: context,
                                  ),
                                  contentPadding: EdgeInsets.zero,
                                  suffixIcon: InkWell(
                                    onTap: () async {
                                      List<String> uploadResult;
                                      try {
                                        uploadResult = await imagePickerService
                                            .uploadImage();
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: const Text(
                                                'Image Upload Failed'),
                                            backgroundColor:
                                                Theme.of(context).errorColor,
                                          ),
                                        );
                                        return;
                                      }
                                      if (!(result != null &&
                                              result.isLoading) &&
                                          comment.text.isNotEmpty) {
                                        runMutation({
                                          "postId": widget.postId,
                                          "createCommentInput": {
                                            "content": comment.text,
                                            "photoList": uploadResult,
                                            "isHidden": false,
                                          }
                                        });
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 3),
                                      child:
                                          (result != null && result.isLoading)
                                              ? const CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                )
                                              : Icon(Icons.send,color: Colors.black),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none),
                                  hintText: 'Add your comment.....',
                                ),
                              ),
                            ],
                          )),
                        ],
                      ),
                      if (result != null && result.hasException)
                        IntrinsicHeight(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: ErrorText(
                              error: formatErrorMessage(
                                  result.exception.toString(), context),
                            ),
                          ),
                        )
                    ],
                  ),
                );
              }));
        });
  }
}
