import 'package:client/graphQL/a-gate/courseFeedback.dart';
import 'package:client/screens/a-gate/courseFeedback.dart/main.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../database/main.dart';
import '../../../models/courseFb.dart';
import '../../../themes.dart';
import '../../../widgets/button/elevated_button.dart';
import '../../academics/search_course.dart';
// import '../../academics/search_course.dart';

class AddCourseFbWrapper extends StatefulWidget {
  // final AcademicService academicService;
  final CourseFeedbackModel? course;
  final String? courseId;
  const AddCourseFbWrapper(
      {Key? key,
      // required this.academicService,
      this.course,
      this.courseId})
      : super(key: key);

  @override
  State<AddCourseFbWrapper> createState() => _AddCourseFbScreenWrapperState();
}

class _AddCourseFbScreenWrapperState extends State<AddCourseFbWrapper> {
  CourseFeedbackModel? course;
  bool skipSearch = false;

  @override
  void initState() {
    course = widget.course;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (course != null || skipSearch) {
      return AddCourseFeedback(
        // academicService: widget.academicService,
        course: course,
        courseId: widget.courseId,
      );
    }
    return SearchCourse(
      onItemClick: (_c) => setState(
        () {
          // course = _c;
        },
      ),
      onSkip: () => setState(() {
        skipSearch = true;
      }),
    );
  }
}

class AddCourseFeedback extends StatefulWidget {
  // final AcademicService academicService;
  final CourseFeedbackModel? course;
  final String? courseId;
  final String? initalCourseId;
  final String? initialCourseName;
  const AddCourseFeedback({
    Key? key,
    // required this.academicService,
    this.course,
    this.courseId,
    this.initalCourseId,
    this.initialCourseName,
  }) : super(key: key);

  @override
  State<AddCourseFeedback> createState() => _AddCourseFeedbackState();
}

class _AddCourseFeedbackState extends State<AddCourseFeedback> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController courseid =
      TextEditingController(text: widget.initalCourseId);
  late TextEditingController coursename =
      TextEditingController(text: widget.initialCourseName);
  final TextEditingController profname = TextEditingController();
  final TextEditingController coursereview = TextEditingController();
  double courseRating = 0;

  @override
  void initState() {
    if (widget.course != null) {
      var _c = widget.course!;
      courseid.text = _c.courseCode;
      coursename.text = _c.courseName;
    }
    super.initState();
  }

  @override
  void dispose() {
    courseid.dispose();
    coursename.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Mutation(
        options: MutationOptions(
            document: gql(FeedbackGQL.createFeedback),
            onError: (error) => {
                  print(error),
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Couldn't give a feedback")))
                },
            // update: (cache, result) {
            //   ScaffoldMessenger.of(context).showSnackBar(
            //       const SnackBar(content: Text("feedback submitted")));
            //   Navigator.pop(context);
            // },
            onCompleted: (r) => {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("feedback submitted"))),
                  Navigator.of(context).pop(),
                  Navigator.of(context).pop(),
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CourseFeedbackScreen()))
                }),
        builder: (
          RunMutation runMutation,
          QueryResult? result,
        ) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Add Course Feedback"),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 42),
              child: Form(
                key: formKey,
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        // initialValue: widget.initalCourseId,
                        maxLength: 6,
                        minLines: 1,
                        maxLines: null,
                        controller: courseid,
                        decoration: InputDecoration(
                          labelText: "Course ID",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter the Course ID";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        // initialValue: widget.initialCourseName,
                        maxLength: 40,
                        minLines: 1,
                        maxLines: null,
                        controller: coursename,
                        decoration: InputDecoration(
                          labelText: "Course Name",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter the Course Name";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        maxLength: 40,
                        minLines: 1,
                        maxLines: null,
                        controller: profname,
                        decoration: InputDecoration(
                          labelText: "Name of the Professor",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter the Professor's Name";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Course Rating",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Slider(
                            value: courseRating,
                            min: 0,
                            max: 10,
                            divisions: 10,
                            label: courseRating.toString(),
                            activeColor: Color.fromARGB(255, 75, 67, 178),
                            thumbColor: Color(0xFF342f81),
                            onChanged: (value) {
                              setState(() {
                                courseRating = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextFormField(
                        controller: coursereview,
                        maxLength: 3000,
                        maxLines: null,
                        decoration: InputDecoration(
                          labelText: "Your review on Course",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter your review on Course";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomElevatedButton(
                            padding: const [25, 15],
                            textSize: 18,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                runMutation({
                                  'createFeedbackInput': {
                                    "courseCode": courseid.text,
                                    "courseName": coursename.text,
                                    "profName": profname.text,
                                    "rating": courseRating.toInt(),
                                    "review": coursereview.text
                                  }
                                });
                              }
                            },
                            text: 'Post',
                            // isLoading: isLoading || (result != null ? result.isLoading : false),
                            color: ColorPalette.palette(context).primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
