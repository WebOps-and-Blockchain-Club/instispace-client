import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../graphQL/teasure_hunt.dart';
import '../../models/teasure_hunt.dart';
import '../../widgets/helpers/loading.dart';
import '../../widgets/helpers/error.dart';
import 'question.dart';
import 'group.dart';

class TeasureHuntWrapper extends StatefulWidget {
  const TeasureHuntWrapper({Key? key}) : super(key: key);

  @override
  State<TeasureHuntWrapper> createState() => _TeasureHuntWrapperState();
}

class _TeasureHuntWrapperState extends State<TeasureHuntWrapper> {
  final fetchGroup = TeasureHuntGQL.fetchGroup;
  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(document: gql(fetchGroup)),
        builder: (QueryResult result, {FetchMore? fetchMore, refetch}) {
          return Scaffold(
            body: (() {
              if (result.hasException) {
                return Error(error: result.exception.toString());
              }

              if (result.isLoading) {
                return const Loading(
                  message: "Teasure Hunt Connecting...",
                );
              }

              final GroupModel? group =
                  result.data != null && result.data!["getGroup"] != null
                      ? GroupModel.fromJson(result.data!["getGroup"])
                      : null;

              if (group == null) {
                return GroupPage(refetch: refetch);
              } else {
                return QuestionsPage(group: group, refetch: refetch);
              }
            }()),
          );
        });
  }
}
