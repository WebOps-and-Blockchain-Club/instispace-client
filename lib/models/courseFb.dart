import 'package:client/models/user.dart';
import 'package:flutter/material.dart';

class CoursesFeedbackModel {
  final List<dynamic> list;
  // final int total;

  CoursesFeedbackModel({required this.list});

  CoursesFeedbackModel.fromJson(dynamic data)
      : list = (data as List<dynamic>)
            .map((e) => CourseFeedbackModel.fromJson(e))
            .toList();
}

class CourseFeedbackModel {
  final String id;
  final String courseCode;
  final String courseName;
  final String professorName;
  final int courseRating;
  final String courseReview;
  final CreatedByModel createdBy;
  final String createdAt;

  CourseFeedbackModel({
    required this.createdAt,
    required this.id,
    required this.createdBy,
    required this.courseCode,
    required this.courseName,
    required this.professorName,
    required this.courseRating,
    required this.courseReview,
  });

  CourseFeedbackModel.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        courseCode = data['courseCode'],
        courseName = data['courseName'],
        courseRating = data['rating'],
        courseReview = data['review'],
        createdAt = data['createdAt'],
        createdBy = CreatedByModel.fromJson(data['createdBy']),
        professorName = data['profName'];
}
