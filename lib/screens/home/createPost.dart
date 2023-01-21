import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({Key? key}) : super(key: key);

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  late List images = [];
  dynamic chosenImg;
  bool initialized = false;
  @override
  void initState() {
    _getImages();
    setState(() {
      initialized = true;
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
          await paths[0].getAssetListPaged(page: 0, size: 24);
      for (var e in entities_list) {
        if (e.type == AssetType.image) {
          final file = await e.file;
          if (entities_list.first == e) {
            setState(() {
              chosenImg = file;
            });
          }

          setState(() {
            images.add(file);
          });
        }
      }
    } else {
      await PhotoManager.openSetting();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: initialized == true
            ? Column(
                children: [
                  if (chosenImg != null)
                    Image(
                      image: FileImage(chosenImg),
                      height: 300,
                      fit: BoxFit.fill,
                    ),
                  Expanded(
                    child: GridView.builder(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisSpacing: 0,
                                crossAxisSpacing: 0,
                                childAspectRatio: 1),
                        itemCount: images.length,
                        itemBuilder: (BuildContext context, index) {
                          return Image.file(
                            images[index],
                            scale: 1.5,
                            fit: BoxFit.cover,
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
