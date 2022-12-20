import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../../models/course.dart';
import 'package:client/widgets/button/icon_button.dart';
import 'package:client/widgets/headers/main.dart';
import 'package:flutter/material.dart';
import '../../models/course.dart';
import '../../database/academic.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../themes.dart';
import 'new_timetable.dart';
import '../../utils/time_table.dart';

class AddCourse extends StatefulWidget {
  final CourseModel course;
  final CoursesModel? courses;
  const AddCourse({
    Key? key,
    required this.course,
    this.courses,
  }) : super(key: key);

  @override
  State<AddCourse> createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  String? alternate1 = 'None';
  String? alternate2 = 'None';
  String? alternate3 = 'None';
  List<String> slots = [
    'None',
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'H1',
    'H2',
    'H3',
    'J',
    'J1',
    'J2',
    'J3',
    'K',
    'K1',
    'K2',
    'L',
    'L1',
    'L2',
    'M',
    'M1',
    'M2',
    'P',
    'Q',
    'R',
    'R1',
    'S1',
    'S',
    'T'
  ];

  bool mon = true;
  bool tue = true;
  bool wed = true;
  bool thurs = true;
  bool fri = true;
  Map<String, bool> mp = {
    'monday': true,
    'tuesday': true,
    'wednesday': true,
    'thursday': true,
    'friday': true,
  };
  List<String> days = [];
  void getDays(CourseModel course) {
    days = [];
    List<String> daysUtil = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday'
    ];
    bool f = false;
    for (String day in daysUtil) {
      f = false;
      //print(time_table['monday']);
      for (var slots in time_table[day]!) {
        //print(time_table[day]);
        for (var slot in slots) {
          if (course.slot == slot) {
            f = true;
            days.add(day);
            break;
          }
        }
        if (f) break;
      }
    }
    print(days);
  }

  Future<bool> saveCourse(CourseModel course, CoursesModel? courses) async {
    String? alt1, alt2, alt3;
    mon = mp['monday']!;
    tue = mp['tuesday']!;
    wed = mp['wednesday']!;
    thurs = mp['thursday']!;
    fri = mp['friday']!;
    alternate1 = alternate1 == 'None' ? null : alternate1;
    alternate2 = alternate2 == 'None' ? null : alternate2;
    alternate3 = alternate3 == 'None' ? null : alternate3;
    CourseModel savedCourse = CourseModel(
      courseCode: course.courseCode,
      courseName: course.courseName,
      slot: course.slot,
      alternateSlot1: alternate1,
      alternateSlot2: alternate2,
      alternateSlot3: alternate3,
      monday: mon,
      tuesday: tue,
      wednesday: wed,
      thursday: thurs,
      friday: fri,
    );
    if (courses != null) {
      for (var c in courses.courses) {
        if (c.slot == course.slot ||
            c.slot == course.alternateSlot1 ||
            c.slot == course.alternateSlot2 ||
            c.slot == course.alternateSlot3 ||
            c.alternateSlot1 == course.slot ||
            c.slot == course.alternateSlot1 ||
            c.slot == course.alternateSlot2 ||
            c.slot == course.alternateSlot3 ||
            c.alternateSlot3 == course.slot ||
            c.slot == course.alternateSlot1 ||
            c.slot == course.alternateSlot2 ||
            c.slot == course.alternateSlot3) {
          return false;
        }
      }
    }
    await AcademicDatabase.instance.addCourse(savedCourse);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    CourseModel course = widget.course;
    slots.remove(course.slot);
    alternate1 = course.alternateSlot1 ?? 'None';
    alternate2 = course.alternateSlot2 ?? 'None';
    //alternate2 = 'F';
    alternate3 = course.alternateSlot3 ?? 'None';
    getDays(course);
    CoursesModel? courses = widget.courses;
    //print("Alternate slot 1${course.alternateSlot1}");
    final ScrollController _scrollController = ScrollController();
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
                      title: "Add course",
                      leading: CustomIconButton(
                          icon: Icons.arrow_back,
                          onPressed: () => Navigator.of(context).pop()),
                    );
                  }, childCount: 1),
                ),
              ];
            },
            body: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Text(
                          "Course Code : ${course.courseCode}",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Course Name : ${course.courseName}",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Slots : ${course.slot}",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        const Text("Choose Additional slots(if any)"),
                        Row(
                          children: [
                            DropdownButton<String>(
                                value: alternate1,
                                items: slots.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(fontSize: 14),
                                      ));
                                }).toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    alternate1 = value;
                                  });
                                }),
                            DropdownButton<String>(
                                value: alternate2,
                                items: slots.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem(
                                      value: value,
                                      child: Text(value,
                                          style: TextStyle(fontSize: 14)));
                                }).toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    alternate2 = value;
                                  });
                                }),
                            DropdownButton<String>(
                                value: alternate3,
                                items: slots.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem(
                                      value: value,
                                      child: Text(value,
                                          style: TextStyle(fontSize: 14)));
                                }).toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    alternate3 = value;
                                  });
                                }),
                          ],
                        ),
                        /*course.alternateSlot1 != null &&
                                course.alternateSlot1!.isNotEmpty
                            ? Row(
                                children: [
                                  Text(course.alternateSlot1!),
                                  Checkbox(
                                      value: alternate1,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          alternate1 = value!;
                                        });
                                      }),
                                ],
                              )
                            : Container(),
                        course.alternateSlot2 != null &&
                                course.alternateSlot2!.isNotEmpty
                            ? Row(
                                children: [
                                  Text(course.alternateSlot2!),
                                  Checkbox(
                                      value: alternate2,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          alternate2 = value!;
                                        });
                                      }),
                                ],
                              )
                            : Container(),
                        course.alternateSlot3 != null &&
                                course.alternateSlot3!.isNotEmpty
                            ? Row(
                                children: [
                                  Text(course.alternateSlot3!),
                                  Checkbox(
                                      value: alternate3,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          alternate3 = value!;
                                        });
                                      }),
                                ],
                              )
                            : Container(),*/
                        for (String day in days)
                          Row(
                            children: [
                              Text(day),
                              Checkbox(
                                  value: mp[day]!,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      mp[day] = value!;
                                    });
                                  })
                            ],
                          ),
                        Row(
                          children: [
                            ElevatedButton(
                                onPressed: () async {
                                  bool f = await saveCourse(course, courses);
                                  if (f == true) {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                NewTimetable()));
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (_) {
                                          return AlertDialog(
                                            title: Text("Slot clash"),
                                            content: Text(
                                                "Looks like the course you added has a slot clash!"),
                                            actions: [
                                              TextButton(
                                                child: Text("Ok"),
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              NewTimetable()));
                                                },
                                              )
                                            ],
                                          );
                                        });
                                  }
                                },
                                child: Text("Add")),
                            SizedBox(
                              width: 15,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              NewTimetable()));
                                },
                                child: Text("Cancel"))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
