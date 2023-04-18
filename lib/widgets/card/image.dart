import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math';
import '../utils/image_cache_path.dart';
import 'image_view.dart';
import 'dart:io' as io;

class ImageCard extends StatefulWidget {
  final List<String>? imageUrls;
  final List<XFile>? imageFiles;
  final Function? onDelete;
  final Map<dynamic, String>? dynamic_images;

  const ImageCard({
    Key? key,
    this.imageUrls,
    this.dynamic_images,
    this.onDelete,
    this.imageFiles,
  }) : super(key: key);

  @override
  State<ImageCard> createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  double minHeight = 0;
  var imageProviders = [];
  Map<dynamic, String>? dynamic_images;

  void getMinHeight(List<dynamic> images) {
    var _imageProviders = [];
    for (var imageUrl in images) {
      var imageProvider = (widget.dynamic_images != null &&
              widget.dynamic_images![imageUrl] == 'file')
          ? FileImage(imageUrl)
          : (widget.imageFiles != null)
              ? FileImage(io.File(imageUrl.path)) as ImageProvider
              : CachedNetworkImageProvider(imageUrl);

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
    setState(() {
      dynamic_images = widget.dynamic_images;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrls != null && widget.imageUrls!.isNotEmpty) {
      getMinHeight(widget.imageUrls!);
    } else if (widget.dynamic_images != null &&
        widget.dynamic_images!.isNotEmpty) {
      getMinHeight(widget.dynamic_images!.keys.toList());
    } else if (widget.imageFiles != null) {
      getMinHeight(widget.imageFiles!);
    }
    final imageUrls = (widget.imageFiles != null)
        ? widget.imageFiles
        : (widget.imageUrls != null)
            ? widget.imageUrls
            : dynamic_images?.keys;

    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(29)),
      constraints: BoxConstraints(maxHeight: min(500, minHeight), minHeight: 0),
      child: Stack(
        children: [
          Swiper(
            onTap: (index) async {
              List<String> images = (widget.imageUrls != null)
                  ? await imageCachePath(imageUrls as List<String>)
                  : (widget.imageFiles != null)
                      ? imageUrls!.map((e) => e.path) as List<String>
                      : imageUrls!.map((e) async {
                          return (e.value) == 'file'
                              ? e.key.path
                              : (await imageCachePath([e.key] as List<String>))
                                  .first;
                        }) as List<String>;

              openImageView(context, index, images);
            },
            loop: imageProviders.length != 1,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin:
                    EdgeInsets.only(bottom: imageProviders.length > 1 ? 15 : 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: imageProviders[index],
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  child: (widget.onDelete != null)
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: Colors.white,
                            size: 40,
                            shadows: <Shadow>[
                              BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 20,
                                  spreadRadius: 20,
                                  offset: Offset(2, 2))
                            ],
                          ),
                          onPressed: () {
                            widget.onDelete!(
                                dynamic_images?.keys.elementAt(index) ??
                                    io.File(widget.imageFiles![index].path));
                          },
                        )
                      : null,
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
        ],
      ),
    );
  }
}
