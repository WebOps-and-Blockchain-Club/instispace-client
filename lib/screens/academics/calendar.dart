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

class _CalendarState extends State<Calendar> {
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();
    final TextEditingController _courseCodeController = TextEditingController();
    return Scaffold(
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
                              title: "Timetable",
                              leading: CustomIconButton(
                                  icon: Icons.arrow_back,
                                  onPressed: () => Navigator.of(context).pop()),
                            );
                          }, childCount: 1),
                        ),
                      ];
                    },
                    body: Column(children: [
                      Text(_selectedDay.toString().split(" ")[0]),
                      TableCalendar(
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: DateTime.utc(2023, 12, 31),
                        focusedDay: _focusedDay,
                        selectedDayPredicate: (day) {
                          return isSameDay(_selectedDay, day);
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          if (!isSameDay(_selectedDay, selectedDay)) {
                            // Call `setState()` when updating the selected day
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay;
                            });
                          }
                        },
                        onPageChanged: (focusedDay) {
                          _focusedDay = focusedDay;
                        },
                      )
                    ])))));
  }
}
