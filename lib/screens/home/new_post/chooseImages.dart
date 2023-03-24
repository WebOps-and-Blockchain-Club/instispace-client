import 'package:client/models/category.dart';
import 'package:client/screens/home/new_post/imageView.dart';
import 'package:client/screens/home/new_post/main.dart';
import 'package:client/screens/home/new_post/newPost.dart';
import 'package:client/services/image_picker.dart';
import 'package:client/themes.dart';
import 'package:client/utils/custom_icons.dart';
import 'package:client/utils/my_flutter_app_icons.dart';
import 'package:client/widgets/card/image_view.dart';
import 'package:client/widgets/headers/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:io' as io;

import '../../../models/post/create_post.dart';
import '../../../widgets/button/icon_button.dart';

class SelectImageScreen extends StatefulWidget {
  final PostCategoryModel category;
  final options;
  final CreatePostModel fieldConfiguration;

  const SelectImageScreen(
      {Key? key,
      required this.category,
      required this.fieldConfiguration,
      this.options})
      : super(key: key);

  @override
  State<SelectImageScreen> createState() => _SelectImageScreenState();
}

class _SelectImageScreenState extends State<SelectImageScreen> {
  final _controller = ScrollController();
  final ImagePicker _picker = ImagePicker();
  late List images = [];
  int page = 0;
  late List<io.File> chosenImgs = [];
  bool initialized = false;
  int len = 0;

  void onDelete(io.File f) {
    setState(() {
      chosenImgs.remove(f);
    });
  }

  @override
  void initState() {
    _getImages();
    setState(() {
      // chosenImgs.add(images[0]);
      initialized = true;
    });
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        _getImages();
      }
    });

    super.initState();
  }

  void _getImages() async {
    final PermissionState _ps = await PhotoManager.requestPermissionExtend();
    if (_ps.isAuth) {
      final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
        onlyAll: true,
      );
      final List<AssetEntity> entities_list =
          await paths[0].getAssetListPaged(page: page, size: (page + 1) * 24);
      for (var e in entities_list) {
        if (e.type == AssetType.image) {
          final file = await e.file;
          setState(() {
            images.add(file);
          });
        }
      }
      if (page == 0) {
        setState(() {
          chosenImgs.add(images[0]);
        });
      }
      setState(() {
        page++;
      });
    } else {
      await PhotoManager.openSetting();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "NEW POST",
          style: TextStyle(
              letterSpacing: 1,
              color: Color(0xFF3C3C3C),
              fontSize: 20,
              fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: initialized == true
            ? Column(
                children: [
                  ImageView(
                    images: chosenImgs,
                    onDelete: onDelete,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                          onPressed: () async {
                            setState(() {
                              chosenImgs = [];
                            });
                          },
                          child: const Text(
                            'Clear',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          )),
                      TextButton(
                          onPressed: () {
                            int max = getCreatePostFields[widget.category.name]!
                                .imagePrimary!
                                .maxImgs;
                            if (chosenImgs.length > max) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        "Images cannot be more than $max")),
                              );
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NewPostScreen(
                                            category: widget.category,
                                            images: chosenImgs,
                                            fieldConfiguration:
                                                widget.fieldConfiguration,
                                            options: widget.options,
                                          )));
                            }
                          },
                          child: Text(
                            'Save & Proceed',
                            style: TextStyle(
                                color: ColorPalette.palette(context).secondary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ))
                    ],
                  ),
                  Expanded(
                    child: GridView.builder(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        controller: _controller,
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisSpacing: 0,
                                crossAxisSpacing: 0,
                                childAspectRatio: 1),
                        itemCount: (images.length + 2),
                        itemBuilder: (BuildContext context, index) {
                          bool contains = (index == 0 || index == 1)
                              ? false
                              : chosenImgs.contains(images[index - 2]);

                          return Container(
                            color: const Color.fromRGBO(52, 47, 129, 0.4),
                            padding: contains
                                ? const EdgeInsets.all(8)
                                : EdgeInsets.zero,
                            child: GestureDetector(
                              onTap: () async {
                                if (index == 0) {
                                  final XFile? photo = await _picker.pickImage(
                                      source: ImageSource.camera);
                                  setState(() {
                                    if (photo != null) {
                                      chosenImgs.add(io.File(photo.path));
                                    }
                                  });
                                } else if (index == 1) {
                                  final List<XFile> photos =
                                      await _picker.pickMultiImage();
                                  if (photos.isNotEmpty) {
                                    List<io.File> files = [];
                                    for (XFile photo in photos) {
                                      files.add(io.File(photo.path));
                                    }
                                    setState(() {
                                      chosenImgs.addAll(files);
                                      len++;
                                    });
                                  }
                                } else if (contains) {
                                  setState(() {
                                    chosenImgs.remove(images[index - 2]);
                                  });
                                } else {
                                  setState(() {
                                    chosenImgs.add(images[index - 2]);
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    image: (index != 0 && index != 1)
                                        ? DecorationImage(
                                            image: FileImage(
                                              images[index - 2],
                                              scale: 1.5,
                                            ),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                    borderRadius: contains
                                        ? BorderRadius.circular(13)
                                        : BorderRadius.zero),
                                child: (index == 0)
                                    ? const Icon(
                                        CustomIcons.camera,
                                        color: Colors.black,
                                        size: 30,
                                      )
                                    : (index == 1)
                                        ? const Icon(
                                            CustomIcons.gallery,
                                            color: Colors.black,
                                            size: 30,
                                          )
                                        : null,
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
