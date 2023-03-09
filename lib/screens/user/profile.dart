import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/screens/super_user/approve_post.dart';
import 'package:client/widgets/app_bar.dart';
import 'package:client/widgets/helpers/navigate.dart';
import 'package:client/widgets/profile_icon.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../models/post/query_variable.dart';
import '../../widgets/card/image_view.dart';
import '../../widgets/helpers/loading.dart';
import '../../../widgets/button/elevated_button.dart';
import '../../../widgets/button/icon_button.dart';
import '../../../widgets/headers/main.dart';
import '../../models/user.dart';
import '../../themes.dart';
import '../../widgets/helpers/error.dart';
import '../../widgets/utils/image_cache_path.dart';
import './edit_profile.dart';
import '../../services/auth.dart';

class Profile extends StatelessWidget {
  final UserModel? user;
  final QueryResult? result;
  final Map<String, String>? userDetails;
  final AuthService auth = AuthService();
  final Future<QueryResult<Object?>?> Function()? refetch;
  final bool isMyProfile;

  Profile(
      {Key? key,
      this.user,
      this.result,
      this.userDetails,
      this.refetch,
      this.isMyProfile = true})
      : super(key: key);

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  _sendInviteMail(String email, String name) async {
    final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: encodeQueryParameters({
        'subject': 'Your friend is inviting you to InstiSpace App',
        'body':
            'Hey $name!\n\nYou can now access the InstiSpace app developed by Webops and Blockchain Club, CFI. InstiSpace is your one-stop destination for all things insti. Everything from insti news to lost-and-found, InstiSpace is your go-to place for networking, connecting, updates, announcements and more.\n\nYou can stay up to date with the happenings in your hostel. You can also find out about various events and opportunities across the insti.\nSo, join me on the app through the link below.\n\nApp Store: https://apps.apple.com/app/instispace-iit-madras/id1619779076\nGoogle Play Store: https://play.google.com/store/apps/details?id=com.cfi.instispace',
      }),
    );
    await launchUrlString(_emailLaunchUri.toString());
  }

  //Controllers
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    UserModel? _user;
    if (user != null) {
      _user = user;
    } else if (result != null && result!.data != null) {
      _user = (user == null && result != null)
          ? ((result!.data!["getUser"] == null && userDetails != null)
              ? UserModel(
                  role: "USER",
                  roll: userDetails!["roll"],
                  ldapName: userDetails!["ldapName"],
                  photo: userDetails!["photo"]!,
                  isNewUser: true,
                  permissions: [])
              : UserModel.fromJson(result!.data!["getUser"]))
          : user!;
    }
    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            child: NestedScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: _scrollController,
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [secondaryAppBar(title: 'PROFILE')];
                },
                body: RefreshIndicator(
                  onRefresh: () => refetch != null
                      ? refetch!()
                      : Future.delayed(const Duration(seconds: 0)),
                  child: Stack(children: [
                    ListView(),
                    (() {
                      if (result != null && result!.isLoading) {
                        return const Loading();
                      }

                      if ((result != null && result!.hasException) ||
                          _user == null) {
                        return Error(
                          error: result!.exception.toString(),
                          onRefresh: refetch,
                        );
                      }

                      return ListView(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              List<String> images =
                                  await imageCachePath([_user!.photo]);
                              openImageView(context, 0, images);
                            },
                            child: ProfileIconWidget(
                                photo: _user.photo, size: 100),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: Text(
                              _user.ldapName == null || _user.ldapName!.isEmpty
                                  ? _user.name?.toUpperCase() ?? ""
                                  : _user.ldapName?.toUpperCase() ?? "",
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w400),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Center(
                            child: Text(
                              _user.roll?.toUpperCase() ?? "",
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w400),
                            ),
                          ),
                          const SizedBox(height: 5),
                          if (_user.role != "USER")
                            Center(
                              child: Text('Role : ${_user.role!}',
                                  style:
                                      Theme.of(context).textTheme.titleSmall),
                            ),
                          if (isMyProfile)
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomElevatedButton(
                                      textSize: 12,
                                      onPressed: (() => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => EditProfile(
                                                    auth: auth,
                                                    user: user!,
                                                  )))),
                                      text: "EDIT PROFILE"),
                                ],
                              ),
                            ),
                          if (isMyProfile)
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 30),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                    color: const Color(0xFFE1E0EC),
                                    borderRadius: BorderRadius.circular(30)),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    GestureDetector(
                                      onTap: () => navigate(
                                          context,
                                          SuperUserPostPage(
                                            title: "Posts Created",
                                            filterVariables:
                                                PostQueryVariableModel(
                                                    createdByMe: true),
                                          )),
                                      child: const Text(
                                        "Posts Created by you",
                                        style: TextStyle(fontSize: 17),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 4),
                                      child: Divider(
                                        color: Color(0xFFBEBEBE),
                                      ),
                                    ),
                                    // const GestureDetector(
                                    //   child: Text(
                                    //     "Reminder Posts",
                                    //     style: TextStyle(fontSize: 17),
                                    //   ),
                                    // ),
                                    // const Padding(
                                    //   padding: EdgeInsets.symmetric(
                                    //       vertical: 8.0, horizontal: 4),
                                    //   child: Divider(
                                    //     color: Color(0xFFBEBEBE),
                                    //   ),
                                    // ),
                                    GestureDetector(
                                      onTap: () => navigate(
                                          context,
                                          SuperUserPostPage(
                                            title: "Liked Posts",
                                            filterVariables:
                                                PostQueryVariableModel(
                                                    isLiked: true),
                                          )),
                                      child: const Text(
                                        "Posts Liked by you",
                                        style: TextStyle(fontSize: 17),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          const SizedBox(height: 20),
                          if (_user.interets != null &&
                              _user.interets!.isNotEmpty)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: Text(
                                      "Followed tags",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15.0, bottom: 20),
                                    child: Wrap(
                                      spacing: 5,
                                      runSpacing: 5,
                                      children: List.generate(
                                          _user.interets!.length, (index) {
                                        return Chip(
                                          label: Text(
                                              _user!.interets![index].title),
                                          padding: const EdgeInsets.all(4),
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        );
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if ((_user.id == null || _user.id!.isEmpty) &&
                              _user.ldapName != null &&
                              _user.ldapName!.isNotEmpty)
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15.0),
                                      child: Text(
                                        "User is not registered.\nDo you like to invite the user?",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: CustomElevatedButton(
                                        onPressed: () {
                                          _sendInviteMail(
                                              _user!.roll! +
                                                  "@smail.iitm.ac.in",
                                              _user.ldapName!);
                                        },
                                        text: "Invite ${_user.ldapName}",
                                      ),
                                    )
                                  ],
                                )),
                        ],
                      );
                    }()),
                  ]),
                )),
          ),
        ),
        // const Positioned(
        //     top: -50,
        //     right: -90,
        //     child: Image(
        //         width: 300,
        //         image: AssetImage('assets/illustrations/decor.png')))
      ],
    );
  }
}
