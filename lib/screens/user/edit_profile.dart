import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'edit_password.dart';
import '../../../graphQL/auth.dart';
import '../../../models/hostel.dart';
import '../../../models/tag.dart';
import '../../../services/auth.dart';
import '../../../widgets/button/elevated_button.dart';
import '../../../widgets/button/icon_button.dart';
import '../../../widgets/form/dropdown_button.dart';
import '../../../widgets/form/text_form_field.dart';
import '../../../widgets/headers/main.dart';
import '../../../widgets/text/label.dart';
import '../home/tag/select_tags.dart';
import '../home/tag/tags_display.dart';

class EditProfile extends StatelessWidget {
  final AuthService auth;
  const EditProfile({Key? key, required this.auth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (auth.user!.role == "USER" || auth.user!.role == "MODERATOR") {
      return EditProfileUser(auth: auth);
    } else {
      return EditPassword(auth: auth);
    }
  }
}

class EditProfileUser extends StatefulWidget {
  final AuthService auth;
  const EditProfileUser({Key? key, required this.auth}) : super(key: key);

  @override
  State<EditProfileUser> createState() => _EditProfileUserState();
}

class _EditProfileUserState extends State<EditProfileUser> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController name = TextEditingController();
  final TextEditingController mobile = TextEditingController();
  String hostel = "None";

  // Graphql
  String createEvent = AuthGQL().updateUser;

  // Variables
  late TagsModel selectedTags = TagsModel.fromJson([]);
  String tagError = "";

  Widget scaffoldBody(QueryResult queryResult,
      Future<QueryResult<Object?>?> Function()? refetch) {
    if (queryResult.hasException) {
      return SelectableText(queryResult.exception.toString());
    }

    if (queryResult.isLoading) {
      return const Text('Loading');
    }

    List<String> hostels =
        HostelsModel.fromJson(queryResult.data!["getHostels"]).getNames();
    hostels.insert(0, "None");

    return Mutation(
        options: MutationOptions(
          document: gql(AuthGQL().updateUser),
          onCompleted: (dynamic resultData) {
            if (resultData["updateUser"] == true) {
              widget.auth.clearUser();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile Updated')),
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
                CustomAppBar(
                    title: "Edit Profile",
                    leading: CustomIconButton(
                      icon: Icons.arrow_back,
                      onPressed: () {
                        if (widget.auth.user!.isNewUser == true) {
                          widget.auth.logout();
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                    )),
                const SizedBox(height: 100),

                /// Info
                const LabelText(text: "Info"),
                // Name
                CustomTextFormField(
                  controller: name,
                  labelText: "Profile Name",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter the name";
                    }
                    return null;
                  },
                ),
                // Mobile Number
                CustomTextFormField(
                    controller: mobile,
                    labelText: "Mobile Number(Optional)",
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    validator: (val) {
                      if (val != null &&
                          val.isNotEmpty &&
                          !isValidNumber("+91$val")) {
                        return "Please enter a valid number";
                      }
                      return null;
                    }),

                // Hostel
                const LabelText(text: "Select Hostel"),
                CustomDropdownButton(
                  value: hostel,
                  items: hostels,
                  onChanged: (value) {
                    setState(() {
                      hostel = value!;
                    });
                  },
                ),

                // Tags
                const LabelText(text: "Select Tags"),
                // Selected Tags
                TagsDisplay(
                    tagsModel: selectedTags,
                    onDelete: (value) => setState(() {
                          selectedTags = value;
                        })),
                if (tagError.isNotEmpty)
                  Text(tagError,
                      style: const TextStyle(color: Colors.red, fontSize: 12)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) => buildSheet(
                            context,
                            selectedTags,
                            (value) {
                              setState(() {
                                selectedTags = value;
                              });
                            },
                            null,
                          ),
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(10)),
                          ),
                        );
                      },
                      text: "Select Tags",
                      backgroundColor: Colors.white,
                      borderColor: const Color(0xFF2f247b),
                      textColor: const Color(0xFF2f247b),
                    ),
                  ],
                ),

                if (result != null && result.hasException)
                  Text(result.exception.toString(),
                      style: const TextStyle(color: Colors.red, fontSize: 12)),

                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: CustomElevatedButton(
                    onPressed: () async {
                      if (selectedTags.tags.isEmpty) {
                        setState(() {
                          tagError = "Tags not selected";
                        });
                      } else if (tagError.isNotEmpty &&
                          selectedTags.tags.isNotEmpty) {
                        setState(() {
                          tagError = "";
                        });
                      }
                      final isValid = formKey.currentState!.validate() &&
                          selectedTags.tags.isNotEmpty;
                      FocusScope.of(context).unfocus();

                      if (isValid) {
                        runMutation({
                          'userInput': {
                            'name': name.text,
                            'interest': selectedTags.getTagIds(),
                            'hostel': hostel,
                          }
                        });
                      }
                    },
                    text: "Save",
                    isLoading: result!.isLoading,
                  ),
                )
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    if (widget.auth.user != null) {
      if (widget.auth.user!.name != null) name.text = widget.auth.user!.name!;
      if (widget.auth.user!.mobile != null) {
        mobile.text = widget.auth.user!.mobile!;
      }
      if (widget.auth.user!.hostelName != null) {
        hostel = widget.auth.user!.hostelName!;
      }
      if (widget.auth.user!.interets != null) {
        setState(() {
          selectedTags = TagsModel(tags: widget.auth.user!.interets!);
        });
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: gql(AuthGQL().getHostel),
        ),
        builder: (QueryResult result, {fetchMore, refetch}) {
          return Scaffold(
              body: SafeArea(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: scaffoldBody(result, refetch))));
        });
  }

  bool isValidNumber(String number) {
    return RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(number);
  }
}
