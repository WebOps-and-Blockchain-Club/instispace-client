import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
          icon: const Icon(
            CustomIcons.hamburger,
            size: 20,
            color: Color(0xFF3C3C3C),
          ),
        ),
        centerTitle: true,
        title: Text(
          title.toUpperCase(),
          style: const TextStyle(
              letterSpacing: 1,
              color: Color(0xFF3C3C3C),
              fontSize: 20,
              fontWeight: FontWeight.w700),
        ),
        actions: [
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
        ]);
  }
}
