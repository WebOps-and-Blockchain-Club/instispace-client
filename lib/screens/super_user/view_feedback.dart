import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../graphQL/feedback.dart';

class ViewFeedback extends StatefulWidget {
  const ViewFeedback({Key? key}) : super(key: key);

  @override
  State<ViewFeedback> createState() => _ViewFeedbackState();
}

class _ViewFeedbackState extends State<ViewFeedback> {
  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(FeedbackGQL().get),
      ),
      builder: (QueryResult result, {fetchMore, refetch}) {
        final String? link = result.data?["getSheetLink"];
        return ListTile(
          leading: const Icon(Icons.feedback_outlined),
          horizontalTitleGap: 0,
          title: const Text("View Feedbacks"),
          onTap: () {
            if (link != null) launchUrlString(link);
          },
          enabled:
              (result.data != null) && (result.data?["getSheetLink"] != null),
        );
      },
    );
  }
}
