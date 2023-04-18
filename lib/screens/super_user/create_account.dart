import 'package:client/models/category.dart';
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
  late final List<String> roleList;
  HostelsModel? hostels;

  final formKey = GlobalKey<FormState>();

  final TextEditingController name = TextEditingController();
  final TextEditingController mobile = TextEditingController();
  String selectedRole = "";

  bool createTag = false;
  bool reports = false;
  bool createPost = false;
  bool createAccount = false;

  String roleError = "";
  String hostelError = "";
  List<String> roles = [];
  String? selectedHostel;

  List<String> createAccList = [];

  Map<String, bool> permissions = {};

  Map<String, List<String>> accs = {
    "SECRETARY": ["LEADS", "MODERATOR", "HOSTEL_SEC"],
    "LEADS": ["LEADS"],
    "HOSTEL_SEC": ["HOSTEL_SEC"],
  };

  void getRole(role) {
    List<String> base_accs = accs[role] ?? [];
    if (widget.permissions.createAccount.allowedRoles != null) {
      setState(() {
        createAccList = base_accs
            .where((e) =>
                widget.permissions.createAccount.allowedRoles!.contains(e))
            .toList()
            .cast<String>();
      });
    }
  }

  List<String> getHostel(role) {
    switch (role) {
      case "SECRETARY":
        return ["Hostel", "Contact", "Ameninity"];
      case "HOSTEL_SEC":
        return ["Contact", "Amenity"];
      default:
        return [];
    }
  }

  List<String> accounts = [];
  List<String> posts = [
    ...forumCategories.map((e) => e.name),
    ...lnfCategories.map((e) => e.name)
  ];

  @override
  void initState() {
    print(widget.permissions.createTag);
    print(widget.permissions.approvePost);
    print(widget.permissions.createPost?.allowedCategory);
    setState(() {
      roles = widget.permissions.createAccount.allowedRoles == null
          ? []
          : [...widget.permissions.createAccount.allowedRoles!];
      roles.remove("MODERATOR");
      if (roles.isNotEmpty) selectedRole = roles[0];

      if (widget.permissions.createTag) createTag = true;
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
                        print('result');
                        print(resultData);
                        if (resultData["createUser"] != null) {
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
                              items: roles,
                              onChanged: (value) {
                                setState(() {
                                  selectedRole = value!;
                                });
                                getRole(value);
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
                                      return ErrorText(
                                          error:
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

                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 30),
                              child: Text('Configure Permissions',
                                  style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w500)),
                            ),

                            // Center(
                            //   child: Wrap(
                            //       spacing: 4,
                            //       runSpacing: 6,
                            //       children: List.generate(permissions.length,
                            //           (index) {
                            //         String key =
                            //             permissions.keys.elementAt(index);
                            //         return GestureDetector(
                            //           onTap: () {
                            //             setState(() {
                            //               permissions[key] = !permissions.values
                            //                   .elementAt(index);
                            //             });
                            //           },
                            //           child: Container(
                            //             decoration: BoxDecoration(
                            //                 color: permissions[key]!
                            //                     ? const Color(0xFFE1E0EC)
                            //                     : Colors.transparent,
                            //                 border: Border.all(
                            //                     color: const Color(0xFFE1E0EC)),
                            //                 borderRadius:
                            //                     BorderRadius.circular(17)),
                            //             padding: const EdgeInsets.symmetric(
                            //                 vertical: 6, horizontal: 11),
                            //             child: Text(key,
                            //                 style: const TextStyle(
                            //                     color: Color(0xFF3C3C3C))),
                            //           ),
                            //         );
                            //       })),
                            // ),

                            //create tag
                            if (widget.permissions.createTag)
                              CheckboxListTile(
                                title: const Text('Allow them to create tags'),
                                value: createTag,
                                tileColor: Colors.transparent,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                onChanged: (value) {
                                  setState(() {
                                    if (value != null) createTag = value;
                                  });
                                },
                              ),

                            //moderate report
                            if (widget.permissions.moderateReport)
                              CheckboxListTile(
                                  title: const Text(
                                      'Allow them to moderate reports'),
                                  value: reports,
                                  tileColor: Colors.transparent,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value != null) reports = value;
                                    });
                                  }),

                            //create post (without approval)
                            if (widget.permissions.createPost != null &&
                                widget.permissions.createPost!.hasPermission)
                              CheckboxListTile(
                                  title: const Text(
                                      'Allow them to post in feeds without approval'),
                                  value: createPost,
                                  tileColor: Colors.transparent,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value != null) createPost = value;
                                    });
                                  }),

                            //create accounts
                            if (widget.permissions.createAccount.hasPermission)
                              CheckboxListTile(
                                  title: const Text(
                                      'Allow them to create an account'),
                                  value: createAccount,
                                  tileColor: Colors.transparent,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value != null) {
                                        createAccount = value;
                                      }
                                      getRole(selectedRole);
                                    });
                                  }),

                            if (widget.permissions.createAccount.allowedRoles !=
                                    null &&
                                createAccount)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 30),
                                child: Text('Which accounts can they create?',
                                    style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w500)),
                              ),
                            if (widget.permissions.createAccount.allowedRoles !=
                                    null &&
                                createAccount)
                              Center(
                                child: Wrap(
                                    spacing: 4,
                                    runSpacing: 6,
                                    children: List.generate(
                                        createAccList.length, (index) {
                                      String role = createAccList[index];
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
                                                  color:
                                                      const Color(0xFFE1E0EC)),
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

                            // const Padding(
                            //   padding: EdgeInsets.symmetric(vertical: 30),
                            //   child: Text('What Posts can they create?',
                            //       style: TextStyle(
                            //           fontSize: 19,
                            //           fontWeight: FontWeight.w500)),
                            // ),

                            // Center(
                            //   child: Wrap(
                            //       spacing: 4,
                            //       runSpacing: 6,
                            //       children: List.generate(feed.length, (index) {
                            //         String p = feed[index];
                            //         return GestureDetector(
                            //           onTap: () {
                            //             setState(() {
                            //               if (posts.contains(p)) {
                            //                 posts.remove(p);
                            //               } else {
                            //                 posts.add(p);
                            //               }
                            //             });
                            //           },
                            //           child: Container(
                            //             decoration: BoxDecoration(
                            //                 color: posts.contains(p)
                            //                     ? const Color(0xFFE1E0EC)
                            //                     : Colors.transparent,
                            //                 border: Border.all(
                            //                     color: const Color(0xFFE1E0EC)),
                            //                 borderRadius:
                            //                     BorderRadius.circular(17)),
                            //             padding: const EdgeInsets.symmetric(
                            //                 vertical: 6, horizontal: 11),
                            //             child: Text(p,
                            //                 style: const TextStyle(
                            //                     color: Color(0xFF3C3C3C))),
                            //           ),
                            //         );
                            //       })),
                            // ),

                            if (result != null && result.hasException)
                              ErrorText(error: result.exception.toString()),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: CustomElevatedButton(
                                onPressed: () async {
                                  final isValid =
                                      formKey.currentState!.validate() &&
                                          selectedRole.isNotEmpty &&
                                          (selectedRole == "HOSTEL_SEC"
                                              ? selectedHostel != null &&
                                                  selectedHostel!.isNotEmpty
                                              : true);
                                  FocusScope.of(context).unfocus();
                                  if (isValid) {
                                    if (createPost) {
                                      setState(() {
                                        posts.addAll(
                                            feedCategories.map((e) => e.name));
                                      });
                                    }
                                    print(hostels?.getId(selectedHostel));
                                    print({
                                      "user": {
                                        "roll": name.text.trim(),
                                        "role": selectedRole,
                                      },
                                      "permission": {
                                        "account": accounts,
                                        "livePosts": posts,
                                        "createNotification": false,
                                        "createTag": createTag,
                                        "approvePosts": createPost,
                                        "handleReports": reports,
                                        "hostel": getHostel(selectedRole),
                                      },
                                      "hostelId": hostels?.getId(selectedHostel)
                                    });
                                    runMutation({
                                      "user": {
                                        "roll": name.text.trim(),
                                        "role": selectedRole,
                                      },
                                      "permission": {
                                        "account": createAccount != false
                                            ? accounts
                                            : [],
                                        "livePosts": posts,
                                        "createNotification": false,
                                        "createTag": createTag,
                                        "approvePosts": createPost,
                                        "handleReports": reports,
                                        "hostel": getHostel(selectedRole),
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
