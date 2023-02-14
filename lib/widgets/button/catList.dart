import 'package:client/screens/home/chooseImages.dart';
import 'package:client/screens/home/newPost.dart';
import 'package:client/themes.dart';
import 'package:flutter/material.dart';

class CategoryList extends StatefulWidget {
  final List<String> categories;
  const CategoryList({Key? key, required this.categories}) : super(key: key);

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
          const EdgeInsets.only(bottom: 0, left: 180, top: 10, right: 15),
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ([
                                  'Queries',
                                  'Help',
                                  'Opportunities',
                                  'Connect',
                                  'Random'
                                ].contains(widget.categories[index]))
                                    ? NewPost(
                                        category: widget.categories[index])
                                    : ChooseImages(
                                        category: widget.categories[index])));
                  },
                  child: Text(
                    widget.categories[index],
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
