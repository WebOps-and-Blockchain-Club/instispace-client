import 'package:flutter/material.dart' hide SearchBar;
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../graphQL/academics/course.dart';
import '../../models/academic/course.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/card.dart';
import '../../widgets/headers/main.dart';
import '../../widgets/helpers/navigate.dart';
import '../user/search_user.dart';

class SearchCourse extends StatefulWidget {
  final void Function(CourseModel course)? onItemClick;
  final void Function()? onSkip;
  const SearchCourse({Key? key, this.onItemClick, this.onSkip})
      : super(key: key);

  @override
  State<SearchCourse> createState() => _SearchCourseState();
}

class _SearchCourseState extends State<SearchCourse> {
  late String searchValidationError = "";

  String search = "";

  @override
  Widget build(BuildContext context) {
    final QueryOptions<Object?> options = QueryOptions(
        document: gql(CourseGQL.get),
        variables: CourseQueryVariableModel(
          search: search,
        ).toJson(),
        parserFn: (data) => CoursesModel.fromJson(data));

    return Scaffold(
      body: NestedScrollView(
        // physics: const AlwaysScrollableScrollPhysics(),
        controller: ScrollController(),
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
          return <Widget>[
            // AppBar
            secondaryAppBar(title: 'SEARCH COURSE'),

            // SearchBar & Filter
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
                onPressed: widget.onSkip,
                child: const Text('Skip & Enter Course details manually'),
              ))
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
                                fontSize: 16, fontWeight: FontWeight.w400),
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
                          as List<dynamic>
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
                              child: const Text("Load More")),
                ),
              ),
      ),
    );
  }
}

// import 'package:client/database/academic.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import '../../models/course.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';
// import 'package:client/widgets/button/icon_button.dart';
// import 'package:client/widgets/headers/main.dart';
// import 'package:flutter/material.dart';
// import '../../graphQL/courses.dart';
// import '../../models/course.dart';
// import '../../widgets/helpers/error.dart';
// import '../../widgets/helpers/loading.dart';
// import '../../widgets/headers/main.dart';
// import '../../widgets/utils/main.dart';
// import 'add_course.dart';

// class SearchCourse extends StatefulWidget {
//   const SearchCourse({Key? key}) : super(key: key);

//   @override
//   State<SearchCourse> createState() => _SearchCourseState();
// }

// class _SearchCourseState extends State<SearchCourse> {
//   final ScrollController _scrollController = ScrollController();

//   late String searchValidationError = "";

//   final TextEditingController search = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     final Map<String, dynamic> defaultVariables = {
//       "filter": search.text.trim(),
//     };
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 15),
//           child: NestedScrollView(
//               physics: const AlwaysScrollableScrollPhysics(),
//               controller: _scrollController,
//               headerSliverBuilder: (context, innerBoxIsScrolled) {
//                 return [
//                   SliverList(
//                     delegate: SliverChildBuilderDelegate(
//                         (BuildContext context, int index) {
//                       return CustomAppBar(
//                           title: "Search courses",
//                           leading: CustomIconButton(
//                             icon: Icons.arrow_back,
//                             onPressed: () => Navigator.of(context).pop(),
//                           ));
//                     }, childCount: 1),
//                   ),
//                   SliverPersistentHeader(
//                     pinned: true,
//                     floating: true,
//                     delegate: SearchBarDelegate(
//                       additionalHeight: searchValidationError != "" ? 18 : 0,
//                       searchUI: SearchBar(
//                         time: 200,
//                         padding: const EdgeInsets.symmetric(vertical: 10.0),
//                         onSubmitted: (value) {
//                           if (value.isEmpty || value.length >= 3) {
//                             setState(() {
//                               search.text = value;
//                               searchValidationError = "";
//                             });
//                           } else {
//                             setState(() {
//                               searchValidationError =
//                                   "Enter at least 3 characters";
//                             });
//                           }
//                         },
//                         error: searchValidationError,
//                       ),
//                     ),
//                   )
//                 ];
//               },
//               body: (search.text.length < 3)
//                   ? Text("Enter atleast 3 characters")
//                   : Query(
//                       options: QueryOptions(
//                         document: gql(CoursesGQL().searchCourses),
//                         variables: defaultVariables,
//                       ),
//                       builder: (QueryResult result,
//                           {FetchMore? fetchMore, refetch}) {
//                         return RefreshIndicator(
//                             onRefresh: () {
//                               return refetch!();
//                             },
//                             child: Stack(
//                               children: [
//                                 ListView(),
//                                 (() {
//                                   if (result.hasException) {
//                                     return Error(
//                                         error: result.exception.toString());
//                                   }

//                                   if (result.isLoading && result.data == null) {
//                                     return const Loading();
//                                   }
//                                   final List<dynamic> courses = result
//                                       .data!["searchCourses"]
//                                       .map((_course) =>
//                                           _course["courseCode"] +
//                                           " - " +
//                                           _course["courseName"])
//                                       .toList();

//                                   if (courses.isEmpty) {
//                                     return const Error(
//                                       error: "",
//                                       message: "No courses found",
//                                     );
//                                   }
//                                   return ListView.builder(
//                                       itemCount: courses.length,
//                                       itemBuilder: ((context, index) {
//                                         return InkWell(
//                                           onTap: () async {
//                                             CoursesModel coursesModel =
//                                                 await AcademicDatabase.instance
//                                                     .getAllCourses();
//                                             Navigator.of(context).push(
//                                                 MaterialPageRoute(
//                                                     builder: ((context) =>
//                                                         AddCourse(
//                                                           courseCode:
//                                                               courses[index]
//                                                                   .substring(
//                                                                       0, 6),
//                                                           courses: coursesModel,
//                                                         ))));
//                                           },
//                                           child: Card(
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.all(8.0),
//                                               child: Text(courses[index]),
//                                             ),
//                                           ),
//                                         );
//                                       }));
//                                 }())
//                               ],
//                             ));
//                       })),
//         ),
//       ),
//     );
//   }
// }
