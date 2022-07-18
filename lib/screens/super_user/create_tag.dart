import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../themes.dart';
import '../../graphQL/super_user.dart';
import '../../widgets/button/elevated_button.dart';
import '../../widgets/button/icon_button.dart';
import '../../widgets/form/dropdown_button.dart';
import '../../widgets/headers/main.dart';
import '../../widgets/text/label.dart';

class CreateTagPage extends StatefulWidget {
  const CreateTagPage({Key? key}) : super(key: key);

  @override
  State<CreateTagPage> createState() => _CreateTagPageState();
}

class _CreateTagPageState extends State<CreateTagPage> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController name = TextEditingController();
  String? selectedCategory;
  String? categoryError;

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: gql(SuperUserGQL().getCategories),
        ),
        builder: (QueryResult queryResult, {fetchMore, refetch}) {
          return Scaffold(
              appBar: AppBar(
                  title: CustomAppBar(
                      title: "Create Tag",
                      leading: CustomIconButton(
                        icon: Icons.arrow_back,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )),
                  automaticallyImplyLeading: false),
              body: SafeArea(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: (() {
                        if (queryResult.hasException) {
                          return SelectableText(
                              queryResult.exception.toString());
                        }

                        if (queryResult.isLoading) {
                          return const Text('Loading');
                        }
                        List<String>? categories = [];
                        for (var i = 0;
                            i < queryResult.data!["getCategories"].length;
                            i++) {
                          categories.add(queryResult.data!["getCategories"][i]);
                        }
                        return Mutation(
                            options: MutationOptions(
                              document: gql(SuperUserGQL().createTag),
                              onCompleted: (dynamic resultData) {
                                if (resultData["createTag"] == true) {
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Tag Created')),
                                  );
                                }
                              },
                            ),
                            builder: (
                              RunMutation runMutation,
                              QueryResult? result,
                            ) {
                              return Form(
                                key: formKey,
                                child: ListView(
                                  shrinkWrap: true,
                                  children: [
                                    const SizedBox(height: 10),

                                    /// Info
                                    const LabelText(
                                        text: "Select Tag Category"),
                                    CustomDropdownButton(
                                      value: selectedCategory,
                                      items: categories,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedCategory = value!;
                                        });
                                      },
                                    ),
                                    if (categoryError != null &&
                                        categoryError!.isNotEmpty)
                                      Text(categoryError!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                  color: ColorPalette.palette(
                                                          context)
                                                      .error,
                                                  fontSize: 12)),

                                    // Name
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: TextFormField(
                                        controller: name,
                                        decoration: const InputDecoration(
                                            labelText: "Tag Name"),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Enter the tag name";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),

                                    if (result != null && result.hasException)
                                      SelectableText(
                                          result.exception.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                  color: ColorPalette.palette(
                                                          context)
                                                      .error)),

                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: CustomElevatedButton(
                                        onPressed: () async {
                                          if (selectedCategory == null ||
                                              selectedCategory!.isEmpty) {
                                            setState(() {
                                              categoryError =
                                                  "Category not selected";
                                            });
                                          } else if (selectedCategory!
                                                  .isNotEmpty &&
                                              categoryError != null &&
                                              categoryError!.isNotEmpty) {
                                            setState(() {
                                              categoryError = "";
                                            });
                                          }
                                          final isValid = formKey.currentState!
                                                  .validate() &&
                                              selectedCategory != null &&
                                              selectedCategory!.isNotEmpty;
                                          FocusScope.of(context).unfocus();

                                          if (isValid) {
                                            runMutation({
                                              'tagInput': {
                                                "title": name.text,
                                                "category": selectedCategory,
                                              }
                                            });
                                          }
                                        },
                                        text: "Create Tag",
                                        isLoading: result!.isLoading,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            });
                      }()))));
        });
  }
}
