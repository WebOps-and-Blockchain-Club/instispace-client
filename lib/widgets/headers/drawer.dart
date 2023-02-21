import 'package:client/screens/academics/calendar.dart';
import 'package:client/utils/custom_icons.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../models/user.dart';
import '../../screens/super_user/create_notification.dart';
import '../../screens/teasure_hunt/main.dart';
import '../../screens/user/e_id_card.dart';
import '../../screens/mess/main.dart';
import '../../screens/notification/main.dart';
import '../../screens/user/profile.dart';
import '../../screens/user/search_user.dart';
import '../../screens/super_user/reported_posts.dart';
import '../../screens/super_user/create_account.dart';
import '../../screens/super_user/create_tag.dart';
import '../../screens/super_user/create_hostel.dart';
import '../../screens/super_user/update_role.dart';
import '../../screens/info/feedback.dart';
import '../../screens/super_user/view_feedback.dart';
import '../../screens/info/about_us.dart';
import '../../screens/super_user/super_user_list.dart';
import '../../screens/academics/daily_schedule.dart';
import '../../screens/academics/calendar.dart';
import '../../screens/academics/new_timetable.dart';
import '../../graphQL/auth.dart';
import '../../services/auth.dart';
import '../../themes.dart';
import '../page/webpage.dart';
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
    // final user = auth.user;
    return Drawer(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Padding(
                          padding: const EdgeInsets.only(left: 40, bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                  width: 50,
                                  child: Image(
                                      image: AssetImage(
                                          'assets/logo/primary_solid.png'))),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "InstiSpace",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                            color: ColorPalette.palette(context)
                                                .primary,
                                            fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "Everything Insti",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),

                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 35),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: ExpansionTile(
                                    title: const Text('Profile'),
                                    children: [
                                      const SizedBox(height: 10),
                                      // My Profile
                                      ListTile(
                                        visualDensity:
                                            const VisualDensity(vertical: -4),
                                        title: const Text("My Profile"),
                                        tileColor: Colors.transparent,
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          Profile(
                                                            user: user,
                                                          )));
                                        },
                                      ),

                                      // E ID Card
                                      if (user != null)
                                        ListTile(
                                          visualDensity:
                                              const VisualDensity(vertical: -4),
                                          tileColor: Colors.transparent,
                                          title: const Text("E-ID Card"),
                                          onTap: () {
                                            Navigator.pop(context);
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        EIDCard(user: user)));
                                          },
                                        ),

                                      // Search User
                                      ListTile(
                                        visualDensity:
                                            const VisualDensity(vertical: -4),
                                        tileColor: Colors.transparent,
                                        minVerticalPadding: 0,
                                        title: const Text("Find People"),
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          const SearchUser()));
                                        },
                                      ),
                                    ],
                                  ),
                                ),

                                // Mess Menu
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  child: ViewMessMenu(),
                                ),
                                // Notifications
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: ListTile(
                                    title: const Text("Notifications"),
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  const NotificationPage()));
                                    },
                                  ),
                                ),

                                //Super User Actions
                                if (user != null &&
                                    user.permission != null &&
                                    user.role != "USER")
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: ExpansionTile(
                                      title: const Text("Super User Actions"),
                                      children: [
                                        const SizedBox(height: 10),
                                        //Super User List
                                        if (user.permission!.createAccount
                                            .hasPermission)
                                          ListTile(
                                              tileColor: Colors.transparent,
                                              visualDensity:
                                                  const VisualDensity(
                                                      vertical: -4),
                                              title:
                                                  const Text('Super User List'),
                                              onTap: () {
                                                Navigator.pop(context);
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            const SuperUserList()));
                                              }),
                                        // Reports
                                        if (user.permission!.moderateReport)
                                          ListTile(
                                            tileColor: Colors.transparent,
                                            visualDensity: const VisualDensity(
                                                vertical: -4),
                                            title: const Text(
                                                "View Reported Posts"),
                                            onTap: () {
                                              Navigator.pop(context);
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          const ReportedPostPage()));
                                            },
                                          ),
                                        // Create Notification
                                        if (user.permission!.createNotification)
                                          ListTile(
                                            tileColor: Colors.transparent,
                                            visualDensity: const VisualDensity(
                                                vertical: -4),
                                            title: const Text(
                                                "Create Notifcation"),
                                            onTap: () {
                                              Navigator.pop(context);
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          const CreateNotification()));
                                            },
                                          ),
                                        // Create Account
                                        if (user.permission!.createAccount
                                            .hasPermission)
                                          ListTile(
                                            tileColor: Colors.transparent,
                                            visualDensity: const VisualDensity(
                                                vertical: -4),
                                            title:
                                                const Text('Create Accounts'),
                                            onTap: () {
                                              Navigator.pop(context);
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          CreateAccountPage(
                                                            role: user.role!,
                                                          )));
                                            },
                                          ),
                                        // Update Role
                                        if (user.permission!.createAccount
                                            .hasPermission)
                                          ListTile(
                                            tileColor: Colors.transparent,
                                            visualDensity: const VisualDensity(
                                                vertical: -4),
                                            title:
                                                const Text('Appoint Moderator'),
                                            onTap: () {
                                              Navigator.pop(context);
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          const UpdateRolePage()));
                                            },
                                          ),
                                        // Create Hostel
                                        if (user.permission!.createHostel)
                                          ListTile(
                                            tileColor: Colors.transparent,
                                            visualDensity: const VisualDensity(
                                                vertical: -4),
                                            title: const Text("Create Hostel"),
                                            onTap: () {
                                              Navigator.pop(context);
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          const CreateHostelPage()));
                                            },
                                          ),

                                        // Create Tag
                                        if (user.permission!.createTag)
                                          ListTile(
                                            tileColor: Colors.transparent,
                                            visualDensity: const VisualDensity(
                                                vertical: -4),
                                            title: const Text('Create Tag'),
                                            onTap: () {
                                              Navigator.pop(context);
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          const CreateTagPage()));
                                            },
                                          ),
                                        // Super User's Guide
                                        if (user.role != "USER")
                                          ListTile(
                                            visualDensity: const VisualDensity(
                                                vertical: -4),
                                            tileColor: Colors.transparent,
                                            title: const Text(
                                                "Super User's Guide"),
                                            onTap: () {
                                              Navigator.pop(context);
                                              launchUrlString(
                                                  "https://docs.google.com/document/d/e/2PACX-1vS8PkBeAZnlrIgyWaxchCdd2_I9hf7KwzwXCIv4MLO6NwRZbvEhVKMYWtjliZvk1EKW2RvoJcnpifJp/pub",
                                                  mode: LaunchMode
                                                      .externalApplication);
                                            },
                                          ),
                                      ],
                                    ),
                                  ),

                                // Emergency SOS
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: ListTile(
                                    title: const Text("SOS Instructions"),
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  const WebPage(
                                                    title: "SOS Instructions",
                                                    url:
                                                        "https://docs.google.com/document/u/3/d/e/2PACX-1vSRcTWgKoSsq3yPcVvMJVlACvyzaMpDn2l8hQDBZjZxVss6dnOROaZUwswsmjdteGHf67YsjMGLGopt/pub",
                                                  )));
                                    },
                                  ),
                                ),

                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: ExpansionTile(
                                    title: const Text('About Us'),
                                    children: [
                                      const SizedBox(height: 10),

                                      // About Us
                                      ListTile(
                                        visualDensity:
                                            const VisualDensity(vertical: -4),
                                        tileColor: Colors.transparent,
                                        title: const Text("About Us"),
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          const AboutUsPage()));
                                        },
                                      ),

                                      // Feedback
                                      (user != null &&
                                                  user.permission != null) &&
                                              user.permission!.viewFeeback
                                          ? const ViewFeedback()
                                          : ListTile(
                                              visualDensity:
                                                  const VisualDensity(
                                                      vertical: -4),
                                              tileColor: Colors.transparent,
                                              title: const Text("Feedback"),
                                              onTap: () {
                                                Navigator.pop(context);
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            const FeedbackPage()));
                                              },
                                            ),

                                      // Terms of Service
                                      ListTile(
                                        visualDensity:
                                            const VisualDensity(vertical: -4),
                                        tileColor: Colors.transparent,
                                        title: const Text("Terms of Service"),
                                        onTap: () {
                                          Navigator.pop(context);
                                          launchUrlString(
                                            'https://docs.google.com/document/d/e/2PACX-1vTCDv6MFgQ6BmWKHQdGqeo2qVVhHMnlNyU24buZV_Vf1riw0ixCz_yysktiCYc-mCLsTplq3XZVdXrU/pub',
                                            mode:
                                                LaunchMode.externalApplication,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),

                                // Logout Button
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: ListTile(
                                    horizontalTitleGap: 0,
                                    title: const Text("Logout"),
                                    onTap: () => logoutAlert(
                                        context, () => auth.logout()),
                                  ),
                                ),
                              ],
                            )),

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

Future<dynamic> logoutAlert(BuildContext context, void Function() callback) {
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
              CustomElevatedButton(
                onPressed: callback,
                text: "Logout",
                color: ColorPalette.palette(context).warning,
              ),
            ],
          );
        });
      });
}
