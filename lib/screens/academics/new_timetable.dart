// import 'package:client/graphQL/courses.dart';
// import 'package:client/screens/academics/search_course.dart';
// import 'package:client/screens/academics/update_course.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:client/graphQL/user.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:client/widgets/button/icon_button.dart';
// import 'package:client/widgets/headers/main.dart';
// import 'package:flutter/material.dart';
// import '../../models/course.dart';
// import '../../database/academic.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';
// import '../../../themes.dart';
// import '../../utils/time_table.dart';
// import 'dart:async';
// import 'add_course.dart';
// import '../../services/notification.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class Debouncer {
//   int? seconds;
//   int? milliseconds;
//   VoidCallback? action;
//   Timer? timer;

//   run(VoidCallback action) {
//     if (null != timer) {
//       timer!.cancel();
//     }
//     timer = Timer(
//       Duration(milliseconds: milliseconds ?? 100),
//       action,
//     );
//   }
// }

// class NewTimetable extends StatefulWidget {
//   const NewTimetable({Key? key}) : super(key: key);

//   @override
//   State<NewTimetable> createState() => _NewTimetableState();
// }

// class _NewTimetableState extends State<NewTimetable> {
//   var courseCode;
//   var courseName;
//   var slot;
//   final _debouncer = Debouncer();
//   Map<String, dynamic> defaultVariables = {"filter": "AM5"};
//   final focusNode = FocusNode();
//   final LocalNotificationService notificationService =
//       LocalNotificationService();
//   CoursesModel? _courses;
//   TextEditingController courseQueryController = TextEditingController();
//   void getCourses() async {
//     _courses = await AcademicDatabase.instance.getAllCourses();
//   }

//   Iterable<String> getCourseNameWithCode(QueryResult result) {
//     List<String> courseNameWithCode = [];
//     for (var course in result.data!["searchCourses"]) {
//       courseNameWithCode
//           .add("${course["courseCode"]} - ${course["courseName"]}");
//     }
//     return courseNameWithCode.cast<String>();
//   }

//   /*void addCourseWithCode(String code, QueryResult result) async {
//     for (var course in result.data!["searchCourses"]) {
//       if (code == course["courseCode"]) {
//         String? alt1, alt2, alt3;
//         alt1 = course["additionalSlots"].length >= 1
//             ? course["additionalSlots"][0]
//             : null;
//         alt2 = course["additionalSlots"].length >= 2
//             ? course["additionalSlots"][1]
//             : null;
//         alt3 = course["additionalSlots"].length >= 3
//             ? course["additionalSlots"][2]
//             : null;
//         CourseModel selectedCourse = CourseModel(
//             slot: course["slots"][0],
//             courseCode: code,
//             courseName: course["courseName"],
//             alternateSlot1: alt1,
//             alternateSlot2: alt2,
//             alternateSlot3: alt3);
//         await AcademicDatabase.instance.addCourse(selectedCourse);
//         CoursesModel courses = await AcademicDatabase.instance.getAllCourses();
//         setState(() {
//           _courses = courses;
//         });
//       }
//     }
//   }*/

//   @override
//   void initState() {
//     //print("dialog opened");
//     getCourses();
//     super.initState();
//   }

//   void deleteCourse(CourseModel course) async {
//     print("course deleted");
//     int id = await AcademicDatabase.instance.deleteCourse(course.id!);
//   }

//   /*void showDialogWithFields() {
//     showDialog(
//       context: context,
//       builder: (_) {
//         print("dialog opened");
//         var courseCodeController = TextEditingController();
//         var courseNameController = TextEditingController();
//         var slotController = TextEditingController();
//         return AlertDialog(
//           title: Text('Add Course'),
//           content: SizedBox(
//             height: 150,
//             child: Column(
//               children: [
//                 TextFormField(
//                   controller: courseCodeController,
//                   decoration: InputDecoration(hintText: 'Course Code'),
//                 ),
//                 TextFormField(
//                   controller: courseNameController,
//                   decoration: InputDecoration(hintText: 'Course Name'),
//                 ),
//                 TextFormField(
//                   controller: slotController,
//                   decoration: InputDecoration(hintText: 'Course Slot'),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () async {
//                 // Send them to your email maybe?
//                 courseName = courseNameController.text;
//                 courseCode = courseCodeController.text;
//                 slot = slotController.text;
//                 CourseModel course = CourseModel(
//                   courseCode: courseCode,
//                   courseName: courseName,
//                   slot: slot,
//                 );
//                 await AcademicDatabase.instance.addCourse(course);
//                 CoursesModel courses =
//                     await AcademicDatabase.instance.getAllCourses();
//                 setState(() {
//                   _courses = courses;
//                 });

//                 Navigator.of(context).pop();
//               },
//               child: Text('Add'),
//             ),
//           ],
//         );
//       },
//     );
//   }*/

//   String getTruncatedName(String courseName) {
//     if (courseName.length > 20)
//       courseName = courseName.substring(0, 20) + "...";

//     return courseName;
//   }

//   @override
//   List<String> courseCodes = [];

//   Widget build(BuildContext context) {
//     final ScrollController _scrollController = ScrollController();
//     final TextEditingController _courseCodeController = TextEditingController();
//     return Scaffold(
//         body: SafeArea(
//             child: Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 15),
//       child: NestedScrollView(
//         physics: const AlwaysScrollableScrollPhysics(),
//         controller: _scrollController,
//         headerSliverBuilder: (context, innerBoxIsScrolled) {
//           return [
//             SliverList(
//               delegate:
//                   SliverChildBuilderDelegate((BuildContext context, int index) {
//                 return CustomAppBar(
//                   title: "Timetable",
//                   leading: CustomIconButton(
//                       icon: Icons.arrow_back,
//                       onPressed: () => Navigator.of(context).pop()),
//                 );
//               }, childCount: 1),
//             ),
//           ];
//         },
//         body: FutureBuilder<CoursesModel>(
//           future: AcademicDatabase.instance.getAllCourses(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               getCourses();
//               return (ListView(children: [
//                 SizedBox(
//                   height: 10,
//                 ),
//                 // Query(
//                 //   options: QueryOptions(
//                 //       document: gql(CoursesGQL().searchCourses),
//                 //       variables: defaultVariables),
//                 //   builder: (QueryResult result, {fetchMore, refetch}) {
//                 //     //print(defaultVariables["filter"]);
//                 //     //print(result.data);
//                 //     return LayoutBuilder(builder: (context, constraints) {
//                 //       return RawAutocomplete(
//                 //         optionsBuilder: (TextEditingValue _courseQuery) {
//                 //           if (_courseQuery.text == '' ||
//                 //               _courseQuery.text.length < 3) {
//                 //             return const Iterable<String>.empty();
//                 //           } else {
//                 //             List<String> matches = <String>[];
//                 //             if (result.data != null &&
//                 //                 result.data!["searchCourses"] != null) {
//                 //               matches.addAll(getCourseNameWithCode(result));
//                 //             }
//                 //             matches.retainWhere((s) {
//                 //               return s
//                 //                   .toLowerCase()
//                 //                   .contains(_courseQuery.text.toLowerCase());
//                 //             });
//                 //             return matches;
//                 //           }
//                 //         },
//                 //         fieldViewBuilder: (BuildContext context,
//                 //             TextEditingController _courseQuery,
//                 //             FocusNode focusNode,
//                 //             VoidCallback onFieldSubmitted) {
//                 //           return TextFormField(
//                 //             controller: _courseQuery,
//                 //             minLines: 1,
//                 //             maxLines: null,
//                 //             decoration: InputDecoration(
//                 //                 labelText: "Add course....",
//                 //                 suffixIcon: IconButton(
//                 //                   icon: const Icon(Icons.clear),
//                 //                   onPressed: () {
//                 //                     _courseQuery.clear();
//                 //                   },
//                 //                 )),
//                 //             focusNode: focusNode,
//                 //             validator: (value) {
//                 //               if (value == null || value.isEmpty) {
//                 //                 return "Enter the location of the post";
//                 //               }
//                 //               return null;
//                 //             },
//                 //             onChanged: (String courseQuery) {
//                 //               _debouncer.run(() {
//                 //                 setState(() {
//                 //                   defaultVariables["filter"] =
//                 //                       courseQuery.length > 2
//                 //                           ? courseQuery
//                 //                           : "AM5";
//                 //                 });
//                 //                 refetch!();
//                 //               });
//                 //             },
//                 //           );
//                 //         },
//                 //         optionsViewBuilder: (BuildContext context,
//                 //             void Function(String) onSelected,
//                 //             Iterable<String> options) {
//                 //           return Expanded(
//                 //             child: Align(
//                 //               alignment: Alignment.topLeft,
//                 //               child: Material(
//                 //                   color: ColorPalette.palette(context)
//                 //                       .secondary[50],
//                 //                   child: SizedBox(
//                 //                     width: constraints.biggest.width,
//                 //                     child: ListView.builder(
//                 //                       itemCount: options.length,
//                 //                       itemBuilder: (context, index) {
//                 //                         final opt = options.elementAt(index);

//                 //                         return GestureDetector(
//                 //                             onTap: () {
//                 //                               onSelected(opt);
//                 //                             },
//                 //                             child: Card(
//                 //                               child: Padding(
//                 //                                 padding:
//                 //                                     const EdgeInsets.all(10.0),
//                 //                                 child: Text(opt),
//                 //                               ),
//                 //                             ));
//                 //                       },
//                 //                     ),
//                 //                   )),
//                 //             ),
//                 //           );
//                 //         },
//                 //         onSelected: (String option) async {
//                 //           String code = option.substring(0, 6);

//                 //           Navigator.of(context)
//                 //               .pushReplacement(MaterialPageRoute(
//                 //                   builder: (BuildContext context) => AddCourse(
//                 //                         courseCode: code,
//                 //                         courses: _courses,
//                 //                       )));
//                 //           CoursesModel courses =
//                 //               await AcademicDatabase.instance.getAllCourses();
//                 //           setState(() {
//                 //             _courses = courses;
//                 //           });
//                 //         },
//                 //         textEditingController: courseQueryController,
//                 //         focusNode: focusNode,
//                 //       );
//                 //     });
//                 //   },
//                 // ),
//                 if (_courses != null)
//                   for (var course in _courses!.courses)
//                     Card(
//                       child: Padding(
//                         padding: const EdgeInsets.all(15.0),
//                         child: Container(
//                             width: double.infinity,
//                             child: Row(
//                               children: [
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       course.courseCode,
//                                       style: TextStyle(fontSize: 22),
//                                     ),
//                                     SizedBox(
//                                       height: 10,
//                                     ),
//                                     Text(
//                                       getTruncatedName(course.courseName),
//                                       style: TextStyle(fontSize: 18),
//                                     ),
//                                     SizedBox(
//                                       height: 10,
//                                     ),
//                                     Container(
//                                       decoration: BoxDecoration(
//                                           color: slot_color[course.slots
//                                               .split('&')[0]
//                                               .split(',')[0]],
//                                           borderRadius:
//                                               BorderRadius.circular(5)),
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(5.0),
//                                         child: Text(
//                                           "${course.slots.split('&')[0].split(',')[0]} SLOT",
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 14),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 new Spacer(),
//                                 IconButton(
//                                     onPressed: () {
//                                       Navigator.of(context).push(
//                                           MaterialPageRoute(
//                                               builder: (context) =>
//                                                   UpdateCourse(
//                                                     course: course,
//                                                     courses: _courses,
//                                                   )));
//                                     },
//                                     icon: Icon(Icons.edit)),
//                                 IconButton(
//                                     color: Colors.red,
//                                     onPressed: () async {
//                                       setState(() {
//                                         deleteCourse(course);
//                                       });
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
//                                     },
//                                     icon: Icon(Icons.delete))
//                               ],
//                             )),
//                       ),
//                     ),

//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     ClipOval(
//                       child: Material(
//                         color: Color.fromARGB(255, 7, 77, 134), // Button color
//                         child: InkWell(
//                           splashColor: Colors.red, // Splash color
//                           onTap: () {
//                             Navigator.of(context).push(MaterialPageRoute(
//                                 builder: (context) => SearchCourse())).then((_)=> setState((){}));
//                           },
//                           child: SizedBox(
//                               width: 65,
//                               height: 65,
//                               child: Icon(
//                                 Icons.add,
//                                 color: Colors.white,
//                               )),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ]));
//             }
//             if (snapshot.connectionState == ConnectionState.waiting)
//               return Center(child: (CircularProgressIndicator()));
//             else
//               return (Container(
//                 child: Text("Error loading data"),
//               ));
//           },
//         ),
//       ),
//     )));
//   }
// }
