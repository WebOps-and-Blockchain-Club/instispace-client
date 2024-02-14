import 'package:client/graphQL/a-gate/courseFeedback.dart';
import 'package:client/screens/a-gate/courseFeedback.dart/searchCourseFb.dart';
import 'package:client/widgets/card/courseFeedbackCard.dart';
// import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../models/courseFb.dart';
import '../../../widgets/helpers/error.dart';
import 'package:flutter/material.dart' hide SearchBar;
import '../../../widgets/search_bar.dart' as search;
import '../../../widgets/search_bar.dart';

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
  String search = "";
  String lastpostId = "";
  final int take = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "COURSE FEEDBACK",
          style: TextStyle(
              letterSpacing: 1,
              color: Color(0xFF3C3C3C),
              fontSize: 20,
              fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: NestedScrollView(
        // physics: const AlwaysScrollableScrollPhysics(),
        controller: ScrollController(),
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
          return <Widget>[
            // AppBar
            // widget.appBar,

            // SearchBar 
            SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SearchBar(
                    onSubmitted: (value) {
                      setState(() {
                        search = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10),
              ]),
            ),
          ];
        },
        body: Query(
          options: QueryOptions(
              document: gql(FeedbackGQL.findAllFeedback),
              variables: {
                "search": search,
                "lastpostId": lastpostId,
                "take": take.toDouble(),
                },
              parserFn: ((data)=> CoursesFeedbackModel.fromJson(data))),
          builder: (result, {fetchMore, refetch}) {
            print(result);
            if (result.hasException && result.data == null) {
              return Center(child: ErrorWidget(result.exception.toString()));
            }
            if (result.hasException && result.data != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                // Use Future.delayed to delay the execution of showDialog
                Future.delayed(Duration.zero, () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Center(child: Text("Error")),
                        content: Text(formatErrorMessage(
                            result.exception.toString(), context)),
                        actions: [
                          TextButton(
                            child: const Text("Ok"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: const Text("Retry"),
                            onPressed: () {
                              refetch!();
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                });
              });
            }
            if (result.isLoading && result.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final CoursesFeedbackModel resultParsedData =
                result.parsedData as CoursesFeedbackModel;
            final List<CourseFeedbackModel> courseFb =
                resultParsedData.list as List<CourseFeedbackModel>;
            if (courseFb.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Error(
                      error: '',
                      message: 'Your feed is empty',
                      onRefresh: refetch,
                    ),
                  ],
                ),
              );
            }
            if (courseFb.isNotEmpty) {
              lastpostId = courseFb.last.id;
            }
           return ListView.builder(
                itemCount: courseFb.length,
                itemBuilder: (context, index) {
                  final courseFeedback = courseFb[index];
                  return CourseFeedbackCard(
                    courseCode: courseFeedback.courseCode,
                    coursRating: courseFeedback.courseRating,
                    courseName: courseFeedback.courseName,
                    createdBy: courseFeedback.createdBy.name,
                    description: courseFeedback.courseReview,
                    createdAt: courseFeedback.createdAt,
                    profName: courseFeedback.professorName,
                  );
                }
           );
          }
              ),
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
