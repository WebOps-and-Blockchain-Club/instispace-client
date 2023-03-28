import 'package:client/models/user.dart';
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
  final PermissionModel permissions;

  const CreateAccountPage(
      {Key? key, required this.role, required this.permissions})
      : super(key: key);

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

  Map<String, bool> permissions = {};

  final List<String> feed = ["Events", "Announcements", "Recruitment"];

  List<String> getRole(role) {
    switch (role) {
      case "ADMIN":
        return ["SECRETARY", "LEADS", "HOSTEL_SEC", "MODERATOR", "DEV_TEAM"];
      case "SECRETARY":
        return ["LEADS", "MODERATOR"];
      case "LEADS":
        return ["LEADS", "MODERATOR"];
      default:
        return [];
    }
  }

  List<String> accounts = [];
  List<String> posts = [
    "Networking",
    "Help",
    "Connect",
    "Random Thoughts",
    "Opportunities",
    "Queries",
    "Lost",
    "Found"
  ];

  @override
  void initState() {
    roleList = getRole(widget.role);
    selectedRole = roleList[0];

    final curr_permissions = widget.permissions;
    print(curr_permissions);

    final Map<String, bool> pers = {
      "Create Notification": curr_permissions.createNotification,
      "Create Tag": curr_permissions.createTag,
      "Approve Posts": curr_permissions.approvePost,
      "Handle Reports": curr_permissions.moderateReport,
      "View Feedback": curr_permissions.viewFeeback,
    };
    pers.removeWhere(
      (key, value) => value == false,
    );

    setState(() {
      permissions = pers;
    });
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
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Mutation(
                    options: MutationOptions(
                      document: gql(SuperUserGQL().createAccount),
                      onCompleted: (dynamic resultData) {
                        if (resultData["createAccount"] == true) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Account Created and mail is sent to the respective email id')),
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

                            // Email
                            TextFormField(
                              style: const TextStyle(fontSize: 18),
                              controller: name,
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.black)),
                                labelText: "Email ID",
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

                            const SizedBox(height: 10),

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
                            // if (selectedRole == "HOSTEL_SEC")
                            //   const LabelText(text: "Select Hostel"),
                            // if (selectedRole == "HOSTEL_SEC")
                            //   Query(
                            //       options: QueryOptions(
                            //         document: gql(AuthGQL().getHostel),
                            //       ),
                            //       builder: (QueryResult queryResult,
                            //           {fetchMore, refetch}) {
                            //         if (queryResult.hasException) {
                            //           return ErrorText(
                            //               error:
                            //                   queryResult.exception.toString());
                            //         }

                            //         if (queryResult.isLoading) {
                            //           return const Text('Loading');
                            //         }

                            //         hostels = HostelsModel.fromJson(
                            //             queryResult.data!["getHostels"]);
                            //         List<String> hostelNames =
                            //             HostelsModel.fromJson(
                            //                     queryResult.data!["getHostels"])
                            //                 .getNames();
                            //         return CustomDropdownButton(
                            //           value: selectedHostel,
                            //           items: hostelNames,
                            //           onChanged: (value) {
                            //             setState(() {
                            //               selectedHostel = value!;
                            //             });
                            //           },
                            //         );
                            //       }),

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

                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 30),
                              child: Text('Configure Permissions',
                                  style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w500)),
                            ),

                            Center(
                              child: Wrap(
                                  spacing: 4,
                                  runSpacing: 6,
                                  children: List.generate(permissions.length,
                                      (index) {
                                    String key =
                                        permissions.keys.elementAt(index);
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          permissions[key] = !permissions.values
                                              .elementAt(index);
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: permissions[key]!
                                                ? const Color(0xFFE1E0EC)
                                                : Colors.transparent,
                                            border: Border.all(
                                                color: const Color(0xFFE1E0EC)),
                                            borderRadius:
                                                BorderRadius.circular(17)),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6, horizontal: 11),
                                        child: Text(key,
                                            style: const TextStyle(
                                                color: Color(0xFF3C3C3C))),
                                      ),
                                    );
                                  })),
                            ),
                            if (getRole(selectedRole).isNotEmpty)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 30),
                                child: Text('Which accounts can they create?',
                                    style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w500)),
                              ),

                            Center(
                              child: Wrap(
                                  spacing: 4,
                                  runSpacing: 6,
                                  children: List.generate(
                                      getRole(selectedRole).length, (index) {
                                    String role = getRole(selectedRole)[index];
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (accounts.contains(role)) {
                                            accounts.remove(role);
                                          } else {
                                            accounts.add(role);
                                          }
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: accounts.contains(role)
                                                ? const Color(0xFFE1E0EC)
                                                : Colors.transparent,
                                            border: Border.all(
                                                color: const Color(0xFFE1E0EC)),
                                            borderRadius:
                                                BorderRadius.circular(17)),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6, horizontal: 11),
                                        child: Text(role,
                                            style: const TextStyle(
                                                color: Color(0xFF3C3C3C))),
                                      ),
                                    );
                                  })),
                            ),

                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 30),
                              child: Text('What Posts can they create?',
                                  style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w500)),
                            ),

                            Center(
                              child: Wrap(
                                  spacing: 4,
                                  runSpacing: 6,
                                  children: List.generate(feed.length, (index) {
                                    String p = feed[index];
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (posts.contains(p)) {
                                            posts.remove(p);
                                          } else {
                                            posts.add(p);
                                          }
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: posts.contains(p)
                                                ? const Color(0xFFE1E0EC)
                                                : Colors.transparent,
                                            border: Border.all(
                                                color: const Color(0xFFE1E0EC)),
                                            borderRadius:
                                                BorderRadius.circular(17)),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6, horizontal: 11),
                                        child: Text(p,
                                            style: const TextStyle(
                                                color: Color(0xFF3C3C3C))),
                                      ),
                                    );
                                  })),
                            ),

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
                                    print({
                                      "account": accounts,
                                      "livePosts": posts,
                                      "createNotification":
                                          permissions.values.elementAt(0),
                                      "createTag":
                                          permissions.values.elementAt(1),
                                      "approvePosts":
                                          permissions.values.elementAt(2),
                                      "handleReports":
                                          permissions.values.elementAt(3),
                                      "hostel": ["Sarayu"],
                                    });
                                    runMutation({
                                      "user": {
                                        "roll": name.text.trim(),
                                        "role": selectedRole,
                                      },
                                      "permission": {
                                        "account": accounts,
                                        "livePosts": posts,
                                        "createNotification":
                                            permissions.values.elementAt(0),
                                        "createTag":
                                            permissions.values.elementAt(1),
                                        "approvePosts":
                                            permissions.values.elementAt(2),
                                        "handleReports":
                                            permissions.values.elementAt(3),
                                        "viewFeedback":
                                            permissions.values.elementAt(4),
                                        "hostel": ["Sarayu"],
                                      }
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
