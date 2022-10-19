import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../graphQL/events.dart';
import '../../../models/event.dart';
import '../../../widgets/page/post.dart';
import 'actions.dart';

class EventPage extends StatefulWidget {
  final String id;
  const EventPage({Key? key, required this.id}) : super(key: key);

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    final QueryOptions<Object?> options = QueryOptions(
        document: gql(EventGQL().get), variables: {"id": widget.id});
    return PostPage(
      header: "Event",
      queryOptions: options,
      toPostsModel: (data) =>
          EventModel.fromJson(data!["getEvent"]).toPostModel(),
      actions: (post) => eventActions(post, options),
    );
  }
}
