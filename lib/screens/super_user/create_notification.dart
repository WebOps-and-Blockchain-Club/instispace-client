import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import '../../../widgets/helpers/error.dart';
import '../../../services/image_picker.dart';
import '../../../themes.dart';
import '../../../widgets/headers/main.dart';
import '../../../widgets/button/elevated_button.dart';
import '../../../widgets/button/icon_button.dart';
import '../../../widgets/text/label.dart';
import '../../widgets/buttom_sheet/main.dart';
import '../../graphQL/notification.dart';

class CreateNotification extends StatefulWidget {
  const CreateNotification({Key? key}) : super(key: key);

  @override
  State<CreateNotification> createState() => _CreateNotificationState();
}

class _CreateNotificationState extends State<CreateNotification> {
  //Keys
  final formKey = GlobalKey<FormState>();

  //Controllers
  final title = TextEditingController();
  final description = TextEditingController();
  final roll = TextEditingController();

  // Graphql
  String createNotification = NotificationGQL.createNotification;

  // Variables
  List<String>? imageUrls;
  late List<String> selectedRoles = [];
  String rolesError = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Mutation(
        options: MutationOptions(
            document: gql(createNotification),
            update: (cache, result) {
              if (result != null && (!result.hasException)) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notification Sent')),
                );
              }
            },
            onError: (dynamic error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text(formatErrorMessage(error.toString(), context))),
              );
            }),
        builder: (
          RunMutation runMutation,
          QueryResult? result,
        ) {
          return ChangeNotifierProvider(
            create: (_) => ImagePickerService(),
            child: Consumer<ImagePickerService>(
                builder: (context, imagePickerService, child) {
              return Scaffold(
                body: SafeArea(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Form(
                    key: formKey,
                    child: ListView(
                      children: [
                        CustomAppBar(
                            title: "Create Notification",
                            leading: CustomIconButton(
                              icon: Icons.arrow_back,
                              onPressed: () => Navigator.of(context).pop(),
                            )),

                        /// Title
                        const LabelText(
                            text: "Title(Recommended character limit of 50)"),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: TextFormField(
                            controller: title,
                            maxLength: 50,
                            minLines: 1,
                            maxLines: null,
                            decoration:
                                const InputDecoration(labelText: "Title"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter the title of the post";
                              }
                              return null;
                            },
                          ),
                        ),
                        // Description
                        const LabelText(
                            text:
                                "Description(Recommended character limit: If the image is present 50, else 200)"),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: SingleChildScrollView(
                            child: TextFormField(
                              controller: description,
                              maxLength: 200,
                              minLines: 3,
                              maxLines: null,
                              decoration: const InputDecoration(
                                  labelText: "Description"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter the description of the post";
                                }
                                return null;
                              },
                            ),
                          ),
                        ),

                        // Roll Numbers
                        const LabelText(text: "To specific user(Optional)"),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: TextFormField(
                            controller: roll,
                            maxLength: 100,
                            minLines: 1,
                            maxLines: null,
                            decoration:
                                const InputDecoration(labelText: "Roll Number"),
                          ),
                        ),

                        // Images & Tags
                        const LabelText(
                            text:
                                "Image & Roles (Select maximum of 1 image(Appropriate image size 720px (Width) x 240px (Height)) & minimum of 1 roles)"),
                        // Selected Image
                        imagePickerService.previewImages(
                            imageUrls: imageUrls,
                            removeImageUrl: (value) {
                              setState(() {
                                imageUrls!.removeAt(value);
                              });
                            }),
                        // Selected Roles
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Wrap(
                            spacing: 5,
                            runSpacing: 5,
                            children:
                                List.generate(selectedRoles.length, (index) {
                              return Chip(
                                label: Text(selectedRoles[index]),
                                padding: const EdgeInsets.all(4),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                deleteIcon: const Icon(Icons.close, size: 20),
                                onDeleted: () {
                                  selectedRoles.remove(selectedRoles[index]);
                                  setState(() {
                                    selectedRoles = selectedRoles;
                                  });
                                },
                              );
                            }),
                          ),
                        ),
                        if (rolesError.isNotEmpty)
                          Text(rolesError,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 12)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            imagePickerService.pickImageButton(
                              context: context,
                              preSelectedNoOfImages:
                                  imageUrls != null ? imageUrls!.length : 0,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            CustomElevatedButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) => buildSheet(
                                      context,
                                      (controller) => SelectRoles(
                                            selectedRoles: selectedRoles,
                                            controller: controller,
                                            callback: (value) {
                                              setState(() {
                                                selectedRoles = value;
                                              });
                                            },
                                          )),
                                  isScrollControlled: true,
                                );
                              },
                              text: "Select Roles",
                              color: ColorPalette.palette(context).primary,
                              type: ButtonType.outlined,
                            ),
                          ],
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              Expanded(
                                  child: CustomElevatedButton(
                                onPressed: () async {
                                  if (selectedRoles.isEmpty) {
                                    setState(() {
                                      rolesError = "Roles not selected";
                                    });
                                  } else if (rolesError.isNotEmpty &&
                                      selectedRoles.isNotEmpty) {
                                    setState(() {
                                      rolesError = "";
                                    });
                                  }
                                  final isValid =
                                      formKey.currentState!.validate() &&
                                          selectedRoles.isNotEmpty;
                                  FocusScope.of(context).unfocus();

                                  if (isValid) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    List<String> uploadResult = [];
                                    try {
                                      uploadResult = await imagePickerService
                                          .uploadImage();
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              const Text('Image Upload Failed'),
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

                                    runMutation({
                                      "notificationData": {
                                        "title": title.text,
                                        "roles": selectedRoles,
                                        "rolls": roll.text.isNotEmpty
                                            ? roll.text.split(",")
                                            : [],
                                        "body": description.text,
                                        "imageUrl": uploadResult.isEmpty
                                            ? ''
                                            : uploadResult[0]
                                      },
                                    });
                                  }
                                },
                                text: "Send Notification",
                                isLoading: result!.isLoading || isLoading,
                              ))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )),
              );
            }),
          );
        });
  }
}

class SelectRoles extends StatefulWidget {
  final List<String> selectedRoles;
  final ScrollController controller;
  final Function? callback;
  const SelectRoles({
    Key? key,
    required this.selectedRoles,
    required this.controller,
    this.callback,
  }) : super(key: key);

  @override
  State<SelectRoles> createState() => _SelectRolesState();
}

class _SelectRolesState extends State<SelectRoles> {
  late List<String> selectedRoles;
  List<String> minimizedCategorys = [];
  final roles = [
    "SECRETARY",
    "HAS",
    "LEADS",
    "HOSTEL_SEC",
    "MODERATOR",
    "USER"
  ];

  @override
  void initState() {
    selectedRoles = widget.selectedRoles;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
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
              child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Wrap(
                spacing: 5,
                runSpacing: 5,
                children: List.generate(roles.length, (index) {
                  final isSelected = selectedRoles.contains(roles[index]);
                  return InkWell(
                    onTap: () {
                      isSelected
                          ? selectedRoles.remove(roles[index])
                          : selectedRoles.add(roles[index]);
                      setState(() {
                        selectedRoles;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.purple[100]
                              : Colors.transparent,
                          border: Border.all(
                              color: ColorPalette.palette(context).secondary),
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: Text(roles[index]),
                    ),
                  );
                })),
          )),
          CustomElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.callback!(selectedRoles);
              },
              text: "Apply")
        ],
      ),
    );
  }
}
