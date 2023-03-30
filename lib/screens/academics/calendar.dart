import 'package:client/graphQL/academics/calendar.dart';
import 'package:client/models/academic/calendar.dart';
import 'package:client/models/holiday_info.dart';
import 'package:client/utils/time_table.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../models/date_time_format.dart';
import '../../widgets/card.dart';
import '../user/search_user.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class CustomAlwaysScrollableScrollPhysics extends ScrollPhysics {
  /// Creates scroll physics that always lets the user scroll.
  const CustomAlwaysScrollableScrollPhysics({ScrollPhysics? parent})
      : super(parent: parent);

  @override
  CustomAlwaysScrollableScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomAlwaysScrollableScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) => true;
}

class _CalendarState extends State<Calendar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final QueryOptions<Object?> options = QueryOptions(
        document: gql(CalendarGQL.get),
        variables: CalendarQueryVariableModel().toJson(),
        parserFn: (data) => CalendarsModel.fromJson(data));

    return QueryList<CalendarModel>(
      options: options,
      itemBuilder: (data) => Padding(
        padding: const EdgeInsets.only(right: 20.0, left: 20, top: 20),
        child: CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                DateTimeFormatModel.fromString(data.date).toFormat("dd MMM yy"),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 5),
              Text(data.description)
            ],
          ),
        ),
      ),
      fetchMoreOption: (item) => FetchMoreOptions(
        variables: {...options.variables, "lastEntryId": item.id},
        updateQuery: (previousResultData, fetchMoreResultData) {
          final List<dynamic> repos = [
            ...previousResultData!['getCalendarEntry']['list'] as List<dynamic>,
            ...fetchMoreResultData!["getCalendarEntry"]["list"] as List<dynamic>
          ];
          fetchMoreResultData["getCalendarEntry"]["list"] = repos;
          return fetchMoreResultData;
        },
      ),
      endOfListWidget: (result, fetchMore) => Padding(
        padding: const EdgeInsets.all(20),
        child: (result.parsedData as CalendarsModel).total ==
                (result.parsedData as CalendarsModel).list.length
            ? null
            : result.isLoading
                ? const Center(child: CircularProgressIndicator())
                : TextButton(
                    onPressed: () => fetchMore(),
                    child: const Text("Load More")),
      ),
    );
  }
}
