import 'package:client/graphQL/courses.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:client/graphQL/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/widgets/button/icon_button.dart';
import 'package:client/widgets/headers/main.dart';
import 'package:flutter/material.dart';
import '../../models/course.dart';
import '../../database/academic.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class NewTimetable extends StatefulWidget {
  const NewTimetable({Key? key}) : super(key: key);

  @override
  State<NewTimetable> createState() => _NewTimetableState();
}

class _NewTimetableState extends State<NewTimetable> {
  var courseCode;
  var courseName;
  var slot;
  CoursesModel? _courses;
  final Map<String, dynamic> defaultVariables = {"filter": "CS5"};
  void getCourses() async {
    _courses = await AcademicDatabase.instance.getAllCourses();
  }

  @override
  void initState() {
    getCourses();
    super.initState();
  }

  void deleteCourse(CourseModel course) async {
    int id = await AcademicDatabase.instance.deleteCourse(course.id!);
  }

  void showDialogWithFields() {
    showDialog(
      context: context,
      builder: (_) {
        var courseCodeController = TextEditingController();
        var courseNameController = TextEditingController();
        var slotController = TextEditingController();
        return AlertDialog(
          title: Text('Add Course'),
          content: SizedBox(
            height: 150,
            child: Column(
              children: [
                TextFormField(
                  controller: courseCodeController,
                  decoration: InputDecoration(hintText: 'Course Code'),
                ),
                TextFormField(
                  controller: courseNameController,
                  decoration: InputDecoration(hintText: 'Course Name'),
                ),
                TextFormField(
                  controller: slotController,
                  decoration: InputDecoration(hintText: 'Course Slot'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Send them to your email maybe?
                courseName = courseNameController.text;
                courseCode = courseCodeController.text;
                slot = slotController.text;
                CourseModel course = CourseModel(
                  courseCode: courseCode,
                  courseName: courseName,
                  slot: slot,
                );
                await AcademicDatabase.instance.addCourse(course);
                CoursesModel courses =
                    await AcademicDatabase.instance.getAllCourses();
                setState(() {
                  _courses = courses;
                });

                Navigator.of(context).pop();
                print(courses.courses);
                print("*******");
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  String getTruncatedName(String courseName) {
    if (courseName.length > 20)
      courseName = courseName.substring(0, 20) + "...";

    return courseName;
  }

  @override
  List<String> courseCodes = [];

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
                  body: FutureBuilder<CoursesModel>(
                    future: AcademicDatabase.instance.getAllCourses(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        getCourses();
                        return (Column(children: [
                          if (_courses != null)
                            for (var course in _courses!.courses)
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Container(
                                      width: double.infinity,
                                      child: Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                course.courseCode,
                                                style: TextStyle(fontSize: 22),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                getTruncatedName(
                                                    course.courseName),
                                                style: TextStyle(fontSize: 18),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "${course.slot} Slot",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                          new Spacer(),
                                          IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  deleteCourse(course);
                                                });
                                              },
                                              icon: Icon(Icons.delete))
                                        ],
                                      )),
                                ),
                              ),
                          Flexible(
                            flex: 2,
                            child: Container(),
                          ),
                          Query(
                            options: QueryOptions(
                                document: gql(CoursesGQL().searchCourses),
                                variables: defaultVariables),
                            builder: (QueryResult result,
                                {fetchMore, refetch}) {
                              print(result);
                              return Container();
                            },
                          ),
                          Row(
                            children: [
                              ClipOval(
                                child: Material(
                                  color: Color.fromARGB(
                                      255, 7, 77, 134), // Button color
                                  child: InkWell(
                                    splashColor: Colors.red, // Splash color
                                    onTap: showDialogWithFields,
                                    child: SizedBox(
                                        width: 65,
                                        height: 65,
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ]));
                      }
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return (CircularProgressIndicator());
                      else
                        return (Container(
                          child: Text("Error loading data"),
                        ));
                    },
                  ),
                ))));
  }
}
