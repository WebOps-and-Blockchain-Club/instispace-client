import 'package:client/graphQL/feedback.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {

  ///GraphQL
  String feedbackSheet = FeedBackMutation().feedbackSheetLink;

  ///Variables
  String feedbackSheetLink = "";

  @override
  Widget build(BuildContext context) {
      return Query(
        options: QueryOptions(
          document: gql(feedbackSheet),
        ),
        builder: (QueryResult result, {fetchMore, refetch}) {
          if(result.hasException) {
            print(result.hasException.toString());
          }
          if(result.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF2B2E35),),
            );
          }
            feedbackSheetLink = result.data!["getSheetLink"];
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "Feedbacks",
                style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
              elevation: 0,
              backgroundColor: const Color(0xFF2B2E35),
            ),

            backgroundColor: const Color(0xFFDFDFDF),

            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  launch(feedbackSheetLink);
                },
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFF2B2E35),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  minimumSize: const Size(80, 35),
                ),
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(15,5,15,5),
                  child: Text('Feedbacks',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
  }
}
