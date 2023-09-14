import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/widgets/utils/image_cache_path.dart';
import 'package:flutter/material.dart';

import '../utils/custom_icons.dart';
import 'card/image_view.dart';

class HomeAppBar extends StatelessWidget {
  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String photo;

  const HomeAppBar(
      {Key? key,
      required this.title,
      required this.scaffoldKey,
      required this.photo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
        leading: IconButton(
          padding: const EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          // onPressed: () {},
          onPressed: () => scaffoldKey.currentState!.openDrawer(),
          icon: const Icon(
            CustomIcons.hamburger,
            size: 24,
            color: Color(0xFF3C3C3C),
          ),
        ),
        centerTitle: true,
        title: Text(
          title.toUpperCase(),
          style: TextStyle(
              letterSpacing: title.length <= 9 ? 2.64 : null,
              color: const Color(0xFF3C3C3C),
              fontSize: 24,
              fontWeight: FontWeight.w700),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () async {
                List<String> images = await imageCachePath([photo]);
                openImageView(context, 0, images);
              },
              child: CachedNetworkImage(
                imageUrl: photo,
                placeholder: (_, __) =>
                    const Icon(Icons.account_circle_rounded, size: 50),
                errorWidget: (_, __, ___) =>
                    const Icon(Icons.account_circle_rounded, size: 50),
                imageBuilder: (context, imageProvider) => Container(
                  height: 45,
                  width: 45,
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
