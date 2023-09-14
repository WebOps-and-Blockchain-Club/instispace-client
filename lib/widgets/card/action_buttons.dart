import 'package:client/graphQL/feed.dart';
import 'package:client/screens/home/comment/main.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/link.dart' as url_launcher;
import '../../config.dart';
import '../../graphQL/report.dart';
import '../../models/date_time_format.dart';
import '../../models/post/actions.dart';
import '../../models/post/main.dart';
import '../../services/notification.dart';
import '../helpers/loading.dart';
import '../button/elevated_button.dart';
import '../button/flat_icon_text_button.dart';
import '../helpers/error.dart';
import '../helpers/navigate.dart';
// import '../../screens/home/tag/tag.dart';
// import '../../models/comment.dart';
import '../../models/actions.dart';
// import '../../models/postModel.dart';
import '../../utils/custom_icons.dart';
//import '../../models/post.dart';
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
        // TODO: Add tag page navigation
        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (BuildContext context) => TagPage(tag: tag)));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 0),
        child: Text("#" + tag.title,
            style: const TextStyle(color: Color(0xFF006096))),
      ),
    );
  }
}

class LikePostButton extends StatefulWidget {
  final String postId;
  final LikeModel like;
  final String type;
  const LikePostButton(
      {Key? key, required this.postId, required this.like, this.type = "like"})
      : super(key: key);

  @override
  State<LikePostButton> createState() => _LikePostButtonState();
}

class _LikePostButtonState extends State<LikePostButton>
// with SingleTickerProviderStateMixin
{
  // late final AnimationController _likeController = AnimationController(
  //     duration: const Duration(milliseconds: 200), vsync: this, value: 1.0);
  @override
  Widget build(BuildContext context) {
    final like = widget.like;
    return Mutation(
        options: MutationOptions(
            document: gql(FeedGQL().toggleLikePost),
            update: (cache, result) {
              if (result != null && (!result.hasException)) {
                final Map<String, dynamic> updated = {
                  "__typename": "Post",
                  "id": widget.postId,
                  "isLiked": !(like.isLikedByUser),
                  "likeCount":
                      like.isLikedByUser ? like.count - 1 : like.count + 1
                };
                cache.writeFragment(
                  Fragment(document: gql('''
                      fragment LikeField on Post{
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
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: widget.type == "like"
                      ? widget.like.isLikedByUser
                          ? const Icon(
                              CustomIcons.likefilled,
                              color: Colors.red,
                              size: 25,
                            )
                          : const Icon(
                              CustomIcons.like,
                              size: 25,
                            )
                      : Icon(
                          widget.like.isLikedByUser
                              ? Icons.thumb_up_alt
                              : Icons.thumb_up_alt_outlined,
                          size: 30,
                        ),
                  onPressed: () {
                    if (!(result != null && result.isLoading)) {
                      runMutation({"postId": widget.postId});
                    }
                  },
                ),
                // ScaleTransition(
                //   scale: Tween(begin: 0.7, end: 1.0).animate(CurvedAnimation(
                //       parent: _likeController, curve: Curves.easeOut)),
                //   child: IconButton(
                //     icon: widget.like.isLikedByUser
                //         ? const Icon(
                //             CustomIcons.likefilled,
                //             color: Colors.red,
                //             size: 25,
                //           )
                //         : const Icon(
                //             CustomIcons.like,
                //             size: 25,
                //           ),
                //     onPressed: () {
                //       //print(result);
                //       _likeController
                //           .reverse()
                //           .then((value) => _likeController.forward());
                //       if (!(result != null && result.isLoading)) {
                //         runMutation({"postId": widget.postId});
                //       }
                //     },
                //   ),
                // ),
                Text(widget.like.count.toString(),
                    style: Theme.of(context).textTheme.labelLarge)
              ],
            ));
  }
}

class DisLikePostButton extends StatefulWidget {
  final String postId;
  // TODO:
  final LikeModel like;
  const DisLikePostButton({Key? key, required this.postId, required this.like})
      : super(key: key);

  @override
  State<DisLikePostButton> createState() => _DisLikePostButtonState();
}

class _DisLikePostButtonState extends State<DisLikePostButton> {
  @override
  Widget build(BuildContext context) {
    final like = widget.like;
    return Mutation(
        options: MutationOptions(
            // TODO:
            document: gql(FeedGQL().toggleLikePost),
            update: (cache, result) {
              if (result != null && (!result.hasException)) {
                final Map<String, dynamic> updated = {
                  "__typename": "Post",
                  "id": widget.postId,
                  // TODO:
                  "isLiked": !(like.isLikedByUser),
                  // TODO:
                  "likeCount":
                      like.isLikedByUser ? like.count - 1 : like.count + 1
                };
                cache.writeFragment(
                  // TODO:
                  Fragment(document: gql('''
                      fragment LikeField on Post{
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
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    widget.like.isLikedByUser
                        ? Icons.thumb_down_alt
                        : Icons.thumb_down_alt_outlined,
                    size: 30,
                  ),
                  onPressed: () {
                    if (!(result != null && result.isLoading)) {
                      runMutation({"postId": widget.postId});
                    }
                  },
                ),
                Text(widget.like.count.toString(),
                    style: Theme.of(context).textTheme.labelLarge)
              ],
            ));
  }
}

class CommentPostButton extends StatelessWidget {
  final String postId;
  final CommentsModel comment;
  const CommentPostButton({
    Key? key,
    required this.postId,
    required this.comment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigate(context, CommentsPage(postId: postId, comments: comment));
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.comment, size: 27),
          const SizedBox(width: 5),
          Text(comment.count.toString(),
              style: Theme.of(context).textTheme.labelLarge),
        ],
      ),
    );
  }
}

class SavePostButton extends StatefulWidget {
  final String postId;
  final SavePostModel save;
  const SavePostButton({
    Key? key,
    required this.postId,
    required this.save,
  }) : super(key: key);

  @override
  State<SavePostButton> createState() => _SavePostButtonState();
}

class _SavePostButtonState extends State<SavePostButton> {
  late bool isStarred;

  @override
  void initState() {
    super.initState();
    isStarred = widget.save.isSavedByUser;
  }

  @override
  Widget build(BuildContext context) {
    final save = widget.save;
    return Mutation(
        options: MutationOptions(
            document: gql(FeedGQL().toggleSavePost),
            update: (cache, result) {
              if (result != null && (!result.hasException)) {
                setState(() {
                  isStarred = !isStarred;
                });
                final Map<String, dynamic> updated = {
                  "__typename": "Event",
                  "id": widget.postId,
                  "isSaved": !(save.isSavedByUser),
                };
                cache.writeFragment(
                  Fragment(document: gql('''
                      fragment postSaveField on Post{
                        id
                        isSaved
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
            InkWell(
              onTap: () {
                if (!(result != null && result.isLoading)) {
                  runMutation({"postId": widget.postId});
                }
              },
              child: Icon(
                isStarred == true
                    ? Icons.bookmark_outlined
                    : Icons.bookmark_border,
                size: 30,
              ),
            ));
  }
}

class SetReminderButton extends StatelessWidget {
  final PostModel post;
  const SetReminderButton({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: const Icon(
        CustomIcons.reminder,
        size: 25,
      ),
      onTap: () => {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(builder: (context, _) {
                final date = TextEditingController();
                final dateFormated = TextEditingController();
                final time = TextEditingController();
                final timeFormated = TextEditingController();
                final formKey = GlobalKey<FormState>();
                final LocalNotificationService service =
                    LocalNotificationService();
                setReminderData() {
                  if (post.createdAt != null) {
                    DateTimeFormatModel _time =
                        DateTimeFormatModel.fromString(post.createdAt);
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
                                          initialDate: DateTime.now(),
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
                  actions: <Widget>[
                    CustomElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await service.scheduleNotification(
                            title: post.title!,
                            description: post.content!,
                            time:
                                "${date.text.split(" ")[0]} ${time.text.split(" ")[1]}");
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Reminder set Successfully')),
                        );
                      },
                      text: "Set Reminder",
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
    String shareLink = "${shareBaseLink}post/${post.id}";
    return InkWell(
      onTap: () async {
        await Share.share(shareLink, subject: post.title);
      },
      child: const Icon(
        CustomIcons.share,
        size: 25,
      ),
    );
  }
}
/*
// class EditPostButton extends StatelessWidget {
//   final NavigateAction? edit;
//   const EditPostButton({Key? key, required this.edit}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return CustomFlatIconTextButton(
//       icon: Icons.edit_outlined,
//       text: "Edit",
//       onPressed: () {
//         Navigator.of(context).pop();
//         if (edit != null) navigate(context, edit!.to);
//       },
//     );
//   }
// }

// class DeletePostButton extends StatefulWidget {
//   final PostAction? delete;
//   const DeletePostButton({Key? key, required this.delete}) : super(key: key);

//   @override
//   State<DeletePostButton> createState() => _DeletePostButtonState();
// }

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
                                SnackBar(
                                    content: Text(
                                        formatErrorMessage(error.toString()))),
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
*/
/*
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
                                SnackBar(
                                    content: Text(
                                        formatErrorMessage(error.toString()))),
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
*/

class ReportPostButton extends StatefulWidget {
  final String postId;
  final QueryOptions<Object?> options;

  const ReportPostButton({
    Key? key,
    required this.postId,
    required this.options,
  }) : super(key: key);

  @override
  State<ReportPostButton> createState() => _ReportPostButtonState();
}

class _ReportPostButtonState extends State<ReportPostButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context).pop(),
              child: GestureDetector(
                onTap: () {},
                child: DraggableScrollableSheet(
                  initialChildSize: 0.7,
                  minChildSize: 0.5,
                  maxChildSize: 0.8,
                  builder: (_, controller) => Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      child: Report(
                        postId: widget.postId,
                        options: widget.options,
                        controller: controller,
                      )),
                ),
              ),
            );
          }),
      child: const Icon(Icons.warning_rounded, size: 30),
    );
  }
}

class Report extends StatefulWidget {
  // final PostAction? report;
  final String postId;
  final QueryOptions<Object?> options;
  final ScrollController controller;

  const Report(
      {Key? key,
      required this.postId,
      required this.options,
      required this.controller})
      : super(key: key);

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  String? description;
  @override
  Widget build(BuildContext context) {
    final options = widget.options;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Query(
          options: QueryOptions(document: gql(ReportGQL.getReportReasons)),
          builder: (QueryResult result, {fetchMore, refetch}) {
            if (result.isLoading && result.data == null) {
              return const Loading();
            }
// TODO:
            final List<String> reasons = result.data!["reportreasons"]
                .map((_data) => _data["reason"])
                .toList()
                .cast<String>();

            if (reasons.isEmpty) {
              return const Error(message: "No Report Reasons Found", error: "");
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Text(
                    "Why do you report this post?",
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      controller: widget.controller,
                      itemCount: reasons.length,
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        return ListTile(
                          dense: true,
                          onTap: () {
                            setState(() {
                              description = reasons[i];
                            });
                          },
                          leading: SizedBox(
                            width: 20,
                            height: 20,
                            child: Radio<String>(
                              value: reasons[i],
                              groupValue: description,
                              onChanged: (String? value) {
                                setState(() {
                                  description = value;
                                });
                              },
                            ),
                          ),
                          title: Text(
                            reasons[i],
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        );
                      }),
                ),
                Mutation(
                    options: MutationOptions(
                      document: gql(FeedGQL().report),
                      update: (cache, result) {
                        if (result != null && (!result.hasException)) {
                          dynamic data = cache.readQuery(options.asRequest);
                          dynamic newData = [];
                          for (var i = 0;
                              i < data["findPosts"]["list"].length;
                              i++) {
                            if (data["findPosts"]["list"][i]["id"] !=
                                widget.postId) {
                              newData =
                                  newData + [data["findPosts"]["list"][i]];
                            }
                          }
                          data["findPosts"]["list"] = newData;
                          data["findPosts"]["total"] =
                              data["findPosts"]["total"] - 1;
                          cache.writeQuery(options.asRequest, data: data);
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
                          SnackBar(
                              content:
                                  Text(formatErrorMessage(error.toString()))),
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
                              description != null && description!.isNotEmpty;
                          if (!isValid) return;
                          runMutation({
                            "createReportInput": {
                              "description": description,
                            },
                            "postId": widget.postId,
                          });
                        },
                        text: "Report",
                        isLoading: result!.isLoading,
                        color: ColorPalette.palette(context).warning,
                      );
                    }),
              ],
            );
          }),
    );
  }
}

/**
 *  runMutation({
                                  "reportPostInput": {
                                    "description": description ?? "",
                                  },
                                  "id": widget.report!.id,
                                });
 */
/**
 *           ? showDialog(
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
                                SnackBar(
                                    content: Text(
                                        formatErrorMessage(error.toString()))),
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
 */
