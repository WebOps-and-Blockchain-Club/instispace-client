import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'dart:math';
import '../utils/image_cache_path.dart';
import 'image_view.dart';

class ImageCard extends StatefulWidget {
  final List<String> imageUrls;
  const ImageCard({Key? key, required this.imageUrls}) : super(key: key);

  @override
  State<ImageCard> createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  double minHeight = 0;
  var imageProviders = [];

  void getMinHeight(List<String> imageUrls) {
    var _imageProviders = [];
    for (var imageUrl in imageUrls) {
      var imageProvider = CachedNetworkImageProvider(imageUrl);
      Image image = Image(
        image: imageProvider,
      );
      _imageProviders.add(imageProvider);
      image.image.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener(
          (ImageInfo image, bool synchronousCall) {
            var myImage = image.image;

            double c = myImage.width.toDouble() /
                (MediaQuery.of(context).size.width - 80.toDouble());
            if (myImage.height.toDouble() / c >= minHeight) {
              setState(() {
                minHeight = myImage.height.toDouble() / c;
              });
            }
          },
        ),
      );
    }
    setState(() {
      imageProviders = _imageProviders;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrls.isNotEmpty) {
      getMinHeight(widget.imageUrls);
    }
    final imageUrls = widget.imageUrls;
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(29)),
      constraints: BoxConstraints(maxHeight: min(500, minHeight), minHeight: 0),
      child: Swiper(
        onTap: (index) async {
          List<String> images = await imageCachePath(imageUrls);
          openImageView(context, index, images);
        },
        loop: imageProviders.length != 1,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.only(bottom: imageProviders.length > 1 ? 15 : 0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(29),
                image: DecorationImage(
                  image: imageProviders[index],
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          );
        },
        itemCount: imageProviders.length,
        pagination: imageProviders.length > 1
            ? SwiperCustomPagination(
                builder: (BuildContext context, SwiperPluginConfig config) {
                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      children: [
                        const Spacer(),
                        for (var i = 0; i < imageProviders.length; i++)
                          Container(
                            margin: const EdgeInsets.all(3),
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                                color: config.activeIndex == i
                                    ? Colors.black
                                    : Colors.black26,
                                shape: BoxShape.circle),
                          ),
                        const Spacer()
                      ],
                    ),
                  );
                },
              )
            : null,
      ),
    );
  }
}
