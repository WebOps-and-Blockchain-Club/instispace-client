import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../../../graphQL/query.dart';
import '../../../services/image_picker.dart';
import '../../../models/query.dart';
import '../../../themes.dart';
import '../../../widgets/button/elevated_button.dart';
import '../../../widgets/button/icon_button.dart';
import '../../../widgets/headers/main.dart';
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

  @override
  void initState() {
    if (widget.query != null) {
      name.text = widget.query!.title;
      description.text = widget.query!.description;
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
                // TODO: update cache

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
              const SnackBar(content: Text('Creation Failed, Server Error')),
            );
          },
        ),
        builder: (
          RunMutation runMutation,
          QueryResult? result,
        ) {
          return ChangeNotifierProvider(
            create: (_) => ImagePickerService(),
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
                                const LabelText(text: "Attachements"),
                                // Selected Image
                                imagePickerService.previewImages(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    imagePickerService.pickImageButton(context),
                                  ],
                                ),

                                if (result != null && result.hasException)
                                  SelectableText(result.exception.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              color:
                                                  ColorPalette.palette(context)
                                                      .error)),

                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: CustomElevatedButton(
                                    onPressed: () async {
                                      final isValid =
                                          formKey.currentState!.validate();

                                      FocusScope.of(context).unfocus();

                                      if (isValid) {
                                        List<MultipartFile>? image =
                                            await imagePickerService
                                                .getMultipartFiles();
                                        if (widget.query != null) {
                                          runMutation({
                                            'editMyQuerysData': {
                                              "title": name.text,
                                              "content": description.text,
                                              "imageUrls": description.text,
                                            },
                                            'attachments': image,
                                            'id': widget.query!.id,
                                          });
                                        } else {
                                          runMutation({
                                            'createQuerysInput': {
                                              "title": name.text,
                                              "content": description.text,
                                            },
                                            'attachments': image,
                                          });
                                        }
                                      }
                                    },
                                    text: widget.query != null
                                        ? "Edit Query"
                                        : "Create Query",
                                    isLoading: result!.isLoading,
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
