import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../models/comment.dart';
import '../../../models/date_time_format.dart';
import '../../../themes.dart';
import '../../../widgets/button/icon_button.dart';
import '../../../widgets/headers/main.dart';

class CommentsPage extends StatefulWidget {
  final String id;
  final CommentsModel comments;
  final String type;
  final String document;
  final FutureOr<void> Function(GraphQLDataProxy, QueryResult<Object?>)
      updateCache;
  const CommentsPage(
      {Key? key,
      required this.id,
      required this.comments,
      required this.type,
      required this.document,
      required this.updateCache})
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
            Mutation(
                options: MutationOptions(
                    document: gql(widget.document),
                    update: (cache, result) {
                      if (result != null) {
                        widget.updateCache(cache, result);
                        setState(() {
                          comments.add(CommentModel.fromJson(
                              result.data!["createComment${widget.type}"]));
                        });
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
                        SizedBox(
                          height: 40,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                  child: Card(
                                      margin: const EdgeInsets.all(0),
                                      child: Theme(
                                        data: ThemeData(
                                          primarySwatch:
                                              ColorPalette.palette(context)
                                                  .primary,
                                        ),
                                        child: TextField(
                                          controller: comment,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Enter your comment',
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 13,
                                                    horizontal: 10),
                                          ),
                                        ),
                                      ))),
                              Card(
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: (result != null && result.isLoading)
                                        ? const CircularProgressIndicator(
                                            strokeWidth: 2,
                                          )
                                        : const Icon(Icons.send),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        if (result != null && result.hasException)
                          SizedBox(
                            height: 18,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                result.exception.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(
                                        color: ColorPalette.palette(context)
                                            .error),
                              ),
                            ),
                          )
                      ],
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
