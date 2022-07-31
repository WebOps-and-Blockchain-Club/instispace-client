import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/link.dart' as url_launcher;

import '../../models/comment.dart';
import '../helpers/navigate.dart';
import '../../models/actions.dart';
import '../../models/post.dart';
import '../../models/tag.dart';
import '../addToCal.dart';
import '../button/elevated_button.dart';
import '../button/flat_icon_text_button.dart';
import '../tagPage.dart';
import '../../utils/string_extension.dart';
import '../../themes.dart';

class CTAButton extends StatelessWidget {
  final CTAModel cta;
  const CTAButton({Key? key, required this.cta}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return url_launcher.Link(
      target: url_launcher.LinkTarget.blank,
      uri: Uri.parse(cta.link),
      builder: (context, followLink) => CustomElevatedButton(
          onPressed: followLink, text: cta.name.capitalize()),
    );
  }
}

class TagButton extends StatelessWidget {
  final TagModel tag;
  const TagButton({Key? key, required this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => TagPage(
                  tagId: tag.id,
                  tagName: tag.title,
                )));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 0),
        child: Text("#" + tag.title,
            style: Theme.of(context).textTheme.labelLarge),
      ),
    );
  }
}

class LikePostButton extends StatelessWidget {
  final LikePostModel like;
  final PostAction likeAction;
  const LikePostButton({Key? key, required this.like, required this.likeAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Mutation(
        options: MutationOptions(
            document: gql(likeAction.document),
            update: (cache, result) {
              if (result != null && (!result.hasException)) {
                likeAction.updateCache(cache, result);
              }
            }),
        builder: (
          RunMutation runMutation,
          QueryResult? result,
        ) =>
            InkWell(
              onTap: () {
                if (!(result != null && result.isLoading)) {
                  runMutation({"id": likeAction.id});
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(like.isLikedByUser == true
                      ? Icons.thumb_up_alt
                      : Icons.thumb_up_alt_outlined),
                  const SizedBox(width: 5),
                  Text(like.count.toString(),
                      style: Theme.of(context).textTheme.labelLarge)
                ],
              ),
            ));
  }
}

class CommentPostButton extends StatelessWidget {
  final CommentsModel comment;
  final NavigateAction commentPage;
  const CommentPostButton(
      {Key? key, required this.comment, required this.commentPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigate(context, commentPage.to);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.comment),
          const SizedBox(width: 5),
          Text(comment.count.toString(),
              style: Theme.of(context).textTheme.labelLarge),
        ],
      ),
    );
  }
}

class StarPostButton extends StatefulWidget {
  final StarPostModel star;
  final PostAction starAction;
  const StarPostButton({Key? key, required this.star, required this.starAction})
      : super(key: key);

  @override
  State<StarPostButton> createState() => _StarPostButtonState();
}

class _StarPostButtonState extends State<StarPostButton> {
  late bool isStarred;

  @override
  void initState() {
    super.initState();
    isStarred = widget.star.isStarredByUser;
  }

  @override
  Widget build(BuildContext context) {
    return Mutation(
        options: MutationOptions(
            document: gql(widget.starAction.document),
            update: (cache, result) {
              if (result != null && (!result.hasException)) {
                setState(() {
                  isStarred = !isStarred;
                });
                widget.starAction.updateCache(cache, result);
              }
            }),
        builder: (
          RunMutation runMutation,
          QueryResult? result,
        ) =>
            CustomFlatIconTextButton(
              icon: isStarred == true ? Icons.star : Icons.star_outline,
              text: "Star",
              onPressed: () {
                if (!(result != null && result.isLoading)) {
                  runMutation({"id": widget.starAction.id});
                }
              },
            ));
  }
}

class SetReminderButton extends StatelessWidget {
  final PostModel post;
  const SetReminderButton({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFlatIconTextButton(
      icon: Icons.calendar_month,
      text: "Set Reminder",
      onPressed: () => {
        Add2Calendar.addEvent2Cal(
          buildEvent(
              title: post.title,
              startDate: DateTime.parse(post.time!),
              description: post.description,
              endDate: DateTime.parse(post.time!).add(const Duration(hours: 1)),
              location: post.location!),
        ),
      },
    );
  }
}

class SharePostButton extends StatelessWidget {
  final PostModel post;
  const SharePostButton({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Share.share("*${post.time}* \n${post.description}");
      },
      child: const Icon(Icons.share),
    );
  }
}

class EditPostButton extends StatelessWidget {
  final NavigateAction edit;
  const EditPostButton({Key? key, required this.edit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFlatIconTextButton(
      icon: Icons.edit_outlined,
      text: "Edit",
      onPressed: () {
        navigate(context, edit.to);
      },
    );
  }
}

class DeletePostButton extends StatefulWidget {
  final PostAction delete;
  const DeletePostButton({Key? key, required this.delete}) : super(key: key);

  @override
  State<DeletePostButton> createState() => _DeletePostButtonState();
}

class _DeletePostButtonState extends State<DeletePostButton> {
  @override
  Widget build(BuildContext context) {
    return CustomFlatIconTextButton(
      icon: Icons.delete_outline,
      text: "Delete",
      onPressed: () => showDialog(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(builder: (context, _) {
              return AlertDialog(
                titlePadding: const EdgeInsets.only(top: 30, bottom: 10),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                actionsPadding: const EdgeInsets.all(10),
                title: const Text('Delete', textAlign: TextAlign.center),
                content: const Text(
                    "Are you sure you want to delete this post?",
                    textAlign: TextAlign.center),
                actions: <Widget>[
                  CustomElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    text: "Cancel",
                    color: ColorPalette.palette(context).warning,
                    type: ButtonType.outlined,
                  ),
                  Mutation(
                      options: MutationOptions(
                        document: gql(widget.delete.document),
                        update: (cache, result) {
                          if (result != null && (!result.hasException)) {
                            widget.delete.updateCache(cache, result);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Post Deleted')),
                            );
                          }
                        },
                        onError: (dynamic error) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Post Deletion Failed')),
                          );
                        },
                      ),
                      builder: (
                        RunMutation runMutation,
                        QueryResult? result,
                      ) {
                        return CustomElevatedButton(
                          onPressed: () {
                            runMutation({"id": widget.delete.id});
                          },
                          text: "Delete",
                          isLoading: result!.isLoading,
                          color: ColorPalette.palette(context).warning,
                        );
                      }),
                ],
              );
            });
          }),
    );
  }
}

class ReportPostButton extends StatefulWidget {
  final PostAction report;
  const ReportPostButton({
    Key? key,
    required this.report,
  }) : super(key: key);

  @override
  State<ReportPostButton> createState() => _ReportPostButtonState();
}

class _ReportPostButtonState extends State<ReportPostButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showDialog(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(builder: (context, _) {
              //Keys
              final formKey = GlobalKey<FormState>();

              //Controllers
              final description = TextEditingController();

              return AlertDialog(
                titlePadding: const EdgeInsets.only(top: 30, bottom: 10),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                actionsPadding: const EdgeInsets.all(10),
                title: const Text('Report', textAlign: TextAlign.center),
                content: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextFormField(
                        controller: description,
                        minLines: 5,
                        maxLines: 8,
                        decoration: const InputDecoration(
                            labelText: "Why do you report this post?"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter the reason for reporting";
                          }
                          return null;
                        }),
                  ),
                ),
                actions: <Widget>[
                  CustomElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    text: "Cancel",
                    color: ColorPalette.palette(context).warning,
                    type: ButtonType.outlined,
                  ),
                  Mutation(
                      options: MutationOptions(
                        document: gql(widget.report.document),
                        update: (cache, result) {
                          if (result != null && (!result.hasException)) {
                            widget.report.updateCache(cache, result);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Post reported & necessary action will be taken')),
                            );
                          }
                        },
                        onError: (dynamic error) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Report Failed: Server Error')),
                          );
                        },
                      ),
                      builder: (
                        RunMutation runMutation,
                        QueryResult? result,
                      ) {
                        return CustomElevatedButton(
                          onPressed: () {
                            final isValid = formKey.currentState!.validate();
                            if (!isValid) return;
                            runMutation({
                              "description": description.text,
                              "id": widget.report.id,
                              // "id": "8fed3965-dbeb-4102-b506-80a6e6e7bb7"
                            });
                          },
                          text: "Report",
                          isLoading: result!.isLoading,
                          color: ColorPalette.palette(context).warning,
                        );
                      }),
                ],
              );
            });
          }),
      child: const Icon(Icons.warning_rounded),
    );
  }
}
