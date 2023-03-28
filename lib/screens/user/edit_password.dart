import 'package:client/widgets/profile_icon.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'dart:io' as io;

import '../../../graphQL/auth.dart';
import '../../../services/auth.dart';
import '../../../widgets/button/elevated_button.dart';
import '../../../widgets/button/icon_button.dart';
import '../../../widgets/headers/main.dart';
import '../../models/user.dart';
import '../../themes.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/helpers/error.dart';
import '../home/new_post/imageService.dart';

class EditPassword extends StatefulWidget {
  final AuthService auth;
  final UserModel user;
  final bool password;
  final Future<QueryResult<Object?>?> Function()? refetch;

  const EditPassword(
      {Key? key,
      required this.auth,
      required this.user,
      this.refetch,
      required this.password})
      : super(key: key);

  @override
  State<EditPassword> createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController name = TextEditingController();
  final TextEditingController pass = TextEditingController();
  final TextEditingController confirmPass = TextEditingController();
  io.File? image;
  String photoUrl = '';

  bool confirmPassVisible = true;
  bool isLoading = false;

  // Graphql
  String createEvent = AuthGQL().updateUser;

  //Controllers
  final ScrollController _scrollController = ScrollController();

  final imageService = ImageService();

  @override
  void initState() {
    if (widget.user.name != null) name.text = widget.user.name!;
    if (widget.user.photo != '') photoUrl = widget.user.photo;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: NestedScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              secondaryAppBar(
                  title: widget.password ? 'CHANGE PASSWORD' : 'EDIT PROFILE')
            ];
          },
          body: Mutation(
              options: MutationOptions(
                document: gql(AuthGQL().updateUser),
                onCompleted: (dynamic resultData) {
                  if (resultData["updateUser"] == true) {
                    if (widget.refetch != null) widget.refetch!();
                    // Navigator.pop(context);
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        // Profile
                        if (image == null)
                          ProfileIconWidget(
                            photo: photoUrl,
                            size: 100,
                          ),
                        if (image != null)
                          ProfileIconWidget(
                            photo: image?.path ?? '',
                            size: 100,
                            type: 'file',
                          ),
                        if (!widget.password)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomElevatedButton(
                                  color: Colors.white,
                                  leading: Icons.camera_alt,
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                            title: const Text('Choose Images'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                TextButton(
                                                    onPressed: () async {
                                                      final io.File? photo =
                                                          await imageService
                                                              .pickCamera();
                                                      setState(() {
                                                        if (photo != null) {
                                                          image = photo;
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                      });
                                                    },
                                                    child:
                                                        const Text('Camera')),
                                                TextButton(
                                                    onPressed: () async {
                                                      final List<io.File>
                                                          photos =
                                                          await imageService
                                                              .pickGalley();

                                                      if (photos.isNotEmpty) {
                                                        setState(() {
                                                          image = photos.last;
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      }
                                                    },
                                                    child:
                                                        const Text('Gallegy')),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        child: const Text(
                                                            "Cancel"))
                                                  ],
                                                )
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                  textColor: Colors.black,
                                  text: photoUrl == '' && image == null
                                      ? 'Add Profile Photo'
                                      : 'Edit Profile Photo'),
                            ],
                          ),

                        // Name
                        if (!widget.password)
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: TextFormField(
                              controller: name,
                              decoration: const InputDecoration(
                                  labelText: "Profile Name"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter the name";
                                }
                                return null;
                              },
                            ),
                          ),

                        // Password
                        if (widget.password || widget.user.isNewUser)
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: TextFormField(
                              controller: pass,
                              obscureText: true,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                  labelText: "New Password"),
                            ),
                          ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 10),
                        //   child: TextFormField(
                        //     controller: confirmPass,
                        //     obscureText: confirmPassVisible,
                        //     maxLines: 1,
                        //     decoration: InputDecoration(
                        //         suffixIcon: IconButton(
                        //           padding: EdgeInsets.zero,
                        //           onPressed: () => setState(() {
                        //             confirmPassVisible =
                        //                 !confirmPassVisible;
                        //           }),
                        //           icon: Icon(
                        //               confirmPassVisible
                        //                   ? Icons.visibility
                        //                   : Icons.visibility_off,
                        //               size: 20),
                        //         ),
                        //         prefixIconConstraints:
                        //             Themes.inputIconConstraints,
                        //         suffixIconConstraints:
                        //             Themes.inputIconConstraints,
                        //         labelText: "Confirm Password"),
                        //     validator: (val) {
                        //       if (val == null || val.isEmpty) {
                        //         return "Re-enter the password to confirm";
                        //       } else if (pass.text != val) {
                        //         return "Password don't match";
                        //       }
                        //       return null;
                        //     },
                        //   ),
                        // ),

                        if (result != null && result.hasException)
                          ErrorText(error: result.exception.toString()),

                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: CustomElevatedButton(
                            onPressed: () async {
                              final isValid = formKey.currentState!.validate();
                              FocusScope.of(context).unfocus();

                              if (isValid) {
                                List<String>? uploadResult;
                                if (image != null) {
                                  setState(() {
                                    isLoading = true;
                                  });

                                  try {
                                    uploadResult =
                                        await imageService.upload([image]);
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
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
                                }

                                runMutation({
                                  "userInput": {
                                    "name": name.text,
                                    "photo":
                                        uploadResult?.join(" AND ") ?? photoUrl,
                                    "password":
                                        pass.text.isEmpty ? null : pass.text
                                  }
                                });
                              }
                            },
                            text: "Save",
                            isLoading: result!.isLoading || isLoading,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              })),
    )));
  }
}
