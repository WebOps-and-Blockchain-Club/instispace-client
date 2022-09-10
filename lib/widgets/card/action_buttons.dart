import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/link.dart' as url_launcher;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../main.dart';
import '../../models/date_time_format.dart';
import '../button/elevated_button.dart';
import '../button/flat_icon_text_button.dart';
import '../helpers/navigate.dart';
import '../../screens/home/tag/tag.dart';
import '../../models/comment.dart';
import '../../models/actions.dart';
import '../../models/post.dart';
import '../../models/tag.dart';
import '../../utils/string_extension.dart';
import '../../themes.dart';
import '../text/label.dart';

class CTAButton extends StatelessWidget {
  final CTAModel cta;
  const CTAButton({Key? key, required this.cta}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return url_launcher.Link(
      target: url_launcher.LinkTarget.blank,
      uri: Uri.parse(
          cta.link.contains("http") ? cta.link : "http://" + cta.link),
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
            builder: (BuildContext context) => TagPage(tag: tag)));
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
  final PostAction? likeAction;
  const LikePostButton({Key? key, required this.like, required this.likeAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Mutation(
        options: MutationOptions(
            document: gql(likeAction != null ? likeAction!.document : ""),
            update: (cache, result) {
              if (result != null && (!result.hasException)) {
                likeAction!.updateCache(cache, result);
              }
            }),
        builder: (
          RunMutation runMutation,
          QueryResult? result,
        ) =>
            InkWell(
              onTap: () {
                if (!(result != null && result.isLoading) &&
                    likeAction != null) {
                  runMutation({"id": likeAction!.id});
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
  final NavigateAction? commentPage;
  const CommentPostButton(
      {Key? key, required this.comment, required this.commentPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (commentPage != null) navigate(context, commentPage!.to);
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
  final PostAction? starAction;
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
            document: gql(
                widget.starAction != null ? widget.starAction!.document : ""),
            update: (cache, result) {
              if (result != null && (!result.hasException)) {
                setState(() {
                  isStarred = !isStarred;
                });
                widget.starAction!.updateCache(cache, result);
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
                if (!(result != null && result.isLoading) &&
                    widget.starAction != null) {
                  runMutation({"id": widget.starAction!.id});
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
        Navigator.of(context).pop(),
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(builder: (context, _) {
                final date = TextEditingController();
                final dateFormated = TextEditingController();
                final time = TextEditingController();
                final timeFormated = TextEditingController();
                final formKey = GlobalKey<FormState>();
                setReminderData() {
                  if (post.time != null) {
                    DateTimeFormatModel _time =
                        DateTimeFormatModel.fromString(post.time!);
                    date.text = _time.dateTime.toString();
                    dateFormated.text = _time.toFormat("MMM dd, yyyy");
                    time.text = _time.dateTime.toString();
                    timeFormated.text = _time.toFormat("h:mm a");
                  }
                }

                setReminderData();

                return AlertDialog(
                  titlePadding: const EdgeInsets.only(top: 30, bottom: 10),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  actionsPadding: const EdgeInsets.all(10),
                  title: const Text('Reminder', textAlign: TextAlign.center),
                  content: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //date and time
                        const LabelText(text: "Time & Location"),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: TextFormField(
                              controller: dateFormated,
                              decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                      Icons.calendar_month_outlined,
                                      size: 20),
                                  prefixIconConstraints:
                                      Themes.inputIconConstraints,
                                  labelText: "Event Date"),
                              readOnly: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter the event date of the post";
                                }
                                return null;
                              },
                              onTap: () => showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now()
                                              .add(const Duration(days: 7)),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime.now().add(
                                              const Duration(days: 30 * 5)))
                                      .then(
                                    (value) {
                                      if (value != null) {
                                        date.text = value.toString();
                                        DateTimeFormatModel _date =
                                            DateTimeFormatModel(
                                                dateTime: value);
                                        dateFormated.text =
                                            _date.toFormat("MMM dd, yyyy");
                                      }
                                    },
                                  )),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: TextFormField(
                              controller: timeFormated,
                              decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                      Icons.access_time_outlined,
                                      size: 20),
                                  prefixIconConstraints:
                                      Themes.inputIconConstraints,
                                  labelText: "Event Time"),
                              readOnly: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter the event time of the post";
                                }
                                return null;
                              },
                              onTap: () => showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  ).then((value) {
                                    if (value != null) {
                                      DateTime _dateTime = DateTime(
                                          2021, 1, 1, value.hour, value.minute);
                                      time.text = _dateTime.toString();
                                      DateTimeFormatModel _time =
                                          DateTimeFormatModel(
                                              dateTime: _dateTime);
                                      timeFormated.text =
                                          _time.toFormat("h:mm a");
                                    }
                                  })),
                        ),
                      ],
                    ),
                  ),
                  //...........
                  actions: <Widget>[
                    CustomElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        tz.initializeTimeZones();
                        print(
                            "${date.text.split(" ")[0]} ${time.text.split(" ")[1]}");
                        await flutterLocalNotificationsPlugin.zonedSchedule(
                            1,
                            post.title,
                            post.description,
                            // tz.TZDateTime.now(tz.local)
                            //     .add(const Duration(seconds: 5)),
                            tz.TZDateTime.parse(tz.local,
                                "${date.text.split(" ")[0]} ${time.text.split(" ")[1]}"),
                            const NotificationDetails(
                              android: AndroidNotificationDetails(
                                'High_importance_channel',
                                'High Importance Notifications',
                                channelDescription:
                                    'This channel is used for important notifications.',
                                color: Color(0xFF2F247B),
                                playSound: true,
                                icon: '@mipmap/ic_launcher',
                              ),
                              iOS: IOSNotificationDetails(
                                sound: 'default.wav',
                                presentAlert: true,
                                presentBadge: true,
                                presentSound: true,
                              ),
                            ),
                            androidAllowWhileIdle: true,
                            uiLocalNotificationDateInterpretation:
                                UILocalNotificationDateInterpretation
                                    .absoluteTime);
                      },
                      text: "Set",
                      color: ColorPalette.palette(context).warning,
                      type: ButtonType.outlined,
                    ),
                  ],
                );
              });
            })
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
        await Share.share("*${post.title}* \n${post.description}");
      },
      child: const Icon(Icons.share),
    );
  }
}

class EditPostButton extends StatelessWidget {
  final NavigateAction? edit;
  const EditPostButton({Key? key, required this.edit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFlatIconTextButton(
      icon: Icons.edit_outlined,
      text: "Edit",
      onPressed: () {
        Navigator.of(context).pop();
        if (edit != null) navigate(context, edit!.to);
      },
    );
  }
}

class DeletePostButton extends StatefulWidget {
  final PostAction? delete;
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
      onPressed: () {
        Navigator.of(context).pop();
        if (widget.delete != null) {
          showDialog(
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
                            document: gql(widget.delete != null
                                ? widget.delete!.document
                                : ""),
                            update: (cache, result) {
                              if (result != null && (!result.hasException)) {
                                widget.delete!.updateCache(cache, result);
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
                                runMutation({"id": widget.delete!.id});
                              },
                              text: "Delete",
                              isLoading: result!.isLoading,
                              color: ColorPalette.palette(context).warning,
                            );
                          }),
                    ],
                  );
                });
              });
        }
      },
    );
  }
}

class ResolvePostButton extends StatefulWidget {
  final PostAction? resolve;
  const ResolvePostButton({Key? key, required this.resolve}) : super(key: key);

  @override
  State<ResolvePostButton> createState() => _ResolvePostButtonState();
}

class _ResolvePostButtonState extends State<ResolvePostButton> {
  @override
  Widget build(BuildContext context) {
    return CustomFlatIconTextButton(
      icon: Icons.done_all_outlined,
      text: "Item Found/Returned",
      onPressed: () {
        Navigator.of(context).pop();
        if (widget.resolve != null) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(builder: (context, _) {
                  return AlertDialog(
                    titlePadding: const EdgeInsets.only(top: 30, bottom: 10),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    actionsPadding: const EdgeInsets.all(10),
                    title: const Text('Item Found/Returned',
                        textAlign: TextAlign.center),
                    content: const Text(
                        "Are you sure you want to close this post?",
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
                            document: gql(widget.resolve != null
                                ? widget.resolve!.document
                                : ""),
                            update: (cache, result) {
                              if (result != null && (!result.hasException)) {
                                widget.resolve!.updateCache(cache, result);
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Post Closed')),
                                );
                              }
                            },
                            onError: (dynamic error) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Failed, server error')),
                              );
                            },
                          ),
                          builder: (
                            RunMutation runMutation,
                            QueryResult? result,
                          ) {
                            return CustomElevatedButton(
                              onPressed: () {
                                runMutation({"id": widget.resolve!.id});
                              },
                              text: "Resolve",
                              isLoading: result!.isLoading,
                              color: ColorPalette.palette(context).warning,
                            );
                          }),
                    ],
                  );
                });
              });
        }
      },
    );
  }
}

class ReportPostButton extends StatefulWidget {
  final PostAction? report;
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
      onTap: () => widget.report != null
          ? showDialog(
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
                            document: gql(widget.report != null
                                ? widget.report!.document
                                : ""),
                            update: (cache, result) {
                              if (result != null && (!result.hasException)) {
                                widget.report!.updateCache(cache, result);
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
                                    content:
                                        Text('Report Failed: Server Error')),
                              );
                            },
                          ),
                          builder: (
                            RunMutation runMutation,
                            QueryResult? result,
                          ) {
                            return CustomElevatedButton(
                              onPressed: () {
                                final isValid =
                                    formKey.currentState!.validate();
                                if (!isValid) return;
                                runMutation({
                                  "description": description.text,
                                  "id": widget.report!.id,
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
              })
          : {},
      child: const Icon(Icons.warning_rounded),
    );
  }
}
