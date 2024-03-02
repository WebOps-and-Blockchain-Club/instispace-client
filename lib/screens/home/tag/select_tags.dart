import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../models/tag.dart';
import '../../../graphQL/tag.dart';
import '../../../widgets/button/elevated_button.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Query(
          options: QueryOptions(
            document: gql(TagGQL().getAll),
          ),
          builder: (QueryResult result, {fetchMore, refetch}) {
            if (result.hasException && result.data == null) {
              return Error(
                error: result.exception.toString(),
                onRefresh: refetch,
              );
            }

            if (result.hasException && result.data != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                // Use Future.delayed to delay the execution of showDialog
                Future.delayed(Duration.zero, () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Center(child: Text("Error")),
                        content: Text(formatErrorMessage(
                            result.exception.toString(), context)),
                        actions: [
                          TextButton(
                            child: const Text("Ok"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: const Text("Retry"),
                            onPressed: () {
                              refetch!();
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                });
              });
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
              return Center(
                child: Error(
                  message: "No Tags Found",
                  error: "",
                  onRefresh: refetch,
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView.builder(
                      controller: widget.controller,
                      itemCount: categorys.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final category = categorys[index];
                        final isMinimized =
                            minimizedCategorys.contains(category.category);
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: InkWell(
                                  onTap: () => isMinimized
                                      ? setState(() {
                                          minimizedCategorys
                                              .remove(category.category);
                                        })
                                      : setState(() {
                                          minimizedCategorys
                                              .add(category.category);
                                        }),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Text(
                                          category.category,
                                          style: TextStyle(
                                              color: Theme.of(context).brightness == Brightness.dark ? Color.fromARGB(209, 255, 255, 255) : Color(0xFF3C3C3C),
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500),
                                        ),
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
                                      children: List.generate(
                                          category.tags.length, (index1) {
                                        final isSelected = selectedTags
                                            .contains(category.tags[index1]);
                                        return InkWell(
                                          onTap: () {
                                            isSelected
                                                ? selectedTags.remove(
                                                    category.tags[index1])
                                                : selectedTags
                                                    .add(category.tags[index1]);
                                            setState(() {
                                              selectedTags;
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: isSelected
                                                    ? const Color(0xFFE1E0EC)
                                                    : Colors.transparent,
                                                border: Border.all(
                                                    color: const Color(
                                                        0xFFE1E0EC)),
                                                borderRadius:
                                                    BorderRadius.circular(17)),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 6, horizontal: 11),
                                            child: Text(
                                                category.tags[index1].title,
                                                style: TextStyle(
                                                    color: Theme.of(context).brightness == Brightness.dark ? Color.fromARGB(209, 255, 255, 255) : Color(0xFF3C3C3C))),
                                          ),
                                        );
                                      })),
                                ),
                            ]);
                      }),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  child: CustomElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        widget.callback!(selectedTags);
                      },
                      padding: const [27, 16],
                      text: "Apply"),
                )
              ],
            );
          }),
    );
  }
}
