import 'package:flutter/material.dart';

class CoursesFeedbackModel {
  final List<CourseFeedbackModel> list;
  final int total;

  CoursesFeedbackModel({required this.list, required this.total});

  // CoursesFeedbackModel.fromJson(dynamic data)
  //     : list = (data["findAllCourse"]["list"] as List<dynamic>)
  //           .map((e) => CoursesFeedbackModel.fromSJson(e))
  //           .toList(),
  //       total = data["findAllCourse"]['total'];
}

class CourseFeedbackModel {
  final String courseCode;
  final String courseName;
  final String professorName;
  final double courseRating;
  final String courseReview;

  CourseFeedbackModel({
    required this.courseCode,
    required this.courseName,
    required this.professorName,
    required this.courseRating,
    required this.courseReview,
  });

  factory CourseFeedbackModel.fromJson(Map<String, dynamic> data) {
    return CourseFeedbackModel(
      courseCode: data['courseCode'],
      courseName: data['courseName'],
      professorName: data[' professorName'],
      courseRating: data['courseRating'],
      courseReview: data['courseReview'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseCode,
      'courseName': courseName,
      'professorName': professorName,
      'courseRating': courseRating,
      'courseReview': courseReview,
    };
  }
}
