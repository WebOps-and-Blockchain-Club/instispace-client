import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../models/user.dart';
import '../../screens/user/e_id_card.dart';
import '../../screens/mess/main.dart';
import '../../screens/notification/main.dart';
import '../../screens/hostel/main.dart';
import '../../screens/user/profile.dart';
import '../../screens/user/edit_profile.dart';
import '../../screens/user/search_user.dart';
import '../../screens/super_user/reported_posts.dart';
import '../../screens/super_user/create_account.dart';
import '../../screens/super_user/create_tag.dart';
import '../../screens/super_user/create_hostel.dart';
import '../../screens/super_user/update_role.dart';
import '../../screens/info/feedback.dart';
import '../../screens/super_user/view_feedback.dart';
import '../../screens/info/about_us.dart';
import '../../graphQL/auth.dart';
import '../../services/auth.dart';
import '../../themes.dart';
import '../button/elevated_button.dart';
import '../helpers/error.dart';

class CustomDrawer extends StatelessWidget {
  final AuthService auth;
  final UserModel user;
  final String fcmToken;
  const CustomDrawer(
      {Key? key,
      required this.auth,
      required this.user,
      required this.fcmToken})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SafeArea(
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: constraints.copyWith(
                    minHeight: constraints.maxHeight,
                    maxHeight: double.infinity,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        // Header
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 15, bottom: 10),
                          child: Row(
                            children: [
                              const SizedBox(
                                  width: 50,
                                  child: Image(
                                      image: AssetImage(
                                          'assets/logo/primary_solid.png'))),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "INSTI SPACE",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                    ),
                                    Text(
                                      "EVERYTHING INSTI",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                              color:
                                                  ColorPalette.palette(context)
                                                      .secondary,
                                              fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Divider(indent: 15, endIndent: 15),

                        // My Profile
                        ListTile(
                          leading: const Icon(Icons.account_circle_outlined),
                          horizontalTitleGap: 0,
                          title: const Text("My Profile"),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) => Profile(
                                      user: user,
                                    )));
                          },
                        ),

                        // Edit Profile
                        ListTile(
                          leading: const Icon(Icons.edit),
                          horizontalTitleGap: 0,
                          title: const Text("Edit Profile"),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) => EditProfile(
                                      auth: auth,
                                      user: user,
                                    )));
                          },
                        ),

                        // E ID Card
                        ListTile(
                          leading: const Icon(Icons.perm_identity),
                          horizontalTitleGap: 0,
                          title: const Text("E-ID Card"),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    EIDCard(user: user)));
                          },
                        ),

                        // Search User
                        ListTile(
                          leading: const Icon(Icons.search_outlined),
                          horizontalTitleGap: 0,
                          title: const Text("Find People"),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const SearchUser()));
                          },
                        ),

                        // My Hostel
                        if (user.hostelId != null ||
                            user.permissions.contains("HOSTEL_ADMIN"))
                          ListTile(
                            leading: const Icon(Icons.account_balance),
                            horizontalTitleGap: 0,
                            title: const Text("My Hostel"),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      HostelWrapper(user: user)));
                            },
                          ),

                        // Mess Menu
                        const ViewMessMenu(),

                        // Notifications
                        ListTile(
                          leading: const Icon(Icons.notifications),
                          horizontalTitleGap: 0,
                          title: const Text("Notifications"),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const NotificationPage()));
                          },
                        ),

                        // Reports
                        if (user.permissions.contains("GET_REPORTS"))
                          ListTile(
                            leading: const Icon(Icons.account_circle_outlined),
                            horizontalTitleGap: 0,
                            title: const Text("View Reported Posts"),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const ReportedPostPage()));
                            },
                          ),

                        // Create Account
                        if (user.permissions.contains("CREATE_ACCOUNT"))
                          ListTile(
                            leading: const Icon(Icons.addchart_outlined),
                            horizontalTitleGap: 0,
                            title: const Text('Create Accounts'),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      CreateAccountPage(
                                        role: user.role!,
                                      )));
                            },
                          ),

                        // Create Tag
                        if (user.permissions.contains("CREATE_TAG"))
                          ListTile(
                            leading: const Icon(Icons.add_outlined),
                            horizontalTitleGap: 0,
                            title: const Text('Create Tag'),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const CreateTagPage()));
                            },
                          ),

                        // Create Hostel
                        if (user.permissions.contains("CREATE_HOSTEL"))
                          ListTile(
                            leading: const Icon(Icons.account_balance_outlined),
                            horizontalTitleGap: 0,
                            title: const Text("Create Hostel"),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const CreateHostelPage()));
                            },
                          ),

                        // Update Role
                        if (user.permissions.contains("UPDATE_ROLE"))
                          ListTile(
                            leading: const Icon(Icons.upgrade),
                            horizontalTitleGap: 0,
                            title: const Text('Update Role'),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const UpdateRolePage()));
                            },
                          ),

                        // Feedback
                        user.permissions.contains("VIEW_FEEDBACK")
                            ? const ViewFeedback()
                            : ListTile(
                                leading: const Icon(Icons.feedback_outlined),
                                horizontalTitleGap: 0,
                                title: const Text("Feedback"),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          const FeedbackPage()));
                                },
                              ),

                        // About Us
                        ListTile(
                          leading: const Icon(Icons.alternate_email),
                          horizontalTitleGap: 0,
                          title: const Text("About Us"),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const AboutUsPage()));
                          },
                        ),

                        // Terms of Service
                        ListTile(
                          leading: const Icon(Icons.info_outline),
                          horizontalTitleGap: 0,
                          title: const Text("Terms of Service"),
                          onTap: () {
                            Navigator.pop(context);
                            launchUrlString(
                              'https://docs.google.com/document/d/e/2PACX-1vTCDv6MFgQ6BmWKHQdGqeo2qVVhHMnlNyU24buZV_Vf1riw0ixCz_yysktiCYc-mCLsTplq3XZVdXrU/pub',
                              mode: LaunchMode.externalApplication,
                            );
                          },
                        ),

                        // Logout Button
                        ListTile(
                          leading: const Icon(Icons.logout),
                          horizontalTitleGap: 0,
                          title: const Text("Logout"),
                          onTap: () => logoutAlert(
                              context, () => auth.logout(), fcmToken),
                        ),

                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const Divider(indent: 15, endIndent: 15),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          launchUrlString(
                                              'https://cfi.iitm.ac.in/clubs/webops-and-blockchain-club',
                                              mode: LaunchMode
                                                  .externalApplication);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: const CircleAvatar(
                                            radius: 30,
                                            backgroundImage: AssetImage(
                                                'assets/club_logo.png'),
                                            backgroundColor: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              'Developed with ❤️',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
                                              textAlign: TextAlign.justify,
                                            ),
                                            Text(
                                              'WebOps and Blockchain',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium,
                                              textAlign: TextAlign.justify,
                                            ),
                                            Text(
                                              'Centre For Innovation',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.normal),
                                              textAlign: TextAlign.justify,
                                            ),
                                            Text(
                                              '© ${DateTime.now().year}. Version: 1.0.0',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall,
                                              textAlign: TextAlign.justify,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

Future<dynamic> logoutAlert(
    BuildContext context, Function callback, String fcmToken) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, _) {
          return AlertDialog(
            titlePadding: const EdgeInsets.only(top: 30, bottom: 10),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            actionsPadding: const EdgeInsets.all(10),
            title: const Text('Logout', textAlign: TextAlign.center),
            content: const Text("Are you sure to logout?",
                textAlign: TextAlign.center),
            actions: <Widget>[
              CustomElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                text: "Cancel",
                color: ColorPalette.palette(context).warning,
                type: ButtonType.outlined,
              ),
              Mutation(
                  options: MutationOptions(
                    document: gql(AuthGQL().logout),
                    onCompleted: (dynamic resultData) async {
                      Navigator.of(context).pop();
                      callback();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('User Logged Out')),
                      );
                    },
                    onError: (dynamic error) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text(formatErrorMessage(error.toString()))),
                      );
                    },
                  ),
                  builder: (
                    RunMutation runMutation,
                    QueryResult? result,
                  ) {
                    return CustomElevatedButton(
                      onPressed: () {
                        runMutation({
                          "fcmToken": fcmToken,
                        });
                      },
                      text: "Logout",
                      isLoading: result!.isLoading,
                      color: ColorPalette.palette(context).warning,
                    );
                  }),
            ],
          );
        });
      });
}
