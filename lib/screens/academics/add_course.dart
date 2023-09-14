import 'package:client/widgets/helpers/loading.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../../models/course.dart';
import 'package:client/widgets/button/icon_button.dart';
import 'package:client/widgets/headers/main.dart';
import 'package:flutter/material.dart';
import '../../graphQL/courses.dart';
import '../../models/course.dart';
import '../../database/academic.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../themes.dart';
import 'new_timetable.dart';
import '../../utils/time_table.dart';
import '../../services/notification.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AddCourse extends StatefulWidget {
  final String courseCode;
  final CoursesModel? courses;
  const AddCourse({
    Key? key,
    required this.courseCode,
    this.courses,
  }) : super(key: key);

  @override
  State<AddCourse> createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  //State data members
  late CourseModel course;
  String chosenSlotName = "A";
  List<String> daysForChosenSlot = [];
  List<String> days = [];
  String slotsInfo = "";
  List<String> daysDefault = [];
  bool scheduleNotifications = true;
  final LocalNotificationService service = LocalNotificationService();
  List<String> slotOptions = [
    'A',
    'A1',
    'A2',
    'B',
    'B1',
    'B2',
    'C',
    'C1',
    'C2',
    'D',
    'D1',
    'D2',
    'E',
    'E1',
    'E2',
    'F',
    'F1',
    'F2',
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

  //Helper Functions
  Future<void> scheduleNotificationsForCourse(CourseModel course) async {
    Map<String, String> fullDay = {
      "m": "monday",
      "t": "tuesday",
      "w": "wednesday",
      "th": "thursday",
      "f": "friday",
    };
    for (var slot in course.slots.split('&')) {
      String slotName = slot.split(',')[0];
      List<String> daysList = slot.split(',')[1].split('*');
      daysList.removeAt(daysList.length - 1);
      for (var day in daysList) {
        List<int> indices = time_table[fullDay[day]]![slotName]!;
        for (int index in indices) {
          String start = start_timing[index];
          print(start);
          int hours = int.parse(start.substring(0, 2));
          int minutes = int.parse(start.substring(3, 5));
          if (start.substring(6) == 'PM') {
            hours = hours + 12;
          }
          print(hours);
          if (minutes == 0) {
            minutes = 55;
            hours = hours - 1;
          } else {
            minutes = minutes - 5;
          }

          await service.scheduleWeeklyNotification(
              title: course.courseCode,
              description: course.courseName,
              day: fullDay[day],
              hours: hours,
              minutes: minutes);
          final FlutterLocalNotificationsPlugin plugin =
              FlutterLocalNotificationsPlugin();
          final List<PendingNotificationRequest> pending =
              await plugin.pendingNotificationRequests();
        }
      }
    }
  }

  Future<bool> checkForSlotClash(String slotsInfo) async {
    CoursesModel courses = await AcademicDatabase.instance.getAllCourses();
    for (var slot in slotsInfo.split('&')) {
      String slotName = slot.split(',')[0];
      for (var course in courses.courses) {
        if (course.slots.contains(slotName + ',')) return false;
      }
    }
    return true;
  }

  String getTruncatedDay(String day) {
    if (day.toLowerCase() == 'thursday') {
      return "th";
    } else {
      return day[0];
    }
  }

  List<String> getDays(String slot) {
    List<String> days = [];
    time_table.forEach((key, value) {
      if (value[slot] != null) {
        days.add(key);
      }
    });
    return days;
  }

  String getDefaultDays(List<String> slots) {
    String slotInfo = "";

    for (var slot in slots) {
      {
        slotInfo = slotInfo + slot + ',';
        time_table.forEach((key, value) {
          if (value[slot] != null) {
            if (key == "thursday") {
              slotInfo += "th*";
            } else {
              slotInfo += key[0] + '*';
            }
          }
        });
        slotInfo = slotInfo + '&';
      }
    }
    return slotInfo.substring(0, slotInfo.length - 1);
  }

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

  Future<bool> saveCourse(CourseModel course, CoursesModel? courses) async {
    if (await checkForSlotClash(slotsInfo)) {
      await AcademicDatabase.instance.addCourse(course);
      return true;
    } else {
      return false;
    }
  }

  void showDialogForCourse(String? slot) {
    showDialog(
        context: context,
        builder: (context) {
          if (slot != null) chosenSlotName = slot.split(',')[0];
          daysForChosenSlot = getDays(chosenSlotName);
          daysDefault = getDays(chosenSlotName);
          String title = slot == null ? "Add slot" : "Edit Slot";
          return StatefulBuilder(builder: (context, setState) {
            print(daysForChosenSlot);
            return AlertDialog(
              title: Text(title),
              content: Column(
                children: [
                  DropdownButton<String>(
                      value: chosenSlotName,
                      items: slotOptions
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(fontSize: 14),
                            ));
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          chosenSlotName = value!;
                          daysDefault = getDays(chosenSlotName);
                          daysForChosenSlot = getDays(chosenSlotName);
                        });
                      }),
                  for (var day in daysDefault)
                    Row(
                      children: [
                        Text(day),
                        Checkbox(
                            value: mp[day]!,
                            onChanged: (bool? value) {
                              setState(() {
                                mp[day] = value!;
                                if (value) {
                                  daysForChosenSlot.add(day);
                                } else {
                                  daysForChosenSlot.remove(day);
                                }
                              });
                            })
                      ],
                    ),
                ],
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (slot == null) {
                          slotsInfo += '&' + chosenSlotName + ',';
                          for (var day in daysForChosenSlot) {
                            slotsInfo = slotsInfo + getTruncatedDay(day) + '*';
                          }
                        } else {
                          List<String> slotList = slotsInfo.split('&');
                          //print(slot);
                          for (var i = 0; i < slotList.length; i++) {
                            if (slotList[i] == slot) {
                              print('edit slot');
                              slotList[i] = chosenSlotName + ',';
                              for (var day in daysForChosenSlot) {
                                slotList[i] =
                                    slotList[i] + getTruncatedDay(day) + '*';
                              }
                              //print(" New slot $i");
                              break;
                            }
                          }
                          slotsInfo = slotList.join('&');
                        }
                        print("New Slots $slotsInfo");
                        CourseModel copy = CourseModel(
                            slots: slotsInfo,
                            courseCode: course.courseCode,
                            courseName: course.courseName);
                        course = copy;
                      });
                      //print(slotsInfo);
                      Navigator.of(context).pop();
                    },
                    child: Text("Add"))
              ],
            );
          });
        }).then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    mp = {
      'monday': true,
      'tuesday': true,
      'wednesday': true,
      'thursday': true,
      'friday': true,
    };
    Map<String, String> variables = {"getCourseFilter2": widget.courseCode};
    //CourseModel course = widget.course;
    CoursesModel? courses = widget.courses;

    List<String> daysDefault = getDays(chosenSlotName);
    final ScrollController _scrollController = ScrollController();
    return StatefulBuilder(builder: (context, setState) {
      return Query(
          options: QueryOptions(
              document: gql(CoursesGQL().getCourse), variables: variables),
          builder: (QueryResult result, {fetchMore, refetch}) {
            List<String> slots = [];
            if (result.data == null) {
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
                                    onPressed: () =>
                                        Navigator.of(context).pop()),
                              );
                            }, childCount: 1),
                          ),
                        ];
                      },
                      body: const Loading(),
                    ),
                  ),
                ),
              );
            }
            for (var slot in result.data!["getCourse"]["slots"]) {
              slots.add(slot.toString());
            }
            for (var slot in result.data!["getCourse"]["additionalSlots"]) {
              if (slot.isNotEmpty) slots.add(slot.toString());
            }
            // print(slots);

            if (slotsInfo == "") slotsInfo = getDefaultDays(slots);
            print(slotsInfo);
            course = CourseModel(
                courseCode: result.data!["getCourse"]["courseCode"],
                courseName: result.data!["getCourse"]["courseName"],
                slots: slotsInfo);
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${course.courseCode}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "${course.courseName}",
                                  style: TextStyle(fontSize: 15),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                for (var slot in course.slots.split('&'))
                                  Card(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Row(children: [
                                        Text("${slot.split(',')[0]} SLOT"),
                                        SizedBox(width: 10),
                                        for (var day in [
                                          'M',
                                          'T',
                                          'W',
                                          'Th',
                                          'F'
                                        ])
                                          Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: slot
                                                          .split(',')[1]
                                                          .contains(
                                                              day.toLowerCase() +
                                                                  '*')
                                                      ? Colors.blue
                                                      : Colors.white),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  day,
                                                  style: TextStyle(
                                                      color: slot
                                                              .split(',')[1]
                                                              .contains(
                                                                  day.toLowerCase() +
                                                                      '*')
                                                          ? Colors.white
                                                          : Colors.black),
                                                ),
                                              ),
                                            ),
                                          ),
                                        new Spacer(),
                                        IconButton(
                                            onPressed: () {
                                              //print(slot);
                                              showDialogForCourse(slot);
                                            },
                                            icon: Icon(Icons.edit)),
                                        IconButton(
                                            onPressed: () {
                                              List<String> slotsList =
                                                  slotsInfo.split('&');
                                              slotsList.remove(slot);
                                              //print(slotsList);
                                              setState(() {
                                                slotsInfo = slotsList.join('&');
                                              });
                                            },
                                            icon: Icon(Icons.delete)),
                                      ]),
                                    ),
                                  )
                                /*Text(
                                    "Slots : ${course.slots[0]}",
                                    style: TextStyle(fontSize: 16),
                                  )*/
                                ,
                                SizedBox(
                                  height: 10,
                                ),
                                IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () {
                                      showDialogForCourse(null);
                                    }),

                                /*const Text("Choose Additional slots(if any)"),
                                  Row(
                                    children: [
                                      DropdownButton<String>(
                                          value: alternate1,
                                          items: slots
                                              .map<DropdownMenuItem<String>>(
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
                                          items: slots
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem(
                                                value: value,
                                                child: Text(value,
                                                    style:
                                                        TextStyle(fontSize: 14)));
                                          }).toList(),
                                          onChanged: (String? value) {
                                            setState(() {
                                              alternate2 = value;
                                            });
                                          }),
                                      DropdownButton<String>(
                                          value: alternate3,
                                          items: slots
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem(
                                                value: value,
                                                child: Text(value,
                                                    style:
                                                        TextStyle(fontSize: 14)));
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
                                    ),*/
                                Row(
                                  children: [
                                    ElevatedButton(
                                        onPressed: () async {
                                          bool f =
                                              await saveCourse(course, courses);
                                          if (f == true) {
                                            if (scheduleNotifications) {
                                              await scheduleNotificationsForCourse(
                                                  course);
                                            }
                                            Navigator.of(context)
                                                .pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
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
                                                          Navigator.of(context)
                                                              .pop();
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
                                          int count = 2;
                                          Navigator.of(context).popUntil(
                                              (_) => count++ >= 2);
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
          });
    });
  }
}
