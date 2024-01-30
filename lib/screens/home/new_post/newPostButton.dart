import 'package:client/models/category.dart';
import 'package:client/models/user.dart';
import 'package:client/themes.dart';
import 'package:client/widgets/button/catList.dart';
import 'package:flutter/material.dart';

class NewPostButton extends StatelessWidget {
  final options;
  final UserModel user;
  final List<PostCategoryModel> categories;
  const NewPostButton(
      {Key? key, this.options, required this.categories, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 50,
      child: FloatingActionButton(
        backgroundColor: ColorPalette.palette(context).secondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(
          Icons.add,
          size: 30,
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return CategoryList(
                    options: options,
                    user: user,
                    categories: List.generate(
                        categories.length,
                        (index) => PostCategoryModel.fromJson(
                            categories[index].name)));
              });
        },
      ),
    );
  }
}
