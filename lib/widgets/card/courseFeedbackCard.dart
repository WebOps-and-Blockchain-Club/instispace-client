import 'package:flutter/material.dart';

class CourseFeedbackCard extends StatelessWidget {
  const CourseFeedbackCard({super.key,required this.coursRating, required this.courseName, required this.createdBy, required this.description});
  final String courseName;
  final String description;
  final String coursRating;
  final String createdBy;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Course Name',
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.star, color: Colors.yellow, size: 24.0),
                        Text('4.5', style: TextStyle(fontSize: 18.0)),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Description:',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'This course is fantastic and highly recommended for anyone interested in the topic.',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Created By:',
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8.0),
                    Text('John Doe', style: TextStyle(fontSize: 16.0)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}