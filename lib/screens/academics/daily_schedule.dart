import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:client/graphQL/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/widgets/button/icon_button.dart';
import 'package:client/widgets/headers/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import '../../utils/time_table.dart';
import '../../models/course.dart';
import '../../database/academic.dart';
import 'dart:async';

class Pair<T1, T2> {
  final T1 a;
  final T2 b;

  Pair(this.a, this.b);
}

class DailyScheduleScreen extends StatefulWidget {
  const DailyScheduleScreen({Key? key}) : super(key: key);

  @override
  State<DailyScheduleScreen> createState() => _DailyScheduleScreenState();
}

class _DailyScheduleScreenState extends State<DailyScheduleScreen> {
  String _day = DateFormat('EEEE').format(DateTime.now());
  List<String> days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"];
  int startDate = int.parse(DateFormat('d').format(DateTime.now()));
  List<Pair<String?, CourseModel?>> schedule = [];

  String getTimings(String day, String slot, int index) {
    if (time_table[day.toLowerCase()]![slot]![0] > 7) {
      return "${start_timing[index + 8]} to ${end_timing[index + 8]}";
    } else {
      return "${start_timing[index]} to ${end_timing[index]}";
    }
  }

  Future<List<Pair<String?, CourseModel?>>> getSchedule() async {
    schedule = [];

    if (_day == "Saturday" || _day == "Sunday") {
      _day = "Monday";
    }

    String d = _day == "Thursday" ? "th" : _day[0].toLowerCase();
    CoursesModel? coursesForDay = await AcademicDatabase.instance.getCourses(d);

    //Intializing Schedule list with free slots
    //Course = null corresponds to free slot
    for (int i = 0; i < 8; i++) {
      schedule.add(Pair("", null));
    }
    for (int i = 0; i < 11; i++) {
      List<int>? indices = time_table[_day.toLowerCase()]?.values.elementAt(i);
      for (int index in indices!) {
        if (schedule[index > 7 ? index - 8 : index] == Pair("", null)) {
          schedule[index] =
              Pair(time_table[_day.toLowerCase()]?.keys.elementAt(i), null);
        } else {
          schedule[index > 7 ? index - 8 : index] = Pair(
              schedule[index > 7 ? index - 8 : index].a! +
                  ',' +
                  time_table[_day.toLowerCase()]!.keys.elementAt(i),
              null);
        }
      }
    }

    for (var course in coursesForDay!.courses) {
      List<String> slots = course.slots.split('&');
      for (String slot in slots) {
        if (slot.contains(d + '*')) {
          List<int>? indices =
              time_table[_day.toLowerCase()]![slot.split(',')[0]];
          for (var index in indices!) {
            //adding extra XX or YY type slot
            if (index == 16) schedule.add(Pair('', null));
            schedule[index > 7 ? index - 8 : index] =
                Pair(slot.split(',')[0], course);
          }
        }
      }
    }
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
                  body: FutureBuilder<List<Pair<String?, CourseModel?>>>(
                      future: getSchedule(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData ||
                            snapshot.connectionState == ConnectionState.done) {
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
                                            //slots =
                                            //time_table[_day.toLowerCase()];
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
                                schedule[i].b == null
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
                                                  getTimings(_day,
                                                      schedule[i].a![1], i),
                                                  style: const TextStyle(
                                                      color: Colors.black54),
                                                ),
                                                const SizedBox(
                                                  width: 7.5,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: Colors.grey,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Text(
                                                        "SLOT ${schedule[i].a!.substring(1)}",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        )),
                                                  ),
                                                )
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
                                                        schedule[i]
                                                            .b!
                                                            .slots[0]],
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
                                                              getTimings(
                                                                  _day,
                                                                  schedule[i]
                                                                      .a!,
                                                                  i),
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
                                                                              i]
                                                                          .a!],
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
                                                                  "${schedule[i].a} SLOT",
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
                                                          schedule[i]
                                                              .b!
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
                                                              schedule[i]
                                                                  .b!
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
                          print(snapshot.connectionState);
                          return Container();
                        }
                      }),
                ))));
  }
}
