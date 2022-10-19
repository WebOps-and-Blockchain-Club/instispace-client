import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

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

  Profile({Key? key, this.user, this.result, this.userDetails, this.refetch})
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
                  ldapName: userDetails!["name"],
                  photo: userDetails!["photo"]!,
                  isNewUser: true,
                  permissions: [])
              : UserModel.fromJson(result!.data!["getUser"]))
          : user!;
    }
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: NestedScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return CustomAppBar(
                        title: _user == null
                            ? ""
                            : _user.name == null
                                ? _user.ldapName!
                                : _user.name!,
                        leading: CustomIconButton(
                          icon: Icons.arrow_back,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        action: CustomIconButton(
                          icon: Icons.edit,
                          onPressed: () {
                            //Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProfile(
                                          auth: auth,
                                          user: user!,
                                        )));
                          },
                        ),
                      );
                    }, childCount: 1),
                  ),
                ];
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
                      return Error(error: result!.exception.toString());
                    }

                    return ListView(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            List<String> images =
                                await imageCachePath([_user!.photo]);
                            openImageView(context, 0, images);
                          },
                          child: CachedNetworkImage(
                            imageUrl: _user.photo,
                            placeholder: (_, __) => const Icon(
                                Icons.account_circle_rounded,
                                size: 100),
                            errorWidget: (_, __, ___) => const Icon(
                                Icons.account_circle_rounded,
                                size: 100),
                            imageBuilder: (context, imageProvider) => Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Text(
                            _user.ldapName == null || _user.ldapName!.isEmpty
                                ? _user.name!
                                : _user.ldapName!,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Center(
                          child: Text(
                            _user.roll!.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                    color:
                                        ColorPalette.palette(context).secondary,
                                    fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(height: 5),
                        if (_user.role != "USER")
                          Center(
                            child: Text(
                              'Role : ${_user.role!}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                      color:
                                          ColorPalette.palette(context).primary,
                                      fontWeight: FontWeight.w500),
                            ),
                          ),
                        const SizedBox(height: 20),
                        if (_user.interets != null &&
                            _user.interets!.isNotEmpty)
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1.5,
                                color: ColorPalette.palette(context).secondary,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: Text(
                                    "Tags you wish to follow",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, bottom: 20),
                                  child: Wrap(
                                    spacing: 5,
                                    runSpacing: 5,
                                    children: List.generate(
                                        _user.interets!.length, (index) {
                                      return Chip(
                                        label:
                                            Text(_user!.interets![index].title),
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
                          Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1.5,
                                  color:
                                      ColorPalette.palette(context).secondary,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                              ),
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
                                            _user!.roll! + "@smail.iitm.ac.in",
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
    );
  }
}
