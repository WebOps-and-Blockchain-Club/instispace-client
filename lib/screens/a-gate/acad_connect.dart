import 'package:flutter/material.dart';

import '../../models/category.dart';
import '../../utils/custom_icons.dart';
import '../../widgets/home_app_bar.dart';
import '../home/post/main.dart';

class AcadConnectScreen extends StatefulWidget {
  const AcadConnectScreen({super.key});

  @override
  State<AcadConnectScreen> createState() => _AcadConnectScreenState();
}

class _AcadConnectScreenState extends State<AcadConnectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: _scaffoldKey,
      body: PostPage(
              appBar: SliverAppBar() ,
              // appBar: HomeAppBar(
              //   title: "Forum",
              //   // scaffoldKey: _scaffoldKey,
              //   user: widget.user,
              // ),
              categories: [PostCategoryModel(name: "Academics", icon: CustomIcons.opportunities)],
              createPost: true,
            ),
    );
  }
}