import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../graphQL/auth.dart';
import '../../../services/auth.dart';
import '../../../widgets/button/elevated_button.dart';
import '../../../widgets/button/icon_button.dart';
import '../../../widgets/headers/main.dart';
import '../../themes.dart';

class EditPassword extends StatefulWidget {
  final AuthService auth;
  const EditPassword({Key? key, required this.auth}) : super(key: key);

  @override
  State<EditPassword> createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController name = TextEditingController();
  final TextEditingController pass = TextEditingController();
  final TextEditingController confirmPass = TextEditingController();

  bool confirmPassVisible = true;

  // Graphql
  String createEvent = AuthGQL().updateUser;

  @override
  void initState() {
    if (widget.auth.user != null) {
      if (widget.auth.user!.name != null) name.text = widget.auth.user!.name!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Mutation(
                    options: MutationOptions(
                      document: gql(AuthGQL().updatePassword),
                      onCompleted: (dynamic resultData) {
                        if (resultData["updateSuperUser"] == true) {
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
                                    if (widget.auth.user!.id != null) {
                                      Navigator.of(context).pop();
                                    } else {
                                      widget.auth.logout();
                                    }
                                  },
                                )),
                            const SizedBox(height: 100),

                            // Name
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
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: TextFormField(
                                controller: pass,
                                obscureText: true,
                                maxLines: 1,
                                decoration: InputDecoration(
                                    prefixIcon:
                                        const Icon(Icons.password, size: 20),
                                    prefixIconConstraints:
                                        Themes.inputIconConstraints,
                                    labelText: "Password"),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Enter the new password";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: TextFormField(
                                controller: confirmPass,
                                obscureText: confirmPassVisible,
                                maxLines: 1,
                                decoration: InputDecoration(
                                    prefixIcon:
                                        const Icon(Icons.password, size: 20),
                                    suffixIcon: IconButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () => setState(() {
                                        confirmPassVisible =
                                            !confirmPassVisible;
                                      }),
                                      icon: Icon(
                                          confirmPassVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          size: 20),
                                    ),
                                    prefixIconConstraints:
                                        Themes.inputIconConstraints,
                                    suffixIconConstraints:
                                        Themes.inputIconConstraints,
                                    labelText: "Confirm Password"),
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return "Re-enter the password to confirm";
                                  } else if (pass.text != val) {
                                    return "Password don't match";
                                  }
                                  return null;
                                },
                              ),
                            ),

                            if (result != null && result.hasException)
                              SelectableText(result.exception.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                          color: ColorPalette.palette(context)
                                              .error)),

                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: CustomElevatedButton(
                                onPressed: () async {
                                  final isValid =
                                      formKey.currentState!.validate();
                                  FocusScope.of(context).unfocus();

                                  if (isValid) {
                                    runMutation({
                                      "updateSuperUserInput": {
                                        "newPassword": confirmPass.text,
                                        "name": name.text
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
                    }))));
  }
}
