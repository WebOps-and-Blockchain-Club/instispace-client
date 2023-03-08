import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileIconWidget extends StatelessWidget {
  final String photo;
  final double size;
  final String type;
  const ProfileIconWidget(
      {Key? key, required this.photo, this.size = 40, this.type = 'network'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (type != 'network') {
      return Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: FileImage(File(photo)),
            fit: BoxFit.contain,
          ),
        ),
      );
    }
    return CachedNetworkImage(
      imageUrl: photo,
      placeholder: (_, __) => Icon(Icons.account_circle_rounded, size: size),
      errorWidget: (_, __, ___) =>
          Icon(Icons.account_circle_rounded, size: size),
      imageBuilder: (context, imageProvider) => Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
