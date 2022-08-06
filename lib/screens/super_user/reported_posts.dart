import 'package:client/screens/home/comment/main.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

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
                    child: (() {
                      if (result.hasException) {
                        return SelectableText(result.exception.toString());
                      }

                      if (result.isLoading && result.data == null) {
                        return const Text('Loading');
                      }

                      final List<ReportModel> reports =
                          ReportsModel.fromJson(result.data!["getReports"])
                              .report;

                      if (reports.isEmpty) {
                        return const Text('No reports');
                      }

                      return ListView(
                        children: [
                          const SizedBox(height: 10),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      "To the accept the report and hide the post permantly, click ",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                const WidgetSpan(
                                  child: Icon(Icons.check, size: 18),
                                ),
                                TextSpan(
                                  text:
                                      "\nTo reject the report and make the visible back again click ",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                const WidgetSpan(
                                  child: Icon(Icons.close, size: 18),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: reports.length,
                              itemBuilder: (context, index) {
                                return ReportCard(
                                  report: reports[index],
                                  refetch: refetch,
                                );
                              }),
                        ],
                      );
                    }())),
              ),
            ),
          );
        });
  }
}

class ReportCard extends StatefulWidget {
  final ReportModel report;
  final Future<QueryResult<Object?>?> Function()? refetch;
  const ReportCard({Key? key, required this.report, this.refetch})
      : super(key: key);

  @override
  State<ReportCard> createState() => _ReportCardState();
}

class _ReportCardState extends State<ReportCard> {
  String? status;
  @override
  Widget build(BuildContext context) {
    final ReportModel report = widget.report;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          margin: const EdgeInsets.only(bottom: 5),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  report.description.capitalize(),
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SelectableText(
                    'Reported by ${report.createdBy.name}, ${DateTimeFormatModel.fromString(report.createdAt).toDiffString()} ago',
                    style: Theme.of(context).textTheme.labelSmall),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SelectableText(
                    'Status: ${report.status.capitalize()}',
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),

                // Report action buttons
                Mutation(
                    options: MutationOptions(
                      document: gql(ReportGQL().resolveReport),
                      update: (cache, result) {
                        if (result!.hasException) {
                        } else {
                          final Map<String, dynamic> updated = {
                            "__typename": "Report",
                            "id": report.id,
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
                          const SnackBar(content: Text('Update Failed')),
                        );
                      },
                    ),
                    builder: (
                      RunMutation runMutation,
                      QueryResult? result,
                    ) {
                      if (result != null && result.isLoading) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                )),
                          ),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
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
                                  "resolveReportId": report.id,
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
                                    "resolveReportId": report.id,
                                    "status": _status,
                                  });
                                }),
                          ],
                        ),
                      );
                    })
              ],
            ),
          ),
        ),
        PostCard(
          post: report.netop ?? report.query!,
          actions: PostActions(
              comment: NavigateAction(
                  to: CommentsPage(
                      comments: report.netop != null
                          ? report.netop!.comments!
                          : report.query!.comments!))),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 20.0),
          child: Divider(),
        ),
      ],
    );
  }
}
