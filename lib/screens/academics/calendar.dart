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
  List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  List<int> month_index = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
  List<HolidayModel?> holidays = [];

  Future<List<HolidayModel?>> getholiday() async {
    holidays = [];
    List<Holidayinfo?> infolist = [];

    HolidayModel? holidaydetails;
    for (var month in months) {
      // holidaydetails?.month = month;
      for (int i = 0; i < 31; i++) {
        Holidayinfo? info =
            Holidayinfo(date: (i + 1).toString(), title: "working day");

        infolist.add(info);
      }
      // holidaydetails?.info = infolist;
      holidaydetails = HolidayModel(info: infolist, month: month);
      holidays.add(holidaydetails);
    }

    for (int i = 0; i < holiday.length; i++) {
      holidays[int.parse(holiday[i].substring(5, 7)) - 1]
          ?.info[int.parse(holiday[i].substring(8, 10)) - 1]
          ?.title = holiday[i].substring(11, holiday[i].length);
    }
    print(holidays);
    return holidays;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int _month = DateTime.now().month - 1;
    final ScrollController _scrollController = ScrollController();
    final TextEditingController _courseCodeController = TextEditingController();

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
                    onPressed: () => fetchMore, child: const Text("Load More")),
      ),
    );
    // return const Center(
    //     child: Text(
    //   "Waiting for Harsh to Complete Backend",
    //   style: TextStyle(fontSize: 18),
    // ));
    // return NestedScrollView(
    //     physics: const CustomAlwaysScrollableScrollPhysics(),
    //     controller: _scrollController,
    //     headerSliverBuilder: (context, innerBoxIsScrolled) {
    //       return [];
    //     },
    //     body: FutureBuilder<List<HolidayModel?>>(
    //         future: getholiday(),
    //         builder: (context, snapshot) {
    //           if (snapshot.hasData) {
    //             return ListView(
    //               children: [
    //                 // Row(
    //                 //   children: [
    //                 //     for (int i = 0; i < 12; i++)
    //                 //       Padding(
    //                 //         padding: const EdgeInsets.all(3.0),
    //                 //         child: InkWell(
    //                 //           onTap: (() {
    //                 //             setState(() {
    //                 //               _month = i;
    //                 //             });
    //                 //           }),
    //                 //           child: AnimatedContainer(
    //                 //               duration: const Duration(milliseconds: 200),
    //                 //               decoration: BoxDecoration(
    //                 //                   color: i == _month
    //                 //                       ? Colors.white
    //                 //                       : Colors.blue,
    //                 //                   borderRadius: BorderRadius.circular(5)),
    //                 //               width: MediaQuery.of(context).size.width *
    //                 //                   0.17,
    //                 //               height: 50,
    //                 //               child: Align(
    //                 //                 alignment: Alignment.center,
    //                 //                 child: Text(
    //                 //                   months[i].substring(0, 3),
    //                 //                   textAlign: TextAlign.center,
    //                 //                   style: TextStyle(
    //                 //                       fontSize: 17,
    //                 //                       color: i == _month
    //                 //                           ? Colors.black
    //                 //                           : Colors.white),
    //                 //                 ),
    //                 //               )),
    //                 //         ),
    //                 //       )
    //                 //   ],
    //                 // ),
    //                 const SizedBox(
    //                   height: 12,
    //                 ),
    //                 DropdownButtonFormField(
    //                   value: _month,
    //                   items: month_index
    //                       .map((e) => DropdownMenuItem(
    //                             child: Text(months[e]),
    //                             value: e,
    //                           ))
    //                       .toList(),
    //                   onChanged: (val) {
    //                     setState(() {
    //                       _month = val as int;
    //                       print(_month);
    //                     });
    //                   },
    //                   icon: const Icon(
    //                     Icons.arrow_drop_down_circle,
    //                     color: Colors.blue,
    //                   ),
    //                   decoration: const InputDecoration(
    //                     labelText: "Month",
    //                     prefixIcon: Icon(
    //                       Icons.calendar_month_outlined,
    //                       color: Colors.blue,
    //                     ),
    //                   ),
    //                 ),
    //                 const SizedBox(
    //                   height: 10,
    //                 ),
    //                 for (var i = 0; i < 31; i++)
    //                   Padding(
    //                     padding: const EdgeInsets.symmetric(horizontal: 4.0),
    //                     child: AnimatedContainer(
    //                       // height: MediaQuery.of(context).size.height * 0.13,
    //                       duration: const Duration(milliseconds: 500),
    //                       width: double.infinity,
    //                       child: Card(
    //                         color: const Color.fromARGB(255, 255, 255, 255),
    //                         child: Row(
    //                           children: [
    //                             Container(
    //                               width:
    //                                   MediaQuery.of(context).size.width * 0.20,
    //                               // color: Colors.blue,
    //                               child: Column(
    //                                   mainAxisAlignment:
    //                                       MainAxisAlignment.center,
    //                                   crossAxisAlignment:
    //                                       CrossAxisAlignment.center,
    //                                   children: [
    //                                     Text(
    //                                       "Day - ${i + 1}",
    //                                       style: const TextStyle(
    //                                         fontSize: 15,
    //                                       ),
    //                                     ),
    //                                   ]),
    //                             ),
    //                             Padding(
    //                               padding: const EdgeInsets.all(15),
    //                               child: Column(
    //                                 crossAxisAlignment:
    //                                     CrossAxisAlignment.start,
    //                                 mainAxisAlignment: MainAxisAlignment.center,
    //                                 children: [
    //                                   Text(
    //                                     holidays[_month]?.info[i] == null
    //                                         ? "-"
    //                                         : holidays[_month]!
    //                                             .info[i]!
    //                                             .title
    //                                             .toString(),
    //                                     style: const TextStyle(
    //                                         fontSize: 15,
    //                                         fontWeight: FontWeight.w500),
    //                                   ),
    //                                   const SizedBox(
    //                                     height: 7.50,
    //                                   ),
    //                                 ],
    //                               ),
    //                             )
    //                           ],
    //                         ),
    //                       ),
    //                     ),
    //                   )
    //               ],
    //             );
    //           }
    //           if (snapshot.connectionState == ConnectionState.waiting)
    //             return const CircularProgressIndicator();
    //           else {
    //             print("no connection");
    //             return Container();
    //           }
    //         }));
  }
}
