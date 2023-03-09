// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import '../../models/course.dart';
// import 'package:client/widgets/button/icon_button.dart';
// import 'package:client/widgets/headers/main.dart';
// import 'package:flutter/material.dart';
// import '../../graphQL/courses.dart';
// import '../../models/course.dart';
// import '../../database/academic.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';
// import '../../../themes.dart';
// import 'new_timetable.dart';
// import '../../utils/time_table.dart';
// import '../../services/notification.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class UpdateCourse extends StatefulWidget {
//   final CourseModel course;
//   final CoursesModel? courses;
//   const UpdateCourse({
//     Key? key,
//     required this.course,
//     this.courses,
//   }) : super(key: key);

//   @override
//   State<UpdateCourse> createState() => _UpdateCourseState();
// }

// class _UpdateCourseState extends State<UpdateCourse> {
//   //State data members

//   late CourseModel course;
//   String chosenSlotName = "A";
//   List<String> daysForChosenSlot = [];
//   List<String> days = [];
//   String slotsInfo = "";
//   List<String> daysDefault = [];
//   final LocalNotificationService service = LocalNotificationService();
//   List<String> slotOptions = [
//     'A',
//     'A1',
//     'A2',
//     'B',
//     'B1',
//     'B2',
//     'C',
//     'C1',
//     'C2',
//     'D',
//     'D1',
//     'D2',
//     'E',
//     'E1',
//     'E2',
//     'F',
//     'F1',
//     'F2',
//     'G',
//     'H',
//     'H1',
//     'H2',
//     'H3',
//     'J',
//     'J1',
//     'J2',
//     'J3',
//     'K',
//     'K1',
//     'K2',
//     'L',
//     'L1',
//     'L2',
//     'M',
//     'M1',
//     'M2',
//     'P',
//     'Q',
//     'R',
//     'R1',
//     'S1',
//     'S',
//     'T'
//   ];
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       setState(() {
//         course = widget.course;
//         slotsInfo = widget.course.slots;
//       });
//     });
//   }

//   //Helper Functions
//   Future<void> scheduleNotificationsForCourse(CourseModel course) async {
//     Map<String, String> fullDay = {
//       "m": "monday",
//       "t": "tuesday",
//       "w": "wednesday",
//       "th": "thursday",
//       "f": "friday",
//     };
//     for (var slot in course.slots.split('&')) {
//       String slotName = slot.split(',')[0];
//       List<String> daysList = slot.split(',')[1].split('*');
//       daysList.removeAt(daysList.length - 1);
//       for (var day in daysList) {
//         List<int> indices = time_table[fullDay[day]]![slotName]!;
//         for (int index in indices) {
//           String start = start_timing[index];
//           int hours = int.parse(start.substring(0, 2));
//           int minutes = int.parse(start.substring(3, 5));
//           if (start.substring(5) == 'PM') {
//             hours = hours + 12;
//           }
//           if (minutes == 0) {
//             minutes = 55;
//             hours = hours - 1;
//           } else {
//             minutes = minutes - 5;
//           }

//           await service.scheduleWeeklyNotification(
//               title: course.courseCode,
//               description: course.courseName,
//               day: fullDay[day],
//               hours: hours,
//               minutes: minutes);
//           final FlutterLocalNotificationsPlugin plugin =
//               FlutterLocalNotificationsPlugin();
//           final List<PendingNotificationRequest> pending =
//               await plugin.pendingNotificationRequests();
//         }
//       }
//     }
//   }

//   Future<bool> checkForSlotClash(String slotsInfo, CoursesModel courses) async {
//     for (var slot in slotsInfo.split('&')) {
//       String slotName = slot.split(',')[0];
//       for (var c in courses.courses) {
//         if (course.courseCode == c.courseCode) continue;
//         if (c.slots.contains(slotName + ',')) return false;
//         print('**');
//       }
//     }
//     return true;
//   }

//   String getTruncatedDay(String day) {
//     if (day.toLowerCase() == 'thursday') {
//       return "th";
//     } else {
//       return day[0];
//     }
//   }

//   List<String> getDays(String slot) {
//     List<String> days = [];
//     time_table.forEach((key, value) {
//       if (value[slot] != null) {
//         days.add(key);
//       }
//     });
//     return days;
//   }

//   String getDefaultDays(List<String> slots) {
//     String slotInfo = "";

//     for (var slot in slots) {
//       {
//         slotInfo = slotInfo + slot + ',';
//         time_table.forEach((key, value) {
//           if (value[slot] != null) {
//             if (key == "thursday") {
//               slotInfo += "th*";
//             } else {
//               slotInfo += key[0] + '*';
//             }
//           }
//         });
//         slotInfo = slotInfo + '&';
//       }
//     }
//     return slotInfo.substring(0, slotInfo.length - 1);
//   }

//   bool mon = true;
//   bool tue = true;
//   bool wed = true;
//   bool thurs = true;
//   bool fri = true;
//   Map<String, bool> mp = {
//     'monday': true,
//     'tuesday': true,
//     'wednesday': true,
//     'thursday': true,
//     'friday': true,
//   };

//   Future<bool> updateCourse(CourseModel course, CoursesModel? courses) async {
//     print("Edited slots ${course.slots}");
//     if (await checkForSlotClash(slotsInfo, courses!)) {
//       await AcademicDatabase.instance.updateCourse(course);
//       return true;
//     } else {
//       return false;
//     }
//   }

//   void showDialogForCourse(String? slot) {
//     showDialog(
//         context: context,
//         builder: (context) {
//           if (slot != null) chosenSlotName = slot.split(',')[0];
//           daysForChosenSlot = getDays(chosenSlotName);
//           daysDefault = getDays(chosenSlotName);
//           String title = slot == null ? "Add slot" : "Edit Slot";
//           return StatefulBuilder(builder: (context, setState) {
//             print(daysForChosenSlot);
//             return AlertDialog(
//               title: Text(title),
//               content: Column(
//                 children: [
//                   DropdownButton<String>(
//                       value: chosenSlotName,
//                       items: slotOptions
//                           .map<DropdownMenuItem<String>>((String value) {
//                         return DropdownMenuItem(
//                             value: value,
//                             child: Text(
//                               value,
//                               style: TextStyle(fontSize: 14),
//                             ));
//                       }).toList(),
//                       onChanged: (String? value) {
//                         setState(() {
//                           chosenSlotName = value!;
//                           daysDefault = getDays(chosenSlotName);
//                           daysForChosenSlot = getDays(chosenSlotName);
//                         });
//                       }),
//                   for (var day in daysDefault)
//                     Row(
//                       children: [
//                         Text(day),
//                         Checkbox(
//                             value: mp[day]!,
//                             onChanged: (bool? value) {
//                               setState(() {
//                                 mp[day] = value!;
//                                 if (value) {
//                                   daysForChosenSlot.add(day);
//                                 } else {
//                                   daysForChosenSlot.remove(day);
//                                 }
//                               });
//                             })
//                       ],
//                     ),
//                 ],
//               ),
//               actions: [
//                 ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         if (slot == null) {
//                           slotsInfo += '&' + chosenSlotName + ',';
//                           for (var day in daysForChosenSlot) {
//                             slotsInfo = slotsInfo + getTruncatedDay(day) + '*';
//                           }
//                         } else {
//                           List<String> slotList = slotsInfo.split('&');
//                           //print(slot);
//                           for (var i = 0; i < slotList.length; i++) {
//                             if (slotList[i] == slot) {
//                               print('edit slot');
//                               slotList[i] = chosenSlotName + ',';
//                               for (var day in daysForChosenSlot) {
//                                 slotList[i] =
//                                     slotList[i] + getTruncatedDay(day) + '*';
//                               }
//                               //print(" New slot $i");
//                               break;
//                             }
//                           }
//                           slotsInfo = slotList.join('&');
//                         }
//                         print("New Slots $slotsInfo");
//                         CourseModel copy = CourseModel(
//                             id: course.id,
//                             slots: slotsInfo,
//                             courseCode: course.courseCode,
//                             courseName: course.courseName);
//                         course = copy;
//                       });
//                       //print(slotsInfo);
//                       Navigator.of(context).pop();
//                     },
//                     child: Text("Add"))
//               ],
//             );
//           });
//         }).then((_) => setState(() {}));
//   }

//   @override
//   Widget build(BuildContext context) {
//     mp = {
//       'monday': true,
//       'tuesday': true,
//       'wednesday': true,
//       'thursday': true,
//       'friday': true,
//     };
//     //CourseModel course = widget.course;
//     CoursesModel? courses = widget.courses;
//     List<String> daysDefault = getDays(chosenSlotName);
//     final ScrollController _scrollController = ScrollController();
//     return StatefulBuilder(builder: (context, setState) {
//       return Scaffold(
//         body: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 15),
//             child: NestedScrollView(
//               physics: const AlwaysScrollableScrollPhysics(),
//               controller: _scrollController,
//               headerSliverBuilder: (context, innerBoxIsScrolled) {
//                 return [
//                   SliverList(
//                     delegate: SliverChildBuilderDelegate(
//                         (BuildContext context, int index) {
//                       return CustomAppBar(
//                         title: "Edit Course",
//                         leading: CustomIconButton(
//                             icon: Icons.arrow_back,
//                             onPressed: () => Navigator.of(context).pop()),
//                       );
//                     }, childCount: 1),
//                   ),
//                 ];
//               },
//               body: Column(
//                 children: [
//                   Card(
//                     child: Padding(
//                       padding: const EdgeInsets.all(15.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "${course.courseCode}",
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                             ),
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           Text(
//                             "${course.courseName}",
//                             style: TextStyle(fontSize: 15),
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           for (var slot in course.slots.split('&'))
//                             Card(
//                               child: Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 5),
//                                 child: Row(children: [
//                                   Text("${slot.split(',')[0]} SLOT"),
//                                   SizedBox(width: 10),
//                                   for (var day in ['M', 'T', 'W', 'Th', 'F'])
//                                     Padding(
//                                       padding: const EdgeInsets.all(1.0),
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(5),
//                                             color: slot
//                                                     .split(',')[1]
//                                                     .contains(day.toLowerCase())
//                                                 ? Colors.blue
//                                                 : Colors.white),
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(5.0),
//                                           child: Text(
//                                             day,
//                                             style: TextStyle(
//                                                 color: slot
//                                                         .split(',')[1]
//                                                         .contains(
//                                                             day.toLowerCase())
//                                                     ? Colors.white
//                                                     : Colors.black),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   new Spacer(),
//                                   IconButton(
//                                       onPressed: () {
//                                         //print(slot);
//                                         showDialogForCourse(slot);
//                                       },
//                                       icon: Icon(Icons.edit)),
//                                   IconButton(
//                                       onPressed: () {
//                                         List<String> slotsList =
//                                             slotsInfo.split('&');
//                                         slotsList.remove(slot);
//                                         //print(slotsList);
//                                         setState(() {
//                                           slotsInfo = slotsList.join('&');
//                                         });
//                                       },
//                                       icon: Icon(Icons.delete)),
//                                 ]),
//                               ),
//                             )
//                           /*Text(
//                                     "Slots : ${course.slots[0]}",
//                                     style: TextStyle(fontSize: 16),
//                                   )*/
//                           ,
//                           SizedBox(
//                             height: 10,
//                           ),
//                           IconButton(
//                               icon: Icon(Icons.add),
//                               onPressed: () {
//                                 showDialogForCourse(null);
//                               }),
//                           Row(
//                             children: [
//                               ElevatedButton(
//                                   onPressed: () async {
//                                     print(course.slots);
//                                     bool f =
//                                         await updateCourse(course, courses);
//                                     if (f == true) {
//                                       final FlutterLocalNotificationsPlugin
//                                           plugin =
//                                           FlutterLocalNotificationsPlugin();
//                                       final List<PendingNotificationRequest>
//                                           pending = await plugin
//                                               .pendingNotificationRequests();
//                                       for (var notif in pending) {
//                                         if (notif.title == course.courseCode) {
//                                           plugin.cancel(notif.id);
//                                           print("Cancelled notifications");
//                                         }
//                                       }
//                                       scheduleNotificationsForCourse(course);
//                                       Navigator.of(context).pushReplacement(
//                                           MaterialPageRoute(
//                                               builder: (BuildContext context) =>
//                                                   NewTimetable()));
//                                     } else {
//                                       showDialog(
//                                           context: context,
//                                           builder: (_) {
//                                             return AlertDialog(
//                                               title: Text("Slot clash"),
//                                               content: Text(
//                                                   "Looks like the course you added has a slot clash!"),
//                                               actions: [
//                                                 TextButton(
//                                                   child: Text("Ok"),
//                                                   onPressed: () {
//                                                     Navigator.of(context).pop();
//                                                   },
//                                                 )
//                                               ],
//                                             );
//                                           });
//                                     }
//                                   },
//                                   child: Text("Add")),
//                               SizedBox(
//                                 width: 15,
//                               ),
//                               ElevatedButton(
//                                   onPressed: () {
//                                     Navigator.of(context).pop();
//                                   },
//                                   child: Text("Cancel"))
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );
//     });
//   }
// }
