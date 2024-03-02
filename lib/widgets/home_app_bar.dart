import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/services/local_storage.dart';
import 'package:client/widgets/theme_switch.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../services/theme_provider.dart';
import '/models/user.dart';
import '/screens/user/profile.dart';
import 'helpers/navigate.dart';
import '../utils/custom_icons.dart';

class HomeAppBar extends StatelessWidget {
  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final UserModel user;

  const HomeAppBar(
      {Key? key,
      required this.title,
      required this.scaffoldKey,
      required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
        leading: IconButton(
          padding: const EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          onPressed: () => scaffoldKey.currentState!.openDrawer(),
          icon: Icon(
            CustomIcons.hamburger,
            size: 20,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ),
        centerTitle: true,
        title: Text(
          title.toUpperCase(),
          style: TextStyle(
              letterSpacing: 1,
              color: Theme.of(context).textTheme.bodyLarge!.color,
              fontSize: 20,
              fontWeight: FontWeight.w700),
        ),
        actions: [
          Row(children: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: ThemeSwitch(
                  isDark:
                      context.read<ThemeProvider>().theme == ThemeMode.dark),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () {
                  navigate(context, Profile(user: user));
                },
                child: CachedNetworkImage(
                  imageUrl: user.photo,
                  placeholder: (_, __) =>
                      const Icon(Icons.account_circle_rounded, size: 43),
                  errorWidget: (_, __, ___) =>
                      const Icon(Icons.account_circle_rounded, size: 43),
                  imageBuilder: (context, imageProvider) => Container(
                    height: 40,
                    width: 40,
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
            ),
          ])
        ]);
  }
}
