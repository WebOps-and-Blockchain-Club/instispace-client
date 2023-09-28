import 'package:client/models/courseFb.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../graphQL/academics/course.dart';
import '../../../models/academic/course.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/card.dart';
import '../../../widgets/search_bar.dart';
import '../../user/search_user.dart';
import 'add_courseFeedback.dart';

class SearchCourseFb extends StatefulWidget {
  final void Function(CourseModel course)? onItemClick;
  final void Function()? onSkip;

  const SearchCourseFb({Key? key, this.onItemClick, this.onSkip})
      : super(key: key);

  @override
  State<SearchCourseFb> createState() => _SearchCourseState();
}

class _SearchCourseState extends State<SearchCourseFb> {
  late String searchValidationError = "";
  String search = "";

  @override
  Widget build(BuildContext context) {
    final QueryOptions<Object?> options = QueryOptions(
      document: gql(CourseGQL.get),
      variables: CourseQueryVariableModel(
        search: search,
      ).toJson(),
      parserFn: (data) => CoursesModel.fromJson(data),
    );

    return Scaffold(
      body: NestedScrollView(
        controller: ScrollController(),
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
          return <Widget>[
            secondaryAppBar(title: 'SEARCH COURSE '),
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
              ]),
            ),
          ];
        },
        body: search == ''
            ? Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AddCourseFeedback(),
                      ),
                    );
                  },
                  child: const Text('Skip & Enter Course details manually'),
                ),
              )
            : QueryList<CourseModel>(
                options: options,
                itemBuilder: (course) => Padding(
                  padding:
                      const EdgeInsets.only(right: 20.0, left: 20, top: 20),
                  child: GestureDetector(
                    onTap: widget.onItemClick != null
                        ? () => widget.onItemClick!(course)
                        : null,
                    child: CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            course.courseCode,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(course.courseName),
                          const SizedBox(height: 5),
                          Text(
                              course.slots?.map((e) => e.slotName).join(', ') ??
                                  ''),
                        ],
                      ),
                    ),
                  ),
                ),
                fetchMoreOption: (item) => FetchMoreOptions(
                  variables: {...options.variables, "lastCourseId": item.id},
                  updateQuery: (previousResultData, fetchMoreResultData) {
                    final List<dynamic> repos = [
                      ...previousResultData!['findAllCourse']['list']
                          as List<dynamic>,
                      ...fetchMoreResultData!["findAllCourse"]["list"]
                          as List<dynamic>,
                    ];
                    fetchMoreResultData["findAllCourse"]["list"] = repos;
                    return fetchMoreResultData;
                  },
                ),
                endOfListWidget: (result, fetchMore) => Padding(
                  padding: const EdgeInsets.all(20),
                  child: (result.parsedData as CoursesModel).total ==
                          (result.parsedData as CoursesModel).list.length
                      ? null
                      : result.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : TextButton(
                              onPressed: () => fetchMore,
                              child: const Text("Load More"),
                            ),
                ),
              ),
      ),
    );
  }
}
