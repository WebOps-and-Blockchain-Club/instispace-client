import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../models/user.dart';
import '../../utils/validation.dart';
import '../../widgets/buttom_sheet/main.dart';
import '../../widgets/helpers/error.dart';
import '../../widgets/helpers/loading.dart';
import 'edit_password.dart';
import '../../../graphQL/auth.dart';
import '../../../models/hostel.dart';
import '../../../models/tag.dart';
import '../../../services/auth.dart';
import '../../../widgets/button/elevated_button.dart';
import '../../../widgets/button/icon_button.dart';
import '../../../widgets/form/dropdown_button.dart';
import '../../../widgets/headers/main.dart';
import '../../../widgets/text/label.dart';
import '../home/tag/select_tags.dart';
import '../home/tag/tags_display.dart';
import '../../themes.dart';

class EditProfile extends StatelessWidget {
  final AuthService auth;
  final UserModel user;
  final Future<QueryResult<Object?>?> Function()? refetch;

  const EditProfile(
      {Key? key, required this.auth, required this.user, this.refetch})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (user.role == "USER" || user.role == "MODERATOR") {
      return EditProfileUser(
        auth: auth,
        user: user,
        refetch: refetch,
      );
    } else {
      return EditPassword(
        auth: auth,
        user: user,
        refetch: refetch,
      );
    }
  }
}

class EditProfileUser extends StatefulWidget {
  final AuthService auth;
  final UserModel user;
  final Future<QueryResult<Object?>?> Function()? refetch;

  const EditProfileUser(
      {Key? key, required this.auth, required this.user, this.refetch})
      : super(key: key);

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
      return Error(error: queryResult.exception.toString());
    }

    if (queryResult.isLoading) {
      return const Loading();
    }

    List<String> hostels =
        HostelsModel.fromJson(queryResult.data!["getHostels"]).getNames();
    hostels.insert(0, "None");

    return Mutation(
        options: MutationOptions(
          document: gql(AuthGQL().updateUser),
          onCompleted: (dynamic resultData) {
            if (resultData["updateUser"] == true) {
              if (widget.refetch != null) widget.refetch!();
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
                        if (widget.user.isNewUser == true) {
                          widget.auth.logout();
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                    )),
                const SizedBox(height: 20),
                CachedNetworkImage(
                  imageUrl: widget.user.photo,
                  placeholder: (_, __) =>
                      const Icon(Icons.account_circle_rounded, size: 100),
                  errorWidget: (_, __, ___) =>
                      const Icon(Icons.account_circle_rounded, size: 100),
                  imageBuilder: (context, imageProvider) => Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                /// Info
                const LabelText(text: "Info"),
                // Name
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: TextFormField(
                    controller: name,
                    decoration:
                        const InputDecoration(labelText: "Profile Name"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter the name";
                      }
                      return null;
                    },
                  ),
                ),
                // Mobile Number
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: TextFormField(
                    controller: mobile,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: "Mobile Number (Optional)", counterText: ""),
                    maxLength: 10,
                    validator: (val) {
                      if (val != null &&
                          val.isNotEmpty &&
                          (!isValidNumber(val) || val.length != 10)) {
                        return "Please enter a valid number";
                      }
                      return null;
                    },
                  ),
                ),

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
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: ColorPalette.palette(context).error,
                          fontSize: 12)),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) => buildSheet(
                              context,
                              (controller) => SelectTags(
                                  selectedTags: selectedTags,
                                  controller: controller,
                                  callback: (val) {
                                    setState(() {
                                      selectedTags = val;
                                    });
                                  })),
                          isScrollControlled: true,
                        );
                      },
                      text: "Select Tags",
                      color: ColorPalette.palette(context).primary,
                      type: ButtonType.outlined,
                    ),
                  ],
                ),

                if (result != null && result.hasException)
                  ErrorText(error: result.exception.toString()),

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
                            'mobile': mobile.text == "" ? null : mobile.text,
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
    if (widget.user.name != null) name.text = widget.user.name!;
    if (widget.user.mobile != null) {
      mobile.text = widget.user.mobile!;
    }
    if (widget.user.hostelName != null) {
      hostel = widget.user.hostelName!;
    }
    if (widget.user.interets != null) {
      setState(() {
        selectedTags = TagsModel(tags: widget.user.interets!);
      });
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
}
