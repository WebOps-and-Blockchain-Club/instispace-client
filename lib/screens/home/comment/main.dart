import 'dart:async';

import 'package:client/services/image_picker.dart';
import 'package:client/themes.dart';
import 'package:client/widgets/card/image.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import '../../../models/comment.dart';
import '../../../models/date_time_format.dart';
import '../../../themes.dart';
import '../../../widgets/button/icon_button.dart';
import '../../../widgets/card/description.dart';
import '../../../widgets/headers/main.dart';
import '../../../widgets/helpers/error.dart';

class CommentsPage extends StatefulWidget {
  final CommentsModel comments;
  final String? id;
  final String? type;
  final String? document;
  final String? postId;
  final FutureOr<void> Function(GraphQLDataProxy, QueryResult<Object?>)?
      updateCache;

  const CommentsPage({
    Key? key,
    required this.comments,
    this.postId,
    this.id,
    this.type,
    this.document,
    this.updateCache,
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
    return Scaffold(
      appBar: AppBar(
          title: CustomAppBar(
              title: "COMMENTS",
              leading: CustomIconButton(
                icon: Icons.arrow_back,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )),
          automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.only(right: 15.0, left: 15.0, top: 15.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.comments.comments.length,
                  itemBuilder: (context, index) {
                    final CommentModel commet = widget.comments.comments[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 15),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Images
                            if (commet.images != null &&
                                commet.images!.isNotEmpty)
                              Container(
                                  margin: const EdgeInsets.all(10),
                                  child: ImageCard(imageUrls: commet.images!)),

                            // Description
                            Description(content: commet.content),

                            // Posted By & Time
                            SelectableText(
                                'Commented by ${commet.createdBy.name}, ${DateTimeFormatModel.fromString(commet.createdAt).toDiffString()} ago',
                                style: Theme.of(context).textTheme.labelSmall),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            if (widget.id != null &&
                widget.type != null &&
                widget.document != null &&
                widget.updateCache != null)
              CreateComment(
                  id: widget.id!,
                  type: widget.type!,
                  document: widget.document!,
                  updateCache: widget.updateCache!,
                  updateComments: (CommentModel comment) {
                    setState(() {
                      comments.add(comment);
                    });
                  })
          ],
        ),
      ),
    );
  }
}

class CreateComment extends StatefulWidget {
  final String id;
  final String type;
  final String document;
  final FutureOr<void> Function(GraphQLDataProxy, QueryResult<Object?>)
      updateCache;
  final Function updateComments;
  const CreateComment(
      {Key? key,
      required this.id,
      required this.type,
      required this.document,
      required this.updateCache,
      required this.updateComments})
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
            document: gql(widget.document),
            update: (cache, result) {
              if (result != null) {
                //print(result);
                widget.updateCache(cache, result);
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
                  color: ColorPalette.palette(context).secondary[50],
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                    prefixIcon:
                                        imagePickerService.pickImageIconButton(
                                      context: context,
                                    ),
                                    suffixIcon: InkWell(
                                      onTap: () async {
                                        List<String> uploadResult;
                                        try {
                                          uploadResult =
                                              await imagePickerService
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
                                            "postId": widget.id,
                                            "createCommentInput": {
                                              "content": comment.text,
                                              "postId": widget.id,
                                              "isHidden": false,
                                            }
                                          });
                                          //print(result);
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: (result != null &&
                                                result.isLoading)
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
                                    hintText: 'Enter your comment',
                                  ),
                                ),
                              ],
                            )),
                          ],
                        ),
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
