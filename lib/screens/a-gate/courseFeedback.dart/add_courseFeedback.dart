import 'package:flutter/material.dart';

import '../../../database/main.dart';
import '../../../models/courseFb.dart';
import '../../../themes.dart';
import '../../../widgets/button/elevated_button.dart';
import '../../academics/search_course.dart';

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
  const AddCourseFeedback({
    Key? key,
    // required this.academicService,
    this.course,
    this.courseId,
  }) : super(key: key);

  @override
  State<AddCourseFeedback> createState() => _AddCourseFeedbackState();
}

class _AddCourseFeedbackState extends State<AddCourseFeedback> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController courseid = TextEditingController();
  final TextEditingController coursename = TextEditingController();
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
                        if (formKey.currentState!.validate()) {}
                      },
                      text: 'Post',
                      // isLoading: isLoading || (result != null ? result.isLoading : false),
                      color: ColorPalette.palette(context).primary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10)
            ],
          ),
        ),
      ),
    );
  }
}
