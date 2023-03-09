import 'package:client/screens/academics/courses.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_course.dart';
import 'calendar.dart';
import 'time_table.dart';
import '../../database/main.dart';
import '../../themes.dart';
import '../../widgets/helpers/navigate.dart';

class AcademicWrapper extends StatefulWidget {
  final Widget appBar;

  const AcademicWrapper({Key? key, required this.appBar}) : super(key: key);

  @override
  State<AcademicWrapper> createState() => _AcademicWrapperState();
}

class _AcademicWrapperState extends State<AcademicWrapper> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AcademicService(),
      child:
          Consumer<AcademicService>(builder: (context, academicService, child) {
        return AcademicScheduleScreen(
            appBar: widget.appBar, academicService: academicService);
      }),
    );
  }
}

class AcademicScheduleScreen extends StatefulWidget {
  final Widget appBar;
  final AcademicService academicService;

  const AcademicScheduleScreen({
    Key? key,
    required this.appBar,
    required this.academicService,
  }) : super(key: key);

  @override
  State<AcademicScheduleScreen> createState() => _AcademicScheduleScreenState();
}

class _AcademicScheduleScreenState extends State<AcademicScheduleScreen> {
  final menus = ["Time Table", "Calendar", "Courses"];
  String selectedMenu = "Time Table";

  @override
  Widget build(BuildContext context) {
    final academicService = widget.academicService;
    return Scaffold(
      body: NestedScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: ScrollController(),
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
          return <Widget>[
            // AppBar
            widget.appBar,

            SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    selectedMenu,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: menus
                        .map((e) => Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: e == menus[0] ? 0 : 8.0),
                                child: AcademicMenu(
                                  onPressed: () {
                                    setState(() {
                                      selectedMenu = e;
                                    });
                                  },
                                  text: e,
                                  isSelected: selectedMenu == e,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ]),
            ),
          ];
        },
        body: (() {
          if (selectedMenu == 'Courses') {
            return CoursesScreen(academicService: academicService);
          }
          if (selectedMenu == 'Calendar') return const Calendar();
          return TimeTableScreen(academicService: academicService);
        }()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigate(
            context,
            AddCourseScreenWrapper(academicService: academicService),
          );
        },
        backgroundColor: ColorPalette.palette(context).secondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AcademicMenu extends StatelessWidget {
  final bool isSelected;
  final void Function()? onPressed;
  final String text;
  const AcademicMenu(
      {Key? key, this.isSelected = false, this.onPressed, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          backgroundColor:
              isSelected ? const Color(0xFFD4D2ED) : const Color(0xFFE6E6E6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
              color: Color(0xFF262626),
              fontSize: 14,
              fontWeight: FontWeight.normal),
        ));
  }
}
