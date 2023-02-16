import 'package:client/database/academic.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../../models/course.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:client/widgets/button/icon_button.dart';
import 'package:client/widgets/headers/main.dart';
import 'package:flutter/material.dart';
import '../../graphQL/courses.dart';
import '../../models/course.dart';
import '../../widgets/helpers/error.dart';
import '../../widgets/helpers/loading.dart';
import '../../widgets/headers/main.dart';
import '../../widgets/utils/main.dart';
import 'add_course.dart';

class SearchCourse extends StatefulWidget {
  const SearchCourse({Key? key}) : super(key: key);

  @override
  State<SearchCourse> createState() => _SearchCourseState();
}

class _SearchCourseState extends State<SearchCourse> {
  final ScrollController _scrollController = ScrollController();

  late String searchValidationError = "";

  final TextEditingController search = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> defaultVariables = {
      "filter": search.text.trim(),
    };
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: NestedScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return CustomAppBar(
                          title: "Search courses",
                          leading: CustomIconButton(
                            icon: Icons.arrow_back,
                            onPressed: () => Navigator.of(context).pop(),
                          ));
                    }, childCount: 1),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    floating: true,
                    delegate: SearchBarDelegate(
                      additionalHeight: searchValidationError != "" ? 18 : 0,
                      searchUI: SearchBar(
                        time: 200,
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        onSubmitted: (value) {
                          if (value.isEmpty || value.length >= 3) {
                            setState(() {
                              search.text = value;
                              searchValidationError = "";
                            });
                          } else {
                            setState(() {
                              searchValidationError =
                                  "Enter at least 3 characters";
                            });
                          }
                        },
                        error: searchValidationError,
                      ),
                    ),
                  )
                ];
              },
              body: (search.text.length < 3)
                  ? Text("Enter atleast 3 characters")
                  : Query(
                      options: QueryOptions(
                        document: gql(CoursesGQL().searchCourses),
                        variables: defaultVariables,
                      ),
                      builder: (QueryResult result,
                          {FetchMore? fetchMore, refetch}) {
                        return RefreshIndicator(
                            onRefresh: () {
                              return refetch!();
                            },
                            child: Stack(
                              children: [
                                ListView(),
                                (() {
                                  if (result.hasException) {
                                    return Error(
                                        error: result.exception.toString());
                                  }

                                  if (result.isLoading && result.data == null) {
                                    return const Loading();
                                  }
                                  final List<dynamic> courses = result
                                      .data!["searchCourses"]
                                      .map((_course) =>
                                          _course["courseCode"] +
                                          " - " +
                                          _course["courseName"])
                                      .toList();

                                  if (courses.isEmpty) {
                                    return const Error(
                                      error: "",
                                      message: "No courses found",
                                    );
                                  }
                                  return ListView.builder(
                                      itemCount: courses.length,
                                      itemBuilder: ((context, index) {
                                        return InkWell(
                                          onTap: () async {
                                            CoursesModel coursesModel =
                                                await AcademicDatabase.instance
                                                    .getAllCourses();
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: ((context) =>
                                                        AddCourse(
                                                          courseCode:
                                                              courses[index]
                                                                  .substring(
                                                                      0, 6),
                                                          courses: coursesModel,
                                                        ))));
                                          },
                                          child: Card(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(courses[index]),
                                            ),
                                          ),
                                        );
                                      }));
                                }())
                              ],
                            ));
                      })),
        ),
      ),
    );
  }
}
