import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../../../graphQL/query.dart';
import '../../../services/image_picker.dart';
import '../../../models/query.dart';
import '../../../widgets/button/elevated_button.dart';
import '../../../widgets/button/icon_button.dart';
import '../../../widgets/form/warning_popup.dart';
import '../../../widgets/headers/main.dart';
import '../../../widgets/helpers/error.dart';
import '../../../widgets/text/label.dart';

class NewQueryPage extends StatefulWidget {
  final EditQueryModel? query;
  final QueryOptions<Object?> options;

  const NewQueryPage({Key? key, this.query, required this.options})
      : super(key: key);

  @override
  State<NewQueryPage> createState() => _NewQueryPageState();
}

class _NewQueryPageState extends State<NewQueryPage> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController name = TextEditingController();
  final TextEditingController description = TextEditingController();

  List<String>? imageUrls;
  bool isLoading = false;

  @override
  void initState() {
    if (widget.query != null) {
      name.text = widget.query!.title;
      description.text = widget.query!.description;
      setState(() {
        imageUrls = widget.query!.images;
      });
    }
    if (widget.query == null) {
      Future.delayed(Duration.zero, () => showWarningAlert(context));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Mutation(
        options: MutationOptions(
          document: gql(widget.query != null ? QueryGQL.edit : QueryGQL.create),
          update: (cache, result) {
            if (result != null && (!result.hasException)) {
              if (widget.query != null) {
                cache.writeFragment(
                  Fragment(document: gql(QueryGQL.editFragment))
                      .asRequest(idFields: {
                    '__typename': "MyQuery",
                    'id': widget.query!.id,
                  }),
                  data: result.data!["editMyQuery"],
                  broadcast: false,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Edited Successfully')),
                );
              } else {
                dynamic data = cache.readQuery(widget.options.asRequest);
                data["getMyQuerys"]["queryList"] = [
                      result.data!["createMyQuery"]
                    ] +
                    data["getMyQuerys"]["queryList"];
                data["getMyQuerys"]["total"] = data["getMyQuerys"]["total"] + 1;
                cache.writeQuery(widget.options.asRequest, data: data);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Created Successfully')),
                );
              }
            }
          },
          onError: (dynamic error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(formatErrorMessage(error.toString()))),
            );
          },
        ),
        builder: (
          RunMutation runMutation,
          QueryResult? result,
        ) {
          return ChangeNotifierProvider(
            create: (_) => ImagePickerService(noOfImages: 2),
            child: Consumer<ImagePickerService>(
                builder: (context, imagePickerService, child) {
              return Scaffold(
                  appBar: AppBar(
                      title: CustomAppBar(
                          title: widget.query != null
                              ? "Edit Query"
                              : "Create Query",
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
                          child: Form(
                            key: formKey,
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                const SizedBox(height: 10),

                                // Name
                                const LabelText(text: "Query title"),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: TextFormField(
                                    controller: name,
                                    maxLength: 40,
                                    minLines: 1,
                                    maxLines: null,
                                    decoration: const InputDecoration(
                                      labelText: "Title",
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Enter the query title";
                                      }
                                      return null;
                                    },
                                  ),
                                ),

                                // Description
                                const LabelText(text: "Query Description"),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: TextFormField(
                                    controller: description,
                                    maxLength: 3000,
                                    minLines: 3,
                                    maxLines: 8,
                                    decoration: const InputDecoration(
                                      labelText: "Description",
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Enter the query description";
                                      }
                                      return null;
                                    },
                                  ),
                                ),

                                // Attachements
                                const LabelText(
                                    text:
                                        "Attachements (Select maximum of 2 images)"),
                                // Selected Image
                                imagePickerService.previewImages(
                                    imageUrls: imageUrls,
                                    removeImageUrl: (value) {
                                      setState(() {
                                        imageUrls!.removeAt(value);
                                      });
                                    }),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    imagePickerService.pickImageButton(
                                      context: context,
                                      preSelectedNoOfImages: imageUrls != null
                                          ? imageUrls!.length
                                          : 0,
                                    ),
                                  ],
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: CustomElevatedButton(
                                    onPressed: () async {
                                      final isValid =
                                          formKey.currentState!.validate();

                                      FocusScope.of(context).unfocus();

                                      if (isValid) {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        List<String> uploadResult;
                                        try {
                                          uploadResult =
                                              await imagePickerService
                                                  .uploadImage();
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: const Text(
                                                  'Image Upload Failed'),
                                              backgroundColor:
                                                  Theme.of(context).errorColor,
                                            ),
                                          );
                                          setState(() {
                                            isLoading = false;
                                          });
                                          return;
                                        }
                                        setState(() {
                                          isLoading = false;
                                        });
                                        if (widget.query != null) {
                                          runMutation({
                                            'editMyQuerysData': {
                                              "title": name.text,
                                              "content": description.text,
                                              "imageUrls": (imageUrls ?? []) +
                                                  uploadResult,
                                            },
                                            'id': widget.query!.id,
                                          });
                                        } else {
                                          runMutation({
                                            'createQuerysInput': {
                                              "title": name.text,
                                              "content": description.text,
                                              "imageUrls": uploadResult,
                                            },
                                          });
                                        }
                                      }
                                    },
                                    text: widget.query != null
                                        ? "Edit Query"
                                        : "Create Query",
                                    isLoading: result!.isLoading || isLoading,
                                  ),
                                )
                              ],
                            ),
                          ))));
            }),
          );
        });
  }
}
