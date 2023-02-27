import 'dart:async';

import 'package:client/graphQL/feed.dart';
import 'package:client/services/image_picker.dart';
import 'package:client/themes.dart';
import 'package:client/widgets/card.dart';
import 'package:client/widgets/card/image.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

// import '../../../models/comment.dart';
import '../../../models/date_time_format.dart';
import '../../../models/post/actions.dart';
import '../../../themes.dart';
import '../../../widgets/button/icon_button.dart';
import '../../../widgets/card/description.dart';
import '../../../widgets/headers/main.dart';
import '../../../widgets/helpers/error.dart';

class CommentsPage extends StatefulWidget {
  final String postId;
  final CommentsModel comments;
  // final String? id;
  // final String? type;
  // final String? document;
  // final FutureOr<void> Function(GraphQLDataProxy, QueryResult<Object?>)?
  //     updateCache;

  const CommentsPage({
    Key? key,
    required this.postId,
    required this.comments,
    // this.id,
    // this.type,
    // this.document,
    // this.updateCache,
  }) : super(key: key);

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
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "COMMENTS",
          style: TextStyle(
              letterSpacing: 2.64,
              color: Color(0xFF3C3C3C),
              fontSize: 24,
              fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 15.0, left: 15.0, top: 15.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.comments.comments.length,
                  itemBuilder: (context, index) {
                    final CommentModel comment =
                        widget.comments.comments[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
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
                    // return Card(
                    //   margin: const EdgeInsets.only(bottom: 15),
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(15),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.stretch,
                    //       children: [
                    //         // Images
                    //         if (commet.images != null &&
                    //             commet.images!.isNotEmpty)
                    //           Container(
                    //               margin: const EdgeInsets.all(10),
                    //               child: ImageCard(imageUrls: commet.images!)),

                    //         // Description
                    //         Description(content: commet.content),

                    //         // Posted By & Time
                    //         SelectableText(
                    //             'Commented by ${commet.createdBy.name}, ${DateTimeFormatModel.fromString(commet.createdAt).toDiffString()} ago',
                    //             style: Theme.of(context).textTheme.labelSmall),
                    //       ],
                    //     ),
                    //   ),
                    // );
                  }),
            ),
            CreateComment(
                postId: widget.postId,
                updateComments: (CommentModel comment) {
                  setState(() {
                    comments.add(comment);
                  });
                }),
          ],
        ),
      ),
    );
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
                      borderRadius: BorderRadius.circular(35)),
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
                                              : const Icon(Icons.send),
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
                                  result.exception.toString()),
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
