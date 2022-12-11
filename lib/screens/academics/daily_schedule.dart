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

  Future<List<CourseModel?>> getSchedule() async {
    schedule = [];
    if (_day == "Saturday" || _day == "Sunday") _day = "Monday";
    List<List<String>>? slots = time_table[_day.toLowerCase()];
    CourseModel? course;
    int c = 0;
    for (var slot in slots!) {
      print(c++);
      if (slot.length == 1) {
        course = await AcademicDatabase.instance.getCourse(slot[0]);
        schedule.add(course);
      } else {
        bool f = false;
        for (var slotA in slot) {
          course = await AcademicDatabase.instance.getCourse(slotA);
          if (course != null) {
            f = true;
            schedule.add(course);
            break;
          }
        }
        if (f == false) schedule.add(null);
      }
    }
    print(schedule);
    return (schedule);
  }

  void getScheduleHelper() async {
    schedule = await getSchedule();
  }

  @override
  void initState() {
    super.initState();
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
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: AnimatedContainer(
                                    height: MediaQuery.of(context).size.height *
                                        0.13,
                                    duration: const Duration(milliseconds: 500),
                                    width: double.infinity,
                                    child: Card(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.20,
                                            color: Colors.blue,
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    start_timing[i],
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
                                                    end_timing[i],
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  schedule[i] == null
                                                      ? "Free"
                                                      : schedule[i]!.courseCode,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                SizedBox(
                                                  height: 7.50,
                                                ),
                                                Text(
                                                  schedule[i] == null
                                                      ? " "
                                                      : schedule[i]!.courseName,
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                                SizedBox(
                                                  height: 7.50,
                                                ),
                                                Row(
                                                  children: [
                                                    schedule[i] != null
                                                        ? Container(
                                                            width: 5,
                                                            height: 5,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: slot_color[
                                                                  schedule[i]!
                                                                      .slot],
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                          )
                                                        : Container(),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      schedule[i] == null
                                                          ? " "
                                                          : "${schedule[i]!.slot} SLOT",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15,
                                                          color: schedule[i] ==
                                                                  null
                                                              ? Colors.black
                                                              : slot_color[
                                                                  schedule[i]!
                                                                      .slot]),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                            ],
                          );
                        }
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return CircularProgressIndicator();
                        else {
                          print("no connection");
                          return Container();
                        }
                      }),
                ))));
  }
}
