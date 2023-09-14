import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../widgets/section/main.dart';
import '../home/comment/main.dart';
import '../../widgets/helpers/error.dart';
import '../../widgets/helpers/loading.dart';
import '../../models/post.dart';
import '../../models/date_time_format.dart';
import '../../models/report.dart';
import '../../widgets/card/main.dart';
import '../../widgets/button/icon_button.dart';
import '../../graphQL/report.dart';
import '../../utils/string_extension.dart';
import '../../widgets/headers/main.dart';

class ReportedPostPage extends StatefulWidget {
  const ReportedPostPage({Key? key}) : super(key: key);

  @override
  State<ReportedPostPage> createState() => _ReportedPostPageState();
}

class _ReportedPostPageState extends State<ReportedPostPage> {
  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(document: gql(ReportGQL().get)),
        builder: (QueryResult result, {FetchMore? fetchMore, refetch}) {
          return Scaffold(
            appBar: AppBar(
                title: CustomAppBar(
                    title: "Reported Posts",
                    leading: CustomIconButton(
                      icon: Icons.arrow_back,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )),
                automaticallyImplyLeading: false),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: RefreshIndicator(
                    onRefresh: () => refetch!(),
                    child: Stack(
                      children: [
                        ListView(),
                        (() {
                          if (result.hasException) {
                            return Error(error: result.exception.toString());
                          }

                          if (result.isLoading && result.data == null) {
                            return const Loading();
                          }

                          final ReportsModel posts =
                              ReportsModel.fromJson(result.data!["getReports"]);

                          if (posts.netops == null && posts.queries == null) {
                            return const Error(
                                message: 'No reports', error: "");
                          }

                          return ListView(
                            shrinkWrap: true,
                            children: [
                              const SizedBox(height: 10),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          "To accept the report and hide the post permanently, click ",
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    const WidgetSpan(
                                      child: Icon(Icons.check, size: 18),
                                    ),
                                    TextSpan(
                                      text:
                                          "\nTo reject the report and make the post visible again click ",
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    const WidgetSpan(
                                      child: Icon(Icons.close, size: 18),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              if (posts.netops != null &&
                                  posts.netops!.isNotEmpty)
                                Section(
                                  title: "Networking & Opportunities",
                                  child: ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: posts.netops!.length,
                                      itemBuilder: (context, index) {
                                        return ReportCard(
                                          post: posts.netops![index],
                                          document:
                                              ReportGQL.resolveNetopReport,
                                          updateTypename: "Netop",
                                        );
                                      }),
                                ),
                              if (posts.queries != null &&
                                  posts.queries!.isNotEmpty)
                                Section(
                                  title: "Queries",
                                  child: ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: posts.queries!.length,
                                      itemBuilder: (context, index) {
                                        return ReportCard(
                                          post: posts.queries![index],
                                          document:
                                              ReportGQL.resolveMyQueryReport,
                                          updateTypename: "MyQuery",
                                        );
                                      }),
                                ),
                            ],
                          );
                        }())
                      ],
                    )),
              ),
            ),
          );
        });
  }
}

class ReportCard extends StatefulWidget {
  final PostModel post;
  final String document;
  final String updateTypename;
  const ReportCard(
      {Key? key,
      required this.post,
      required this.document,
      required this.updateTypename})
      : super(key: key);

  @override
  State<ReportCard> createState() => _ReportCardState();
}

class _ReportCardState extends State<ReportCard> {
  String? status;
  @override
  Widget build(BuildContext context) {
    final List<ReportModel>? reports = widget.post.reports;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // PostCard(
        //   post: widget.post,
        //   actions: PostActions(
        //       comment: NavigateAction(
        //           to: CommentsPage(comments: widget.post.comments!))),
        // ),

        Card(
          margin: const EdgeInsets.only(bottom: 5),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: reports!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText(
                        reports[index].description.capitalize(),
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SelectableText(
                          'Reported by ${reports[index].createdBy.name}, ${DateTimeFormatModel.fromString(reports[index].createdAt).toDiffString()} ago',
                          style: Theme.of(context).textTheme.labelSmall),
                    ],
                  ),
                );
              },
            ),
          ),
        ),

        // Report action buttons
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SelectableText(
                    'Status: ${widget.post.status!.capitalize()}',
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Mutation(
                    options: MutationOptions(
                      document: gql(widget.document),
                      update: (cache, result) {
                        if (result!.hasException) {
                        } else {
                          final Map<String, dynamic> updated = {
                            "__typename": widget.updateTypename,
                            "id": widget.post.id,
                            "status": status,
                          };
                          cache.writeFragment(
                            Fragment(
                                    document:
                                        gql(ReportGQL().updateStatusFragment))
                                .asRequest(idFields: {
                              '__typename': updated['__typename'],
                              'id': updated['id'],
                            }),
                            data: updated,
                            broadcast: false,
                          );
                        }
                      },
                      onError: (dynamic error) {
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
                      if (result != null && result.isLoading) {
                        return const Center(
                          child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              )),
                        );
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomIconButton(
                            icon: Icons.check,
                            onPressed: () {
                              const String _status = "REPORT_ACCEPTED";
                              setState(() {
                                status = _status;
                              });
                              runMutation({
                                "id": widget.post.id,
                                "status": _status,
                              });
                            },
                          ),
                          CustomIconButton(
                              icon: Icons.close,
                              onPressed: () {
                                const String _status = "REPORT_REJECTED";
                                setState(() {
                                  status = _status;
                                });
                                runMutation({
                                  "id": widget.post.id,
                                  "status": _status,
                                });
                              }),
                        ],
                      );
                    }),
              ],
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 20.0),
          child: Divider(),
        ),
      ],
    );
  }
}
