import 'package:client/models/user.dart';
import 'package:flutter/material.dart';

class CoursesFeedbackModel {
  final List<dynamic> list;
  final int total;

  CoursesFeedbackModel({required this.list, required this.total});

  CoursesFeedbackModel.fromJson(dynamic data)
      : list = (data["findAllFeedback"]["list"] as List<dynamic>)
            .map((e) => CourseFeedbackModel.fromJson(e))
            .toList(),
        total = data["findAllFeedback"]["list"].length;
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

class FeedbackQueryVariableModel {
  final String search;

  FeedbackQueryVariableModel(this.search);

  Map<String, dynamic> toJson() {
    return {"search": search};
  }
}
