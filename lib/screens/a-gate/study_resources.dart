import 'package:flutter/material.dart';

import '../../models/category.dart';
import '../../utils/custom_icons.dart';
import '../home/post/main.dart';

class StudyResourcesScreen extends StatefulWidget {
  const StudyResourcesScreen({super.key});
  @override
  State<StudyResourcesScreen> createState() => _StudyResourcesScreenState();
}

class _StudyResourcesScreenState extends State<StudyResourcesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: _scaffoldKey,
      body: PostPage(
        appBar: SliverAppBar(),
        // appBar: HomeAppBar(
        //   title: "Forum",
        //   // scaffoldKey: _scaffoldKey,
        //   user: widget.user,
        // ),
        categories: [
          PostCategoryModel(
              name: "Study Resources", icon: CustomIcons.opportunities)
        ],
        createPost: true,
      ),
    );
    ;
  }
}
