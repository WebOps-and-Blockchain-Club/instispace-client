import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:client/graphQL/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/widgets/button/icon_button.dart';
import 'package:client/widgets/headers/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../utils/time_table.dart';
import '../../models/course.dart';
import '../../database/academic.dart';
import 'dart:async';

class DailyScheduleScreen extends StatefulWidget {
  const DailyScheduleScreen({Key? key}) : super(key: key);

  @override
  State<DailyScheduleScreen> createState() => _DailyScheduleScreenState();
}

class _DailyScheduleScreenState extends State<DailyScheduleScreen> {
  String _day = DateFormat('EEEE').format(DateTime.now());
  List<String> days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"];
  int startDate = int.parse(DateFormat('d').format(DateTime.now()));
  List<CourseModel?> schedule = [];
  late List<List<String>>? slots = time_table[_day.toLowerCase()];
  List<String> start_timing = [
    "8:00 AM",
    "9:00 AM",
    "10:00 AM",
    "11:00 AM",
    "1:00 PM",
    "2:00 PM",
    "3:30 PM",
    "5:00 PM"
  ];
  List<String> end_timing = [
    "8:50 AM",
    "9:50 AM",
    "10:50 AM",
    "11:50 AM",
    "1:50 PM",
    "3:15 PM",
    "4:45 PM",
    "5:50 PM"
  ];
  bool checkDay(CourseModel? course, String day) {
    if (course == null) return true;
    if (day == "Monday") return course.monday;
    if (day == "Tuesday") return course.tuesday;
    if (day == "Wednesday") return course.wednesday;
    if (day == "Thursday") return course.thursday;
    if (day == "Friday") return course.friday;
    return false;
  }

  Future<List<CourseModel?>> getSchedule() async {
    schedule = [];

    if (_day == "Saturday" || _day == "Sunday") _day = "Monday";
    List<List<String>>? slots = time_table[_day.toLowerCase()];
    CourseModel? course;
    for (var slot in slots!) {
      if (slot.length == 1) {
        course = await AcademicDatabase.instance.getCourse(slot[0]);
        if (checkDay(course, _day))
          schedule.add(course);
        else
          schedule.add(null);
      } else {
        bool f = false;
        for (var slotA in slot) {
          course = await AcademicDatabase.instance.getCourse(slotA);
          if (course != null) {
            f = true;
            if (checkDay(course, _day))
              schedule.add(course);
            else
              schedule.add(null);
            break;
          }
        }
        if (f == false) schedule.add(null);
      }
    }

    for (var i = 0; i < schedule.length - 1; i++) {
      if (schedule[i] != null &&
          schedule[i + 1] != null &&
          schedule[i]!.slot == schedule[i + 1]!.slot) {
        // print("continuous class");
        dynamic res = schedule.removeAt(i + 1);
        end_timing[i] = end_timing[i + 1];
      }
    }
    //print(schedule);
    return (schedule);
  }

  void getScheduleHelper() async {
    schedule = await getSchedule();
  }

  @override
  void initState() {
    super.initState();
  }

  String getTruncatedName(String courseName) {
    if (courseName.length > 35) {
      courseName = courseName.substring(0, 35) + "...";
    }

    return courseName;
  }

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
                  body: FutureBuilder<List<CourseModel?>>(
                      future: getSchedule(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView(
                            children: [
                              Row(
                                children: [
                                  for (var i in days)
                                    Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: InkWell(
                                        onTap: (() {
                                          setState(() {
                                            _day = i;
                                            slots =
                                                time_table[_day.toLowerCase()];
                                          });
                                        }),
                                        child: AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 200),
                                            decoration: BoxDecoration(
                                                color: i == _day
                                                    ? Colors.white
                                                    : Colors.blue,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.17,
                                            height: 50,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                i.substring(0, 3),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    color: i == _day
                                                        ? Colors.black
                                                        : Colors.white),
                                              ),
                                            )),
                                      ),
                                    )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              for (var i = 0; i < schedule.length; i++)
                                schedule[i] == null
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0),
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${start_timing[i]} to ${end_timing[i]}",
                                                  style: TextStyle(
                                                      color: Colors.black54),
                                                ),
                                                const SizedBox(
                                                  width: 7.5,
                                                ),
                                                const Text("Free Slot")
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0),
                                        child: AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          width: double.infinity,
                                          child: Card(
                                            color: const Color.fromARGB(
                                                255, 255, 255, 255),
                                            child: IntrinsicHeight(
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  Container(
                                                    width: 5,
                                                    color: slot_color[
                                                        schedule[i]!.slot],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "${start_timing[i]} to ${end_timing[i]}",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black54),
                                                            ),
                                                            SizedBox(
                                                              width: 15,
                                                            ),
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                  color: slot_color[
                                                                      schedule[
                                                                              i]!
                                                                          .slot],
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5)),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        5.0),
                                                                child: Text(
                                                                  "${schedule[i]!.slot} SLOT",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 7.5,
                                                        ),
                                                        Text(
                                                          schedule[i]!
                                                              .courseCode,
                                                          style: const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        SizedBox(
                                                          height: 7.50,
                                                        ),
                                                        Text(
                                                          getTruncatedName(
                                                              schedule[i]!
                                                                  .courseName),
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                        SizedBox(
                                                          height: 7.50,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                            ],
                          );
                        }
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return Center(child: CircularProgressIndicator());
                        else {
                          print("no connection");
                          return Container();
                        }
                      }),
                ))));
  }
}
