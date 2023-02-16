import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

import '../utils/image_cache_path.dart';
import 'image_view.dart';

class ImageCard extends StatelessWidget {
  final List<String> imageUrls;
  const ImageCard({Key? key, required this.imageUrls}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 250, minHeight: 0),
      child: Swiper(
        onTap: (index) async {
          List<String> images = await imageCachePath(imageUrls);
          openImageView(context, index, images);
        },
        loop: imageUrls.length != 1,
        itemBuilder: (BuildContext context, int index) {
          return CachedNetworkImage(
            imageUrl: imageUrls[index],
            placeholder: (_, __) => const Icon(Icons.image, size: 100),
            errorWidget: (_, __, ___) => const Icon(Icons.image, size: 100),
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
        itemCount: imageUrls.length,
        pagination: SwiperCustomPagination(
            builder: (BuildContext context, SwiperPluginConfig config) {
          return Positioned(
            top: 5,
            right: 5,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Text('${config.activeIndex + 1}/${imageUrls.length}'),
            ),
          );
        }),
      ),
    );
  }
}
