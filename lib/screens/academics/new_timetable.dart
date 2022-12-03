import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:client/graphQL/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/widgets/button/icon_button.dart';
import 'package:client/widgets/headers/main.dart';
import 'package:flutter/material.dart';

class NewTimetable extends StatefulWidget {
  const NewTimetable({Key? key}) : super(key: key);

  @override
  State<NewTimetable> createState() => _NewTimetableState();
}

class _NewTimetableState extends State<NewTimetable> {
  @override
  List<String> courseCodes = [];

  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();
    final TextEditingController _courseCodeController = TextEditingController();
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
                            title: "Timetable",
                            leading: CustomIconButton(
                                icon: Icons.arrow_back,
                                onPressed: () => Navigator.of(context).pop()),
                          );
                        }, childCount: 1),
                      ),
                    ];
                  },
                  body: Column(children: [
                    if (courseCodes.isNotEmpty)
                      for (var courseCode in courseCodes) Text(courseCode),
                    Flexible(
                      flex: 2,
                      child: Container(),
                    ),
                    Row(
                      children: [
                        TextFormField(
                            controller: _courseCodeController,
                            decoration: InputDecoration(
                                hintText: "Course code ....",
                                border: OutlineInputBorder())),
                        ElevatedButton(
                          child: Text("Add"),
                          onPressed: () {
                            setState(() {
                              courseCodes.add(_courseCodeController.text);
                            });
                          },
                        )
                      ],
                    )
                  ]),
                ))));
  }
}
