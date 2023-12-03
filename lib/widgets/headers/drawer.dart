import 'package:client/screens/academics/calendar.dart';
import 'package:client/screens/badges/club_wrapper.dart';
import 'package:client/screens/badges/create_club.dart';
import 'package:client/screens/badges/view_club.dart';
import 'package:client/utils/custom_icons.dart';
import 'package:client/widgets/helpers/navigate.dart';
import '../../models/category.dart';
import 'package:client/widgets/home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../screens/badges/scanner.dart';
import '../../models/post/query_variable.dart';
import '../../models/user.dart';
import '../../screens/mitr/counsellor.dart';
import '../../screens/mitr/yourdost.dart';
import '../../screens/mitr/mentalHealth.dart';
import '../../screens/super_user/approve_post.dart';
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
import '../../screens/badges/update_club.dart';
import '../../screens/badges/create_badges.dart';
import '../../screens/complain/complainFiling.dart';
import '../../graphQL/auth.dart';
import '../../services/auth.dart';
import '../../themes.dart';
import '../page/webpage.dart';
import '../button/elevated_button.dart';
import '../helpers/error.dart';

class CustomDrawer extends StatefulWidget {
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
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(50), bottomRight: Radius.circular(50))),
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SafeArea(child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: constraints.copyWith(
                  minHeight: constraints.maxHeight,
                  maxHeight: double.infinity,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 40, bottom: 20, top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                                width: 50,
                                height: 50,
                                child: Image(
                                    image: AssetImage(
                                        'assets/logo/primary_solid.png'))),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    "InstiSpace",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                            color: ColorPalette.palette(context)
                                                .primary,
                                            fontWeight: FontWeight.w500),
                                  ),
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
                              padding: const EdgeInsets.symmetric(vertical: 5),
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
                                              builder: (BuildContext context) =>
                                                  Profile(
                                                    user: widget.user,
                                                  )));
                                    },
                                  ),

                                  // E ID Card
                                  if (widget.user.role == 'USER')
                                    ListTile(
                                      visualDensity:
                                          const VisualDensity(vertical: -4),
                                      tileColor: Colors.transparent,
                                      title: const Text("E-ID Card"),
                                      onTap: () {
                                        Navigator.pop(context);
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        EIDCard(
                                                            user:
                                                                widget.user)));
                                      },
                                    ),

                                  // Logout Button
                                  ListTile(
                                    visualDensity:
                                        const VisualDensity(vertical: -4),
                                    tileColor: Colors.transparent,
                                    horizontalTitleGap: 0,
                                    title: const Text("Logout"),
                                    onTap: () => logoutAlert(context,
                                        () async => await widget.auth.logout()),
                                  ),
                                ],
                              ),
                            ),

                            // Search User
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: ListTile(
                                title: const Text("Find People"),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          const SearchUser()));
                                },
                              ),
                            ),

                            // Mess Menu
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: ListTile(
                                title: const Text("Mess"),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          const MessMenuScreen()));
                                },
                              ),
                            ),
                            // Notifications
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(vertical: 5),
                            //   child: ListTile(
                            //     title: const Text("Notifications"),
                            //     onTap: () {
                            //       Navigator.pop(context);
                            //       Navigator.of(context).push(MaterialPageRoute(
                            //           builder: (BuildContext context) =>
                            //               const NotificationPage()));
                            //     },
                            //   ),
                            // ),

                            // Mitr
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: ExpansionTile(
                                title: const Text("Wellness Community Centre"),
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ListTile(
                                    tileColor: Colors.transparent,
                                    visualDensity:
                                        const VisualDensity(vertical: -4),
                                    title:
                                        const Text("Wellness Centre of IITM"),
                                    onTap: () {
                                      Navigator.pop(context);
                                      navigate(
                                          context, const CounsellorScreen());
                                    },
                                  ),
                                  ListTile(
                                    tileColor: Colors.transparent,
                                    visualDensity:
                                        const VisualDensity(vertical: -4),
                                    title: const Text("Your Dost"),
                                    onTap: () {
                                      Navigator.pop(context);
                                      navigate(context, const YourDostScreen());
                                    },
                                  ),
                                  ListTile(
                                    tileColor: Colors.transparent,
                                    visualDensity:
                                        const VisualDensity(vertical: -4),
                                    title: const Text("Mental Health"),
                                    onTap: () {
                                      Navigator.pop(context);
                                      navigate(
                                          context,
                                          mentalHealth(
                                            categories: forumCategories,
                                            user: widget.user,
                                            createPost: true,
                                          ));
                                    },
                                  ),
                                ],
                              ),
                            ),

                            //Super User Actions
                            if (widget.user != null &&
                                widget.user.permission != null &&
                                widget.user.role != "USER")
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: ExpansionTile(
                                  title: const Text("Super User Actions"),
                                  children: [
                                    const SizedBox(height: 10),
                                    //Super User List
                                    if (widget.user.permission!.createAccount
                                        .hasPermission)
                                      ListTile(
                                          tileColor: Colors.transparent,
                                          visualDensity:
                                              const VisualDensity(vertical: -4),
                                          title: const Text('Super User List'),
                                          onTap: () {
                                            Navigator.pop(context);
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        const SuperUserList()));
                                          }),
                                    // Reports
                                    if (widget.user.permission!.moderateReport)
                                      ListTile(
                                        tileColor: Colors.transparent,
                                        visualDensity:
                                            const VisualDensity(vertical: -4),
                                        title:
                                            const Text("View Reported Posts"),
                                        onTap: () {
                                          Navigator.pop(context);
                                          navigate(
                                              context,
                                              SuperUserPostPage(
                                                title: 'MODERATE POST',
                                                filterVariables:
                                                    PostQueryVariableModel(
                                                        viewReportedPosts:
                                                            true),
                                              ));
                                        },
                                      ),
                                    if (widget.user.permission!.approvePost)
                                      ListTile(
                                        tileColor: Colors.transparent,
                                        visualDensity:
                                            const VisualDensity(vertical: -4),
                                        title: const Text("Approve Post"),
                                        onTap: () {
                                          Navigator.pop(context);
                                          navigate(
                                              context,
                                              SuperUserPostPage(
                                                  title: 'APPROVE POST',
                                                  filterVariables:
                                                      PostQueryVariableModel(
                                                          postToBeApproved:
                                                              true)));
                                        },
                                      ),
                                    // Create Notification
                                    if (widget
                                        .user.permission!.createNotification)
                                      ListTile(
                                        tileColor: Colors.transparent,
                                        visualDensity:
                                            const VisualDensity(vertical: -4),
                                        title: const Text("Create Notifcation"),
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
                                    if (widget.user.permission!.createAccount
                                        .hasPermission)
                                      ListTile(
                                        tileColor: Colors.transparent,
                                        visualDensity:
                                            const VisualDensity(vertical: -4),
                                        title: const Text('Create Accounts'),
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          CreateAccountPage(
                                                            permissions: widget
                                                                .user
                                                                .permission!,
                                                            role: widget
                                                                .user.role!,
                                                          )));
                                        },
                                      ),
                                    // Update Role
                                    if (widget.user.permission!.createAccount
                                                .allowedRoles !=
                                            null &&
                                        widget.user.permission!.createAccount
                                            .allowedRoles!
                                            .contains("MODERATOR"))
                                      ListTile(
                                        tileColor: Colors.transparent,
                                        visualDensity:
                                            const VisualDensity(vertical: -4),
                                        title: const Text('Appoint Moderator'),
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
                                    if (widget.user.permission!.createHostel)
                                      ListTile(
                                        tileColor: Colors.transparent,
                                        visualDensity:
                                            const VisualDensity(vertical: -4),
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
                                    if (widget.user.permission!.createTag)
                                      ListTile(
                                        tileColor: Colors.transparent,
                                        visualDensity:
                                            const VisualDensity(vertical: -4),
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
                                    if (widget.user.role != "USER")
                                      ListTile(
                                        tileColor: Colors.transparent,
                                        visualDensity:
                                            const VisualDensity(vertical: -4),
                                        title: const Text('Club Manager'),
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      const ClubWrapperPage()));
                                        },
                                      ),
                                    /*if (user.role != "USER")
                                      ListTile(
                                        tileColor: Colors.transparent,
                                        visualDensity:
                                            const VisualDensity(vertical: -4),
                                        title: const Text('View Club'),
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      const ViewClubPage()));
                                        },
                                      ),*/
                                    /*if (user.role != "USER")
                                      ListTile(
                                        tileColor: Colors.transparent,
                                        visualDensity:
                                            const VisualDensity(vertical: -4),
                                        title: const Text('Update Club'),
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      const UpdateClubPage()));
                                        },
                                      ),*/
                                    /*if (user.role != "USER")
                                      ListTile(
                                        tileColor: Colors.transparent,
                                        visualDensity:
                                            const VisualDensity(vertical: -4),
                                        title: const Text('Create Badges'),
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      const CreateBadgesPage()));
                                        },
                                      ),*/
                                    // Super User's Guide
                                    if (widget.user.role != "USER")
                                      ListTile(
                                        visualDensity:
                                            const VisualDensity(vertical: -4),
                                        tileColor: Colors.transparent,
                                        title: const Text("Super User's Guide"),
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
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: ListTile(
                                title: const Text("Scan QR"),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          const ScannerScreen()));
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: ListTile(
                                title: const Text("Complaints to SECC"),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ComplaintPortal(
                                            user: widget.user,
                                          )));
                                },
                              ),
                            ),
                            // Emergency SOS
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: ListTile(
                                title: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [Text("SOS Manual"), Text("🔴")],
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          const WebPage(
                                            title: "SOS Manual",
                                            url:
                                                "https://docs.google.com/document/u/3/d/e/2PACX-1vSRcTWgKoSsq3yPcVvMJVlACvyzaMpDn2l8hQDBZjZxVss6dnOROaZUwswsmjdteGHf67YsjMGLGopt/pub",
                                          )));
                                },
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
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
                                              builder: (BuildContext context) =>
                                                  const AboutUsPage()));
                                    },
                                  ),

                                  // Feedback
                                  (widget.user != null &&
                                              widget.user.permission != null) &&
                                          widget.user.permission!.viewFeeback
                                      ? const ViewFeedback()
                                      : ListTile(
                                          visualDensity:
                                              const VisualDensity(vertical: -4),
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
                                        mode: LaunchMode.externalApplication,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // const Divider(indent: 15, endIndent: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        launchUrlString(
                                            'https://cfi.iitm.ac.in/clubs/webops-and-blockchain-club',
                                            mode:
                                                LaunchMode.externalApplication);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: const CircleAvatar(
                                          radius: 30,
                                          backgroundImage: AssetImage(
                                              'assets/club_logo.png'),
                                          backgroundColor: Colors.transparent,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        launchUrlString(
                                            'https://cfi.iitm.ac.in',
                                            mode:
                                                LaunchMode.externalApplication);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: const CircleAvatar(
                                          radius: 30,
                                          backgroundImage:
                                              AssetImage('assets/cfi_logo.png'),
                                          backgroundColor: Colors.transparent,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
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
                                            '© ${DateTime.now().year}. Version: 2.0.0',
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
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }));
        },
      ),
    );
  }
}

Future<dynamic> logoutAlert(
    BuildContext context, Future<void> Function() callback) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        bool loading = false;
        return StatefulBuilder(builder: (context, StateSetter setState) {
          return AlertDialog(
            titlePadding: const EdgeInsets.only(top: 30),
            contentPadding: const EdgeInsets.all(20),
            title: const Text('Logout', textAlign: TextAlign.center),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Are you sure to logout?",
                    textAlign: TextAlign.center),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: TextButton(
                    style: TextButton.styleFrom(
                        minimumSize: const Size.fromHeight(30)),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                CustomElevatedButton(
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });
                    // await Future.delayed(Duration(seconds: 5));
                    await callback();
                    setState(() {
                      loading = false;
                    });
                    Navigator.pop(context);
                  },
                  text: "Logout",
                  color: ColorPalette.palette(context).warning,
                  isLoading: loading,
                ),
              ],
            ),
          );
        });
      });
}
