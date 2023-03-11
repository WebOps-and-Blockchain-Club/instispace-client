import 'package:client/models/academic/course.dart';
import 'package:client/screens/academics/add_course.dart';
import 'package:client/utils/custom_icons.dart';
import 'package:client/widgets/card.dart';
import 'package:flutter/material.dart';

import '../../database/main.dart';

class CoursesScreen extends StatefulWidget {
  final AcademicService academicService;

  const CoursesScreen({Key? key, required this.academicService})
      : super(key: key);

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  @override
  Widget build(BuildContext context) {
    final List<CourseModel>? courses = widget.academicService.courses;
    final academicService = widget.academicService;
    if (courses != null && courses.isEmpty) {
      return const Center(
          child: Text(
        "No Courses Found",
        style: TextStyle(fontSize: 18),
      ));
    }
    return ListView.builder(
      itemCount: courses!.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 30),
          child: CustomCard(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                course.courseCode + " - " + course.courseName,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              Text(course.slots
                      ?.map((e) =>
                          '${e.slotName.split('/')[0]} Slot - ${e.fromTimeStr} - ${e.toTimeStr}')
                      .toList()
                      .join(', ') ??
                  ""),
              const SizedBox(height: 10),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: IconButton(
                        icon: const Icon(CustomIcons.edit),
                        onPressed: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AddCourseScreenWrapper(
                                academicService: academicService,
                                course: course,
                                courseId: course.id,
                              ),
                            ))),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: IconButton(
                        icon: const Icon(CustomIcons.delete),
                        onPressed: course.id == null
                            ? null
                            : () => academicService.deleteCourse(course.id!)),
                  ),
                ],
              )
            ],
          )),
        );
      },
    );
  }
}
