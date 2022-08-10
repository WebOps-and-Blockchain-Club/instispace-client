import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../graphQL/super_user.dart';
import '../../themes.dart';
import '../../widgets/button/elevated_button.dart';
import '../../widgets/button/icon_button.dart';
import '../../widgets/headers/main.dart';
import '../../widgets/helpers/error.dart';
import '../../widgets/text/label.dart';

class CreateHostelPage extends StatefulWidget {
  const CreateHostelPage({Key? key}) : super(key: key);

  @override
  State<CreateHostelPage> createState() => _CreateHostelPageState();
}

class _CreateHostelPageState extends State<CreateHostelPage> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: CustomAppBar(
                title: "Create Hostel",
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
                child: Mutation(
                    options: MutationOptions(
                      document: gql(SuperUserGQL().createHostel),
                      onCompleted: (dynamic resultData) {
                        if (resultData["createHostel"] == true) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('New Hostel Created')),
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
                            const LabelText(text: "Enter the hostel name"),
                            // Email
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: TextFormField(
                                controller: name,
                                decoration: InputDecoration(
                                  labelText: "Hostel Name",
                                  prefixIcon: const Icon(Icons.account_balance,
                                      size: 20),
                                  prefixIconConstraints:
                                      Themes.inputIconConstraints,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Enter the hostel name";
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
                                onPressed: () async {
                                  final isValid =
                                      formKey.currentState!.validate();
                                  FocusScope.of(context).unfocus();
                                  if (isValid) {
                                    runMutation({
                                      'createHostelInput': {
                                        "name": name.text,
                                      }
                                    });
                                  }
                                },
                                text: "Create Hostel",
                                isLoading: result!.isLoading,
                              ),
                            )
                          ],
                        ),
                      );
                    }))));
  }
}
