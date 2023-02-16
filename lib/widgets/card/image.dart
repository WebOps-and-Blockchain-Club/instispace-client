import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math';
import '../utils/image_cache_path.dart';
import 'image_view.dart';

class ImageCard extends StatelessWidget {
  final List<String> imageUrls;
  final double? minHeight;
  const ImageCard({
    Key? key,
    required this.imageUrls,
    this.minHeight,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
          maxHeight: min(500, minHeight ?? minHeight!), minHeight: 0),
      child: Swiper(
        onTap: (index) async {
          List<String> images = await imageCachePath(imageUrls);
          openImageView(context, index, images);
        },
        loop: imageUrls.length != 1,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: imageUrls.length > 1
                ? EdgeInsets.only(bottom: 15)
                : EdgeInsets.only(bottom: 0),
            child: CachedNetworkImage(
              imageUrl: imageUrls[index],
              placeholder: (_, __) => const Icon(Icons.image, size: 100),
              errorWidget: (_, __, ___) => const Icon(Icons.image, size: 100),
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(29),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
          )
              //SizedBox(height: 20),
              ;
        },
        itemCount: imageUrls.length,
        pagination: imageUrls.length > 1
            ? SwiperCustomPagination(
                builder: (BuildContext context, SwiperPluginConfig config) {
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      new Spacer(),
                      for (var i = 0; i < imageUrls.length; i++)
                        Container(
                          margin: EdgeInsets.all(3),
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                              color: config.activeIndex == i
                                  ? Colors.black
                                  : Colors.black26,
                              shape: BoxShape.circle),
                        ),
                      new Spacer()
                    ],
                  ),
                );
                /*Positioned(
            top: 5,
            right: 5,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Text('${config.activeIndex + 1}/${imageUrls.length}'),
            ),
          );*/
              })
            : null,
      ),
    );
  }
}
