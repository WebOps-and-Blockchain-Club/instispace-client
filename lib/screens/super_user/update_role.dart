import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../themes.dart';
import '../../widgets/helpers/error.dart';
import '../../graphQL/super_user.dart';
import '../../utils/validation.dart';
import '../../widgets/button/elevated_button.dart';
import '../../widgets/button/icon_button.dart';
import '../../widgets/headers/main.dart';
import '../../widgets/text/label.dart';

class UpdateRolePage extends StatefulWidget {
  const UpdateRolePage({Key? key}) : super(key: key);

  @override
  State<UpdateRolePage> createState() => _UpdateRolePageState();
}

class _UpdateRolePageState extends State<UpdateRolePage> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Mutation(
        options: MutationOptions(
          document: gql(SuperUserGQL().updateRole),
          onCompleted: (dynamic resultData) {
            if (resultData["updateRole"] == true) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Moderator Appointed')),
              );
            }
          },
        ),
        builder: (
          RunMutation runMutation,
          QueryResult? result,
        ) {
          return Scaffold(
              appBar: AppBar(
                  title: CustomAppBar(
                      title: "Appoint Moderator",
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
                        const LabelText(text: "Roll Number"),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: TextFormField(
                            controller: name,
                            decoration: InputDecoration(
                              labelText: "Roll Number",
                              prefixIcon: const Icon(Icons.person, size: 20),
                              prefixIconConstraints:
                                  Themes.inputIconConstraints,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter the roll number";
                              } else if (!isValidRoll(
                                  value.toUpperCase().trim())) {
                                return "Enter the valid roll number";
                              }
                              return null;
                            },
                          ),
                        ),
                        if (result != null && result.hasException)
                          ErrorText(error: result.exception.toString()),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: CustomElevatedButton(
                            onPressed: () {
                              final isValid = formKey.currentState!.validate();
                              FocusScope.of(context).unfocus();

                              if (isValid) {
                                runMutation({
                                  'moderatorInput': {
                                    "roll": name.text.toLowerCase(),
                                  }
                                });
                              }
                            },
                            text: "Appoint Moderator",
                            isLoading: result!.isLoading,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ));
        });
  }
}
