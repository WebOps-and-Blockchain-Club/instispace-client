import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../widgets/button/elevated_button.dart';
import '../../../widgets/button/icon_button.dart';
import '../../../widgets/headers/main.dart';
import '../../models/user.dart';
import '../../themes.dart';

class Profile extends StatelessWidget {
  final UserModel? user;
  final QueryResult? result;
  final Map<String, String>? userDetails;
  final Future<QueryResult<Object?>?> Function()? refetch;
  const Profile(
      {Key? key, this.user, this.result, this.userDetails, this.refetch})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: (() {
              if (result != null && result!.hasException) {
                return ListView(
                  children: [
                    CustomAppBar(
                        title: "",
                        leading: CustomIconButton(
                          icon: Icons.arrow_back,
                          onPressed: () => Navigator.of(context).pop(),
                        )),
                    SelectableText(result!.exception.toString()),
                  ],
                );
              }
              if (result != null && result!.isLoading) {
                return ListView(
                  children: [
                    CustomAppBar(
                        title: "",
                        leading: CustomIconButton(
                          icon: Icons.arrow_back,
                          onPressed: () => Navigator.of(context).pop(),
                        )),
                    const Text("Loading"),
                  ],
                );
              }
              final UserModel _user = (user == null && result != null)
                  ? ((result!.data!["getUser"] == null && userDetails != null)
                      ? UserModel(
                          role: "",
                          roll: userDetails!["roll"],
                          ldapName: userDetails!["name"],
                          isNewUser: true,
                          permissions: [])
                      : UserModel.fromJson(result!.data!["getUser"]))
                  : user!;

              return ListView(children: [
                CustomAppBar(
                    title: _user.name == null ? _user.ldapName! : _user.name!,
                    leading: CustomIconButton(
                      icon: Icons.arrow_back,
                      onPressed: () => Navigator.of(context).pop(),
                    )),
                const SizedBox(height: 20),
                CachedNetworkImage(
                  imageUrl:
                      'https://photos.iitm.ac.in/byroll.php?roll=${_user.roll?.toUpperCase()}',
                  placeholder: (_, __) =>
                      const Icon(Icons.account_circle_rounded, size: 100),
                  errorWidget: (_, __, ___) =>
                      const Icon(Icons.account_circle_rounded, size: 100),
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
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    _user.ldapName == null || _user.ldapName!.isEmpty
                        ? _user.name!
                        : _user.ldapName!,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Center(
                  child: Text(
                    _user.roll!.toUpperCase(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: ColorPalette.palette(context).secondary,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 20),
                if (_user.interets != null && _user.interets!.isNotEmpty)
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1.5,
                        color: ColorPalette.palette(context).secondary,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Text(
                            "Followed Tags",
                            style: Theme.of(context).textTheme.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, bottom: 20),
                          child: Wrap(
                            spacing: 5,
                            runSpacing: 5,
                            children:
                                List.generate(_user.interets!.length, (index) {
                              return Chip(
                                label: Text(_user.interets![index].title),
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
                              "User is not registered.\nDo you like to invite the user?",
                              style: Theme.of(context).textTheme.titleMedium,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: CustomElevatedButton(
                              onPressed: () {},
                              text: "Invite ${_user.ldapName}",
                            ),
                          )
                        ],
                      )),
              ]);
            }())),
      ),
    );
  }
}
