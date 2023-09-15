import 'package:client/services/local_storage.dart';

import '../../widgets/helpers/navigate.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../graphQL/teasure_hunt.dart';
import '../../models/teasure_hunt.dart';
import '../../widgets/helpers/loading.dart';
import '../../widgets/helpers/error.dart';
import '../../widgets/page/webpage.dart';
import 'question.dart';
import 'group.dart';

final localStorage = LocalStorageService();

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
                return Error(
                  error: result.exception.toString(),
                  onRefresh: refetch,
                );
              }

              if (result.isLoading) {
                return const Loading(
                  message: "Treasure Hunt Connecting...",
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
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.info),
              onPressed: () {
                navigate(
                    context,
                    const WebPage(
                      title: "Instructions",
                      url:
                          "https://docs.google.com/document/u/3/d/e/2PACX-1vRn4lLUBznrpX6CyVVCmUHMDiCdnNBl0NwdVL04Pbfp7EK15QWU1gH_M78gDXGuTPeaicWhEmIiiLqu/pub",
                    ));
              },
            ),
          );
        });
  }
}
