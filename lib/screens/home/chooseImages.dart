import 'package:client/screens/home/newPost.dart';
import 'package:client/themes.dart';
import 'package:client/utils/my_flutter_app_icons.dart';
import 'package:client/widgets/card/image_view.dart';
import 'package:client/widgets/headers/main.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class ChooseImages extends StatefulWidget {
  const ChooseImages({Key? key}) : super(key: key);

  @override
  State<ChooseImages> createState() => _ChooseImagesState();
}

class _ChooseImagesState extends State<ChooseImages> {
  late List images = [];
  late List chosenImgs = [];
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
                        onPressed: () => Navigator.push(context,
                            MaterialPageRoute(builder: (context) => NewPost())),
                      ),
                      leading: const Padding(
                        padding: EdgeInsets.only(right: 30.0),
                        child: Icon(MyFlutterApp.hamburger),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 30),
                    height: 400,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        image: chosenImgs.isNotEmpty
                            ? DecorationImage(
                                image: FileImage(chosenImgs.first),
                                fit: BoxFit.cover,
                              )
                            : const DecorationImage(
                                image: AssetImage(
                                    'assets/illustrations/no_data.svg'))),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Camera',
                            style: TextStyle(color: Colors.black),
                          )),
                      TextButton(
                          onPressed: () {},
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
                              setState(() {
                                chosenImgs.add(images[index]);
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
