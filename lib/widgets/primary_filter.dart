import 'package:flutter/material.dart';
import '../models/post/actions.dart';

class PrimaryFilter extends StatefulWidget {
  final List<PostCategoryModel> categories;
  final void Function(List<PostCategoryModel>) onCategoryTab;

  const PrimaryFilter(
      {Key? key, required this.categories, required this.onCategoryTab})
      : super(key: key);

  @override
  State<PrimaryFilter> createState() => _PrimaryFilterState();
}

class _PrimaryFilterState extends State<PrimaryFilter> {
  late List<PostCategoryModel> selectedCategories = [];

  @override
  Widget build(BuildContext context) {
    final List<PostCategoryModel> categories = widget.categories;
    return SizedBox(
      height: 30,
      child: ListView.builder(
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (BuildContext context, int index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (selectedCategories.contains(categories[index])) {
                        selectedCategories.remove(categories[index]);
                      } else {
                        selectedCategories.add(categories[index]);
                      }
                    });
                    widget.onCategoryTab(selectedCategories);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                        color: selectedCategories.contains(categories[index])
                            ? Colors.black
                            : const Color(0xFFEEEEEE),
                        borderRadius: BorderRadiusDirectional.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(
                            categories[index].icon,
                            size: 15,
                            color:
                                selectedCategories.contains(categories[index])
                                    ? Colors.white
                                    : const Color(0xFF505050),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            categories[index].name,
                            style: TextStyle(
                                fontSize: 15,
                                color: selectedCategories
                                        .contains(categories[index])
                                    ? Colors.white
                                    : const Color(0xFF505050)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )),
    );
  }
}
