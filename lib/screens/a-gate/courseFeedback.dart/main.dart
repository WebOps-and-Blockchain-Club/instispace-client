import 'package:client/screens/a-gate/courseFeedback.dart/searchCourseFb.dart';
import 'package:flutter/material.dart';
import '../../../models/courseFb.dart';

class CourseFeedbackScreen extends StatefulWidget {
  // final Widget appBar;
  final bool createPost;
  const CourseFeedbackScreen({
    Key? key,
    // required this.appBar,

    this.createPost = false,
  }) : super(key: key);

  @override
  _CourseFeedbackScreenState createState() => _CourseFeedbackScreenState();
}

class _CourseFeedbackScreenState extends State<CourseFeedbackScreen> {
  List<CourseFeedbackModel> courseFeedbackList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView.builder(
        itemCount: courseFeedbackList.length,
        itemBuilder: (context, index) {
          final courseFeedback = courseFeedbackList[index];
          return ListTile(
            title: Text(courseFeedback.courseCode),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SearchCourseFb(),
            ),
          );
        },
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
