import 'package:client/models/holiday_info.dart';
import 'package:client/utils/time_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:client/widgets/button/icon_button.dart';
import 'package:client/widgets/headers/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class AlwaysScrollableScrollPhysics extends ScrollPhysics {
  /// Creates scroll physics that always lets the user scroll.
  const AlwaysScrollableScrollPhysics({ScrollPhysics? parent})
      : super(parent: parent);

  @override
  AlwaysScrollableScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return AlwaysScrollableScrollPhysics(parent: buildParent(ancestor));
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
    return Scaffold(
        // body: SafeArea(
        //     child: Padding(
        //         padding: const EdgeInsets.symmetric(horizontal: 15),
        //         child: NestedScrollView(
        //             physics: const AlwaysScrollableScrollPhysics(),
        //             controller: _scrollController,
        //             headerSliverBuilder: (context, innerBoxIsScrolled) {
        //               return [
        //                 SliverList(
        //                   delegate: SliverChildBuilderDelegate(
        //                       (BuildContext context, int index) {
        //                     return CustomAppBar(
        //                       title: "Timetable",
        //                       leading: CustomIconButton(
        //                           icon: Icons.arrow_back,
        //                           onPressed: () => Navigator.of(context).pop()),
        //                     );
        //                   }, childCount: 1),
        //                 ),
        //               ];
        //             },
        //             body: Column(children: [
        //               Text(_selectedDay.toString().split(" ")[0]),
        //               TableCalendar(
        //                 firstDay: DateTime.utc(2020, 1, 1),
        //                 lastDay: DateTime.utc(2023, 12, 31),
        //                 focusedDay: _focusedDay,
        //                 selectedDayPredicate: (day) {
        //                   return isSameDay(_selectedDay, day);
        //                 },
        //                 onDaySelected: (selectedDay, focusedDay) {
        //                   if (!isSameDay(_selectedDay, selectedDay)) {
        //                     // Call `setState()` when updating the selected day
        //                     setState(() {
        //                       _selectedDay = selectedDay;
        //                       _focusedDay = focusedDay;
        //                     });
        //                   }
        //                 },
        //                 onPageChanged: (focusedDay) {
        //                   _focusedDay = focusedDay;
        //                 },
        //               )
        //             ])))
        body: SafeArea(
            child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: NestedScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return CustomAppBar(
                    title: "Calender",
                    leading: CustomIconButton(
                        icon: Icons.arrow_back,
                        onPressed: () => Navigator.of(context).pop()),
                  );
                }, childCount: 1),
              ),
            ];
          },
          body: FutureBuilder<List<HolidayModel?>>(
              future: getholiday(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView(scrollDirection: Axis.horizontal, children: [
                    Row(
                      children: [
                        for (int i = 0; i < 12; i++)
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: InkWell(
                              onTap: (() {
                                setState(() {
                                  _month = i;
                                });
                              }),
                              child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  decoration: BoxDecoration(
                                      color: i == _month
                                          ? Colors.white
                                          : Colors.blue,
                                      borderRadius: BorderRadius.circular(5)),
                                  width:
                                      MediaQuery.of(context).size.width * 0.17,
                                  height: 50,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      months[i].substring(0, 3),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: i == _month
                                              ? Colors.black
                                              : Colors.white),
                                    ),
                                  )),
                            ),
                          )
                      ],
                    ),
                    for (var i = 0; i < 31; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: AnimatedContainer(
                          height: MediaQuery.of(context).size.height * 0.13,
                          duration: const Duration(milliseconds: 500),
                          width: double.infinity,
                          child: Card(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            child: Row(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.20,
                                  color: Colors.blue,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Day",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white),
                                        ),
                                        const SizedBox(
                                          height: 7.50,
                                        ),
                                        const Text("-"),
                                        const SizedBox(
                                          height: 7.50,
                                        ),
                                        Text(
                                          "${i + 1}",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white),
                                        ),
                                      ]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 7.50,
                                      ),
                                      Text(
                                        holidays[_month]?.info[i] == null
                                            ? "Working day"
                                            : holidays[_month]!
                                                .info[i]!
                                                .title
                                                .toString(),
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(
                                        height: 7.50,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                  ]);
                }
                if (snapshot.connectionState == ConnectionState.waiting)
                  return CircularProgressIndicator();
                else {
                  print("no connection");
                  return Container();
                }
              })),
    )));
  }
}
