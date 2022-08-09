import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../graphQL/mess_menu.dart';

class ViewMessMenu extends StatefulWidget {
  const ViewMessMenu({Key? key}) : super(key: key);

  @override
  State<ViewMessMenu> createState() => _MessMenuState();
}

class _MessMenuState extends State<ViewMessMenu> {
  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(MessMenuGQL.get),
      ),
      builder: (QueryResult result, {fetchMore, refetch}) {
        final String? link = result.data?["getMessMenu"];
        return ListTile(
          leading: const Icon(Icons.food_bank_outlined),
          horizontalTitleGap: 0,
          title: const Text("View Mess Menu"),
          onTap: () {
            if (link != null) launchUrlString(link);
          },
          enabled:
              (result.data != null) && (result.data?["getMessMenu"] != null),
        );
      },
    );
  }
}
