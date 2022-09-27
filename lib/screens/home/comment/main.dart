import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../models/comment.dart';
import '../../../models/date_time_format.dart';
import '../../../themes.dart';
import '../../../widgets/button/icon_button.dart';
import '../../../widgets/headers/main.dart';
import '../../../widgets/helpers/error.dart';

class CommentsPage extends StatefulWidget {
  final CommentsModel comments;
  final String? id;
  final String? type;
  final String? document;
  final FutureOr<void> Function(GraphQLDataProxy, QueryResult<Object?>)?
      updateCache;
  const CommentsPage(
      {Key? key,
      required this.comments,
      this.id,
      this.type,
      this.document,
      this.updateCache})
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
          title: CustomAppBar(
              title: "Comments",
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
                            // Image
                            if (commet.image != null)
                              Container(
                                constraints:
                                    const BoxConstraints(maxHeight: 250),
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Image.network(
                                  commet.image!,
                                  fit: BoxFit.fitWidth,
                                  semanticLabel: commet.content,
                                ),
                              ),

                            // Description
                            SelectableText(
                              commet.content,
                              textAlign: TextAlign.justify,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),

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
                widget.updateCache(cache, result);
                widget.updateComments(CommentModel.fromJson(
                    result.data!["createComment${widget.type}"]));
                comment.clear();
              }
            }),
        builder: (
          RunMutation runMutation,
          QueryResult? result,
        ) {
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
                          child: TextField(
                        controller: comment,
                        maxLength: 3000,
                        minLines: 1,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: Themes.borderNone,
                          hintText: 'Enter your comment',
                        ),
                      )),
                      SizedBox(
                        height: 40,
                        child: Card(
                          margin: const EdgeInsets.only(left: 10),
                          child: InkWell(
                            onTap: () {
                              if (!(result != null && result.isLoading) &&
                                  comment.text.isNotEmpty) {
                                runMutation({
                                  "content": comment.text,
                                  "id": widget.id,
                                });
                              }
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: (result != null && result.isLoading)
                                  ? const CircularProgressIndicator(
                                      strokeWidth: 2,
                                    )
                                  : const Icon(Icons.send),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                if (result != null && result.hasException)
                  IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: ErrorText(
                        error: formatErrorMessage(result.exception.toString()),
                      ),
                    ),
                  )
              ],
            ),
          );
        });
  }
}
