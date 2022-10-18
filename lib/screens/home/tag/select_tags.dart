import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../models/tag.dart';
import '../../../graphQL/tag.dart';
import '../../../widgets/button/elevated_button.dart';
import '../../../themes.dart';
import '../../../widgets/helpers/loading.dart';
import '../../../widgets/helpers/error.dart';

class SelectTags extends StatefulWidget {
  final TagsModel selectedTags;
  final ScrollController controller;
  final Function? callback;
  final CategoryModel? additionalCategory;
  const SelectTags(
      {Key? key,
      required this.selectedTags,
      required this.controller,
      this.callback,
      this.additionalCategory})
      : super(key: key);

  @override
  State<SelectTags> createState() => _SelectTagsState();
}

class _SelectTagsState extends State<SelectTags> {
  late TagsModel selectedTags;
  List<String> minimizedCategorys = [];

  @override
  void initState() {
    selectedTags = widget.selectedTags;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Query(
          options: QueryOptions(
            document: gql(TagGQL().getAll),
          ),
          builder: (QueryResult result, {fetchMore, refetch}) {
            if (result.hasException) {
              return Error(error: result.exception.toString());
            }

            if (result.isLoading && result.data == null) {
              return const Loading();
            }

            final List<CategoryModel> categorys =
                TagsModel.fromJson(result.data!["getTags"]).getCategorysModel();
            if (widget.additionalCategory != null) {
              categorys.insert(0, widget.additionalCategory!);
            }

            if (categorys.isEmpty) {
              return const Error(message: "No Tags Found", error: "");
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    child: const Text("Close"),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                      controller: widget.controller,
                      itemCount: categorys.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final category = categorys[index];
                        final isMinimized =
                            minimizedCategorys.contains(category.category);
                        return Column(children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: InkWell(
                              onTap: () => isMinimized
                                  ? setState(() {
                                      minimizedCategorys
                                          .remove(category.category);
                                    })
                                  : setState(() {
                                      minimizedCategorys.add(category.category);
                                    }),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    category.category,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  isMinimized
                                      ? const Icon(Icons.arrow_drop_down)
                                      : const Icon(Icons.arrow_drop_up)
                                ],
                              ),
                            ),
                          ),
                          if (!isMinimized)
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Wrap(
                                  spacing: 5,
                                  runSpacing: 5,
                                  children: List.generate(category.tags.length,
                                      (index1) {
                                    final isSelected = selectedTags
                                        .contains(category.tags[index1]);
                                    return InkWell(
                                      onTap: () {
                                        isSelected
                                            ? selectedTags
                                                .remove(category.tags[index1])
                                            : selectedTags
                                                .add(category.tags[index1]);
                                        setState(() {
                                          selectedTags;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: isSelected
                                                ? Colors.purple[100]
                                                : Colors.transparent,
                                            border: Border.all(
                                                color: ColorPalette.palette(
                                                        context)
                                                    .secondary),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        child:
                                            Text(category.tags[index1].title),
                                      ),
                                    );
                                  })),
                            ),
                        ]);
                      }),
                ),
                CustomElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.callback!(selectedTags);
                    },
                    text: "Apply")
              ],
            );
          }),
    );
  }
}

// class Category extends StatefulWidget {
//   final CategoryModel category;
//   const Category({Key? key, required this.category}) : super(key: key);

//   @override
//   State<Category> createState() => _CategoryState();
// }

// class _CategoryState extends State<Category> {
//   bool isExpanded = true;
//   @override
//   Widget build(BuildContext context) {
//     final CategoryModel category = widget.category;
//     return Column(children: [
//       Padding(
//         padding: const EdgeInsets.only(top: 10),
//         child: InkWell(
//           onTap: () {
//             setState(() {
//               isExpanded = !isExpanded;
//             });
//           },
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 category.category,
//                 style: const TextStyle(
//                     color: Color(0xFF2f247b),
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500),
//               ),
//               isExpanded
//                   ? const Icon(
//                       Icons.arrow_drop_up,
//                       color: Color(0xFF2f247b),
//                     )
//                   : const Icon(
//                       Icons.arrow_drop_down,
//                       color: Color(0xFF2f247b),
//                     )
//             ],
//           ),
//         ),
//       ),
//       if (isExpanded)
//         Padding(
//           padding: const EdgeInsets.only(top: 10),
//           child: Wrap(
//             spacing: 5,
//             runSpacing: 5,
//             children: List.generate(
//                 category.tags.length,
//                 (index1) => InkWell(
//                       child: Container(
//                         decoration: BoxDecoration(
//                             border: Border.all(color: Colors.purple),
//                             borderRadius: BorderRadius.circular(8)),
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 5, horizontal: 10),
//                         child: Text(category.tags[index1].title),
//                       ),
//                     )),
//           ),
//         ),
//       const Padding(
//         padding: EdgeInsets.only(top: 10),
//         child: Divider(
//           color: Color(0xFF2f247b),
//           thickness: 1,
//           height: 1,
//         ),
//       ),
//     ]);
//   }
// }

Widget buildSheet(BuildContext context, TagsModel selectedTags,
    Function? callback, CategoryModel? additionalCategory) {
  return makeDimissible(
    context: context,
    child: DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.8,
      builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SelectTags(
            selectedTags: selectedTags,
            controller: controller,
            callback: callback,
            additionalCategory: additionalCategory,
          )),
    ),
  );
}

Widget makeDimissible({required Widget child, required BuildContext context}) =>
    GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(),
      child: GestureDetector(
        onTap: () {},
        child: child,
      ),
    );
