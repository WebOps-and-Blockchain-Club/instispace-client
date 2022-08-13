import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../graphQL/auth.dart';
import '../../graphQL/super_user.dart';
import '../../models/hostel.dart';
import '../../themes.dart';
import '../../utils/validation.dart';
import '../../widgets/button/elevated_button.dart';
import '../../widgets/button/icon_button.dart';
import '../../widgets/form/dropdown_button.dart';
import '../../widgets/headers/main.dart';
import '../../widgets/helpers/error.dart';
import '../../widgets/text/label.dart';

class CreateAccountPage extends StatefulWidget {
  final String role;

  const CreateAccountPage({Key? key, required this.role}) : super(key: key);

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  HostelsModel? hostels;
  late final List<String> roleList;

  final formKey = GlobalKey<FormState>();

  final TextEditingController name = TextEditingController();
  final TextEditingController mobile = TextEditingController();
  String selectedRole = "";
  String? selectedHostel;

  String roleError = "";
  String hostelError = "";

  List<String> getRole(role) {
    switch (role) {
      case "ADMIN":
        return ["SECRETARY", "HAS", "LEADS", "HOSTEL_SEC"];
      case "SECRETARY":
        return ["LEADS"];
      case "HAS":
        return ["HOSTEL_SEC"];
      default:
        return [];
    }
  }

  @override
  void initState() {
    roleList = getRole(widget.role);
    selectedRole = roleList[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: CustomAppBar(
                title: "Create Account",
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
                      document: gql(SuperUserGQL().createAccount),
                      onCompleted: (dynamic resultData) {
                        if (resultData["createAccount"] == true) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Account Created and mail is seny to the respective email id')),
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
                            const LabelText(
                                text:
                                    "Enter the email for creating the account"),
                            // Email
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: TextFormField(
                                controller: name,
                                decoration: InputDecoration(
                                  labelText: "Email ID",
                                  prefixIcon:
                                      const Icon(Icons.person, size: 20),
                                  prefixIconConstraints:
                                      Themes.inputIconConstraints,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Enter the email id";
                                  } else if (!isValidEmail(value.trim())) {
                                    return "Enter the valid email";
                                  }
                                  return null;
                                },
                              ),
                            ),

                            const LabelText(text: "Select Role"),
                            CustomDropdownButton(
                              value: selectedRole,
                              items: roleList,
                              onChanged: (value) {
                                setState(() {
                                  selectedRole = value!;
                                });
                              },
                            ),

                            // Hostel
                            if (selectedRole == "HOSTEL_SEC")
                              const LabelText(text: "Select Hostel"),
                            if (selectedRole == "HOSTEL_SEC")
                              Query(
                                  options: QueryOptions(
                                    document: gql(AuthGQL().getHostel),
                                  ),
                                  builder: (QueryResult queryResult,
                                      {fetchMore, refetch}) {
                                    if (queryResult.hasException) {
                                      return SelectableText(
                                          queryResult.exception.toString());
                                    }

                                    if (queryResult.isLoading) {
                                      return const Text('Loading');
                                    }

                                    hostels = HostelsModel.fromJson(
                                        queryResult.data!["getHostels"]);
                                    List<String> hostelNames =
                                        HostelsModel.fromJson(
                                                queryResult.data!["getHostels"])
                                            .getNames();
                                    return CustomDropdownButton(
                                      value: selectedHostel,
                                      items: hostelNames,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedHostel = value!;
                                        });
                                      },
                                    );
                                  }),

                            if (hostelError.isNotEmpty &&
                                selectedRole == "HOSTEL_SEC")
                              Text(hostelError,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                          color: ColorPalette.palette(context)
                                              .error,
                                          fontSize: 12)),

                            if (result != null && result.hasException)
                              ErrorText(error: result.exception.toString()),

                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: CustomElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    hostelError = (selectedHostel == null ||
                                            selectedHostel!.isEmpty)
                                        ? "Select the hostel to create account"
                                        : "";
                                  });
                                  final isValid =
                                      formKey.currentState!.validate() &&
                                          !((selectedHostel == null ||
                                                  selectedHostel!.isEmpty) &&
                                              selectedRole == "HOSTEL_SEC") &&
                                          selectedRole.isNotEmpty;
                                  FocusScope.of(context).unfocus();
                                  if (isValid) {
                                    runMutation({
                                      "createAccountInput": {
                                        "roll": name.text.trim(),
                                        "role": selectedRole
                                      },
                                      "hostelId": hostels?.getId(selectedHostel)
                                    });
                                  }
                                },
                                text: "Create Account",
                                isLoading: result!.isLoading,
                              ),
                            )
                          ],
                        ),
                      );
                    }))));
  }
}
