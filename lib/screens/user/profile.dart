import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../widgets/button/elevated_button.dart';
import '../../../widgets/button/icon_button.dart';
import '../../../widgets/headers/main.dart';
import '../../models/user.dart';
import '../../themes.dart';

class Profile extends StatelessWidget {
  final UserModel user;
  const Profile({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ListView(children: [
            CustomAppBar(
                title: user.name == null ? user.ldapName! : user.name!,
                leading: CustomIconButton(
                  icon: Icons.arrow_back,
                  onPressed: () => Navigator.of(context).pop(),
                )),
            const SizedBox(height: 20),
            CachedNetworkImage(
              imageUrl:
                  'https://photos.iitm.ac.in/byroll.php?roll=${user.roll}',
              placeholder: (_, __) =>
                  const Icon(Icons.account_circle_rounded, size: 100),
              errorWidget: (_, __, ___) =>
                  const Icon(Icons.account_circle_rounded, size: 100),
              width: 100,
              height: 100,
              imageBuilder: (_, imageProvider) => CircleAvatar(
                backgroundImage: imageProvider,
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                user.ldapName == null || user.ldapName!.isEmpty
                    ? user.name!
                    : user.ldapName!,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Center(
              child: Text(
                user.roll!,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: ColorPalette.palette(context).secondary,
                    fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 20),
            if (user.interets != null && user.interets!.isNotEmpty)
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
                        children: List.generate(user.interets!.length, (index) {
                          return Chip(
                            label: Text(user.interets![index].title),
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
            if ((user.id == null || user.id!.isEmpty) &&
                user.ldapName != null &&
                user.ldapName!.isNotEmpty)
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
                          "User is not registered.\nDo you like to invite the user?",
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: CustomElevatedButton(
                          onPressed: () {},
                          text: "Invite ${user.ldapName}",
                        ),
                      )
                    ],
                  )),
          ]),
        ),
      ),
    );
  }
}
