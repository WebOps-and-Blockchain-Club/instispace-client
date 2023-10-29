import 'package:client/models/category.dart';
import 'package:client/screens/home/new_post/chooseImages.dart';
import 'package:client/screens/home/new_post/newPost.dart';
import 'package:client/themes.dart';
import 'package:client/widgets/helpers/navigate.dart';
import 'package:flutter/material.dart';

import '../../screens/home/new_post/main.dart';

class CategoryList extends StatefulWidget {
  final options;
  final List<PostCategoryModel> categories;
  const CategoryList({
    Key? key,
    required this.categories,
    this.options,
  }) : super(key: key);

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset(1, 0),
    end: Offset(200, 90),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticIn,
  ));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding:
          const EdgeInsets.only(bottom: 0, left: 180, top: 320, right: 15),
      contentPadding: const EdgeInsets.all(10),
      backgroundColor: const Color(0xFFE1E0EC),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: SizedBox(
        width: 50,
        child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.categories.length,
            itemBuilder: ((context, index) {
              return TextButton(
                  onPressed: () {
                    navigate(
                        context,
                        NewPostWrapper(
                            options: widget.options,
                            category: widget.categories[index]));
                  },
                  child: Text(
                    widget.categories[index].name,
                    style: const TextStyle(color: Colors.black),
                  ),
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      fixedSize: const Size(120, 40),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))));
            })),
      ),
    );
  }
}
