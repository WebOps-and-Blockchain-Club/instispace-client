import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/link.dart' as url_launcher;

import '../../models/actions.dart';
import '../../models/post.dart';
import '../../models/tag.dart';
import '../addToCal.dart';
import '../button/elevated_button.dart';
import '../button/flat_icon_text_button.dart';
import '../form/text_form_field.dart';
import '../tagPage.dart';
import '../../utils/string_extension.dart';

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
        child: Text(
          "#" + tag.title,
          style: const TextStyle(color: Color(0xFF2f247b)),
        ),
      ),
    );
  }
}

class LikePostButton extends StatefulWidget {
  final LikePostModel like;
  const LikePostButton({Key? key, required this.like}) : super(key: key);

  @override
  State<LikePostButton> createState() => _LikePostButtonState();
}

class _LikePostButtonState extends State<LikePostButton> {
  late bool isLiked;
  late int count;

  @override
  void initState() {
    super.initState();
    isLiked = widget.like.isLikedByUser;
    count = widget.like.count;
  }

  @override
  Widget build(BuildContext context) {
    return Mutation(
        options: MutationOptions(document: gql(widget.like.mutationDocument)),
        builder: (
          RunMutation runMutation,
          QueryResult? result,
        ) =>
            InkWell(
              onTap: () {
                runMutation({"id": widget.like.fkPostId});
                setState(() {
                  if (isLiked) {
                    count -= 1;
                  } else {
                    count += 1;
                  }
                  isLiked = !isLiked;
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                      isLiked == true
                          ? Icons.thumb_up_alt
                          : Icons.thumb_up_alt_outlined,
                      color: const Color(0xFF2f247b)),
                  const SizedBox(width: 5),
                  Text(
                    count.toString(),
                    style: const TextStyle(color: Color(0xFF2f247b)),
                  )
                ],
              ),
            ));
  }
}

class CommentPostButton extends StatelessWidget {
  final CommentPostModel comment;
  const CommentPostButton({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.comment),
          const SizedBox(width: 5),
          Text(comment.count.toString(),
              style: const TextStyle(color: Color(0xFF2f247b))),
        ],
      ),
    );
  }
}

class StarPostButton extends StatefulWidget {
  final StarPostModel star;
  const StarPostButton({Key? key, required this.star}) : super(key: key);

  @override
  State<StarPostButton> createState() => _StarPostButtonState();
}

class _StarPostButtonState extends State<StarPostButton> {
  late bool isStarred;

  @override
  void initState() {
    super.initState();
    setState(() {
      isStarred = widget.star.isStarredByUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Mutation(
        options: MutationOptions(document: gql(widget.star.mutationDocument)),
        builder: (
          RunMutation runMutation,
          QueryResult? result,
        ) =>
            CustomFlatIconTextButton(
              icon: isStarred == true ? Icons.star : Icons.star_outline,
              text: "Star",
              onPressed: () {
                runMutation({"id": widget.star.fkPostId});
                setState(() {
                  isStarred = !isStarred;
                });
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

class SharePostButton extends StatefulWidget {
  final PostModel post;
  const SharePostButton({Key? key, required this.post}) : super(key: key);

  @override
  State<SharePostButton> createState() => _SharePostButtonState();
}

class _SharePostButtonState extends State<SharePostButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Share.share("*${widget.post.time}* \n${widget.post.description}");
      },
      child: const Icon(
        Icons.share,
        color: Color(0xFF2f247b),
      ),
    );
  }
}

class EditPostButton extends StatelessWidget {
  final Widget navigateTo;
  const EditPostButton({Key? key, required this.navigateTo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFlatIconTextButton(
      icon: Icons.edit_outlined,
      text: "Edit",
      onPressed: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => navigateTo));
      },
    );
  }
}

class DeletePostButton extends StatefulWidget {
  final DeletePostModel delete;
  final Future<QueryResult<Object?>?> Function()? refetch;
  const DeletePostButton(
      {Key? key, required this.delete, required this.refetch})
      : super(key: key);

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
                title: const Text(
                  'Delete',
                  style: TextStyle(color: Color(0xFF2f247b)),
                  textAlign: TextAlign.center,
                ),
                content: const Text(
                  "Are you sure you want to delete this post?",
                  textAlign: TextAlign.center,
                ),
                actions: <Widget>[
                  CustomElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    text: "Cancel",
                    backgroundColor: Colors.red[50] as Color,
                    textColor: Colors.red,
                    borderColor: Colors.red,
                  ),
                  Mutation(
                      options: MutationOptions(
                        document: gql(widget.delete.mutationDocument),
                        onCompleted: (dynamic resultData) {
                          widget.refetch!();
                          Navigator.pop(context);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Post Deleted')),
                          );
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
                            runMutation({"id": widget.delete.fkPostId});
                          },
                          text: "Delete",
                          isLoading: result!.isLoading,
                          backgroundColor: Colors.red,
                          borderColor: Colors.red,
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
  final ReportPostModel report;
  final Future<QueryResult<Object?>?> Function()? refetch;
  const ReportPostButton({Key? key, required this.report, this.refetch})
      : super(key: key);

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
                title: const Text(
                  'Report',
                  style: TextStyle(color: Color(0xFF2f247b)),
                  textAlign: TextAlign.center,
                ),
                content: Form(
                  key: formKey,
                  child: CustomTextFormField(
                    controller: description,
                    labelText: "Why do you report this post?",
                    minLines: 5,
                    maxLines: 8,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter the reason for reporting";
                      }
                      return null;
                    },
                  ),
                ),
                actions: <Widget>[
                  CustomElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    text: "Cancel",
                    backgroundColor: Colors.red[50] as Color,
                    textColor: Colors.red,
                    borderColor: Colors.red,
                  ),
                  Mutation(
                      options: MutationOptions(
                        document: gql(widget.report.mutationDocument),
                        onCompleted: (dynamic resultData) {
                          if (resultData != null) {
                            widget.refetch!();
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
                              // "id": widget.report.fkPostId,
                              "id": "8fed3965-dbeb-4102-b506-80a6e6e7bb7"
                            });
                          },
                          text: "Report",
                          isLoading: result!.isLoading,
                          backgroundColor: Colors.red,
                          borderColor: Colors.red,
                        );
                      }),
                ],
              );
            });
          }),
      child: const Icon(
        Icons.warning_rounded,
        color: Color(0xFF2f247b),
      ),
    );
  }
}
