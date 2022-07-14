import 'package:flutter/material.dart';

import '../../screens/home/Admin/createHostel.dart';
import '../../screens/home/Admin/createSuperUsers.dart';
import '../../screens/home/Admin/feedback.dart';
import '../../screens/home/Admin/report.dart';
import '../../screens/home/Admin/updateRole.dart';
import '../../screens/home/feedbackTypePages/about_us.dart';
import '../../screens/home/feedbackTypePages/contact_us.dart';
import '../../screens/home/feedbackTypePages/feedback.dart';
import '../../screens/home/hostelSection/hostel.dart';
import '../../screens/home/searchUser.dart';
import '../../screens/home/updateProfile/basicInfo.dart';
import '../../screens/home/userPage.dart';
import '../../screens/auth/createTag.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(2, 10, 0, 10),

                  /// AppName and logo
                  child: Row(
                    children: const [
                      CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              AssetImage('assets/ic_launcher - Copy.png')),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8.0, 0.0, 0, 0),
                        child: Text(
                          "InstiSpace",
                          style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              ///My Profile Button
              ListTile(
                leading: const Icon(Icons.account_circle_outlined),
                horizontalTitleGap: 0,
                title: const Text("My Profile"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => UserPage()));
                },
              ),

              ///Update Profile Button
              ListTile(
                leading: const Icon(Icons.edit),
                horizontalTitleGap: 0,
                title: const Text("Edit Profile"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => BasicInfo()));
                },
              ),

              ///My Hostel Button
              // if (userRole == 'USER' || userRole == 'MODERATOR')
              ListTile(
                leading: const Icon(Icons.account_balance),
                horizontalTitleGap: 0,
                title: const Text("My Hostel"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => HostelHome()));
                },
              ),

              ///Search User Button
              ListTile(
                leading: const Icon(Icons.search_outlined),
                horizontalTitleGap: 0,
                title: const Text("Search User"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => const searchUser()));
                },
              ),

              ///Create Hostel
              // if (userRole == 'ADMIN' || userRole == 'HAS')
              ListTile(
                leading: const Icon(Icons.account_balance_outlined),
                horizontalTitleGap: 0,
                title: const Text("Create Hostel"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => CreateHostel()));
                },
              ),

              ///Create Tag
              // if (userRole == 'ADMIN' ||
              //     userRole == "HAS" ||
              //     userRole == "SECRETORY")
              ListTile(
                leading: const Icon(Icons.add_outlined),
                horizontalTitleGap: 0,
                title: const Text('Create Tag'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => CreateTag()));
                },
              ),

              ///Create Account
              // if (userRole == "ADMIN" ||
              //     userRole == "HAS" ||
              //     userRole == "SECRETORY")
              ListTile(
                leading: const Icon(Icons.addchart_outlined),
                horizontalTitleGap: 0,
                title: const Text('Create Accounts'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => CreateSuperUsers()));
                },
              ),

              ///Update Role
              // if (userRole == "ADMIN" ||
              //     userRole == "HAS" ||
              //     userRole == "SECRETORY" ||
              //     userRole == "HOSTEL_SEC" ||
              //     userRole == "LEADS")
              ListTile(
                leading: const Icon(Icons.upgrade),
                horizontalTitleGap: 0,
                title: const Text('Update Role'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => UpdateRole()));
                },
              ),

              ///About us Page Button
              // if (userRole == "USER" || userRole == "MODERATOR")
              ListTile(
                leading: const Icon(Icons.alternate_email),
                horizontalTitleGap: 0,
                title: const Text("About Us"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => AboutUs()));
                },
              ),

              ///Contact Us Page Button
              // if (userRole == "USER" || userRole == 'MODERATOR')
              ListTile(
                leading: const Icon(Icons.contact_page_outlined),
                horizontalTitleGap: 0,
                title: const Text("Contact Us"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => ContactUs()));
                },
              ),

              ///Feedback Page Button
              // if (userRole == "USER" || userRole == 'MODERATOR')
              ListTile(
                leading: const Icon(Icons.feedback_outlined),
                horizontalTitleGap: 0,
                title: const Text("Feedback"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => FeedBack()));
                },
              ),

              ///Feedbacks sheet for Admin
              // if (userRole == "ADMIN" || userRole == 'HAS')
              ListTile(
                leading: const Icon(Icons.feedback_outlined),
                horizontalTitleGap: 0,
                title: const Text("Feedbacks"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => FeedbackPage()));
                },
              ),

              ///reported list
              // if (userRole == "ADMIN" || userRole == 'HAS')
              ListTile(
                leading: const Icon(Icons.account_circle_outlined),
                horizontalTitleGap: 0,
                title: const Text("Reported"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => Reported()));
                },
              ),

              /// Logout Button
              // Mutation(
              //   options: MutationOptions(
              //       document: gql("logOut"),
              //       onCompleted: (result) async {
              //         print("logout result:$result");
              //         if (result?["logout"] == true) {
              //           await _auth.clearAuth();
              //           await _auth.clearMe();
              //         }
              //       }),
              //   builder: (RunMutation runMutation, QueryResult? result) {
              //     if (result!.hasException) {
              //       print(result.exception.toString());
              //     }
              //     return ListTile(
              //       leading: const Icon(Icons.logout),
              //       horizontalTitleGap: 0,
              //       title: const Text("Logout"),
              //       onTap: () {
              //         print("fcmToken logout : $fcmToken");
              //         runMutation({
              //           "fcmToken": fcmToken,
              //         });
              //       },
              //     );
              //   },
              // ),
            ],
          );
        },
      ),
    );
  }
}
