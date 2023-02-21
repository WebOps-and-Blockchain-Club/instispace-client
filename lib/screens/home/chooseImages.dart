import 'package:client/screens/home/newPost.dart';
import 'package:client/services/image_picker.dart';
import 'package:client/themes.dart';
import 'package:client/utils/my_flutter_app_icons.dart';
import 'package:client/widgets/card/image_view.dart';
import 'package:client/widgets/headers/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../models/post/actions.dart';
import '../../models/post/create_post.dart';
import '../../widgets/button/icon_button.dart';

class SelectImageScreen extends StatefulWidget {
  final PostCategoryModel category;
  final CreatePostModel fieldConfiguration;

  const SelectImageScreen(
      {Key? key, required this.category, required this.fieldConfiguration})
      : super(key: key);

  @override
  State<SelectImageScreen> createState() => _SelectImageScreenState();
}

class _SelectImageScreenState extends State<SelectImageScreen> {
  final _controller = ScrollController();
  final ImagePicker _picker = ImagePicker();
  late List images = [];
  int page = 0;
  late List chosenImgs = [
    // "https://i.imgflip.com/51mkbd.png",
    // "https://thumbs.gfycat.com/PoorRealisticGermanpinscher-size_restricted.gif"
  ];
  bool initialized = false;
  int len = 0;

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
              letterSpacing: 2.64,
              color: Color(0xFF3C3C3C),
              fontSize: 24,
              fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: initialized == true
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                    child: CustomAppBar(
                        title: 'NEW POST',
                        action: TextButton(
                          child: Text(
                            'skip',
                            style: TextStyle(
                                color: ColorPalette.palette(context).secondary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NewPostScreen(
                                        category: widget.category,
                                        fieldConfiguration:
                                            widget.fieldConfiguration,
                                      ))),
                        ),
                        leading: CustomIconButton(
                          icon: Icons.arrow_back,
                          onPressed: () => Navigator.of(context).pop(),
                        )),
                  ),
                  if (chosenImgs.isEmpty)
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 30),
                      height: 340,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          image: const DecorationImage(
                              image: AssetImage(
                                  'assets/illustrations/no_data.svg'))),
                    ),
                  Expanded(
                    child: PageView.builder(
                        itemCount: chosenImgs.length,
                        itemBuilder: ((context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 30, horizontal: 30),
                            height: 340,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                image: DecorationImage(
                                  image: FileImage(chosenImgs[index]),
                                  fit: BoxFit.cover,
                                )),
                          );
                        })),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                          onPressed: () async {
                            final XFile? photo = await _picker.pickImage(
                                source: ImageSource.camera);
                            setState(() {
                              chosenImgs.add(photo);
                              len++;
                            });
                          },
                          child: const Text(
                            'Camera',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          )),
                      TextButton(
                          onPressed: () async {
                            final List<XFile>? photos =
                                await _picker.pickMultiImage();
                            if (photos != null && photos.isNotEmpty) {
                              setState(() {
                                chosenImgs.addAll(photos);
                                len++;
                              });
                            }
                          },
                          child: const Text(
                            'Open Gallery',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          )),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NewPostScreen(
                                          category: widget.category,
                                          images: chosenImgs,
                                          fieldConfiguration:
                                              widget.fieldConfiguration,
                                        )));
                          },
                          child: Text(
                            'Add Images',
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
                        itemCount: images.length,
                        itemBuilder: (BuildContext context, index) {
                          return GestureDetector(
                            onTap: () {
                              print('tapped $index');
                              print('${images[index]}');
                              setState(() {
                                chosenImgs.add(images[index]);
                                len++;
                              });
                            },
                            child: Image.file(
                              images[index],
                              scale: 1.5,
                              fit: BoxFit.cover,
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
