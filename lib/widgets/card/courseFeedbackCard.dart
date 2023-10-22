import 'package:client/widgets/card.dart';
import 'package:client/widgets/card/description.dart';
import 'package:flutter/material.dart';

import '../../models/date_time_format.dart';

class CourseFeedbackCard extends StatelessWidget {
  const CourseFeedbackCard(
      {super.key,
      required this.coursRating,
      required this.courseName,
      required this.createdBy,
      required this.description,
      required this.createdAt,
      required this.courseCode,
      required this.profName});
  final String courseName;
  final String description;
  final int coursRating;
  final String createdBy;
  final String createdAt;
  final String courseCode;
  final String profName;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: CustomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //courseName and rating
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                courseName,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
            ),
            //prof Name and course code
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                children: [
                  Text(
                    courseCode,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '-${profName}',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),

            Row(
              children: [
                Wrap(
                  children: List.generate(5, (index) {
                    return index <= coursRating / 2 - 1
                        ? Icon(
                            Icons.star,
                            color: Colors.yellow,
                          )
                        : index + 0.5 == coursRating / 2
                            ? Icon(
                                Icons.star_half,
                                color: Colors.yellow,
                              )
                            : Icon(
                                Icons.star_outline,
                                color: Colors.grey,
                              );
                  }),
                ),
                Text(
                  '(${coursRating / 2})',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black45,
                  ),
                )
              ],
            ),

            //createdBy and createdAt
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                "${createdBy}, ${DateTimeFormatModel.fromString(createdAt).toDiffString()} ago", // should change it such that when clicked it opens profile page.
                style: const TextStyle(color: Colors.black45),
                textAlign: TextAlign.left,
              ),
            ),
            //description

            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Description(content: description),
            ),
          ],
        ),
      ),
    );
  }
}
