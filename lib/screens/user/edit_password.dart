import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../graphQL/auth.dart';
import '../../../services/auth.dart';
import '../../../widgets/button/elevated_button.dart';
import '../../../widgets/button/icon_button.dart';
import '../../../widgets/form/text_form_field.dart';
import '../../../widgets/headers/main.dart';
import '../../../widgets/text/label.dart';

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
                            // Password
                            CustomTextFormField(
                                controller: pass,
                                labelText: "Password",
                                prefixIcon: Icons.password,
                                isDense: false,
                                obscureText: true,
                                maxLines: 1,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Enter the new password";
                                  }
                                  return null;
                                }),
                            CustomTextFormField(
                                controller: confirmPass,
                                labelText: "Confirm Password",
                                prefixIcon: Icons.password,
                                isDense: false,
                                obscureText: confirmPassVisible,
                                maxLines: 1,
                                suffixIcon: confirmPassVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                suffixIconPressed: () => setState(() {
                                      confirmPassVisible = !confirmPassVisible;
                                    }),
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return "Re-enter the password to confirm";
                                  } else if (pass.text != val) {
                                    return "Password don't match";
                                  }
                                  return null;
                                }),

                            if (result != null && result.hasException)
                              Text(result.exception.toString(),
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 12)),

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

  bool isValidNumber(String number) {
    return RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(number);
  }
}
