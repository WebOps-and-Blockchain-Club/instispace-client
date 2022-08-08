import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/widgets/button/elevated_button.dart';
import 'package:http_parser/http_parser.dart';

import 'package:client/widgets/button/icon_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

import '../themes.dart';

class ImagePickerService extends ChangeNotifier {
  final int noOfImages;
  final int quality;
  ImagePicker? _picker;
  List<XFile>? _imageFileList;
  dynamic _pickImageError;

  ImagePickerService({this.noOfImages = 1, this.quality = 20}) {
    _initImagePicker();
    notifyListeners();
  }

  _initImagePicker() {
    _picker ??= ImagePicker();
  }

  Future<void> _onImageButtonPressed({
    required int preSelectedNoOfImages,
    BuildContext? context,
  }) async {
    await _displayPickImageDialog(context!, (ImageSource source) async {
      _initImagePicker();
      if (noOfImages != 1 && source == ImageSource.gallery) {
        try {
          final List<XFile>? pickedFileList = await _picker!.pickMultiImage(
            imageQuality: quality,
          );
          if (pickedFileList != null &&
              pickedFileList.length > (noOfImages - preSelectedNoOfImages)) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      'Not allowed to select more that $noOfImages images')),
            );
          } else {
            _imageFileList = (_imageFileList ?? []) + (pickedFileList ?? []);
          }
        } catch (e) {
          _pickImageError = e;
        }
      } else {
        try {
          final XFile? pickedFile = await _picker!.pickImage(
            source: source,
            imageQuality: quality,
          );
          _imageFileList = (_imageFileList ?? []) +
              (pickedFile != null ? <XFile>[pickedFile] : []);
        } catch (e) {
          _pickImageError = e;
        }
      }
      notifyListeners();
    });
  }

  Future<void> _displayPickImageDialog(
      BuildContext context, OnPickImageCallback onPick) async {
    _initImagePicker();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Pick Image'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextButton(
                    onPressed: () {
                      onPick(ImageSource.gallery);
                      Navigator.of(context).pop();
                    },
                    child: const Text("Gallery")),
                TextButton(
                    onPressed: () {
                      onPick(ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                    child: const Text("Take Photo")),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  List<XFile>? get() => _imageFileList;

  Future<List<MultipartFile>?> getMultipartFiles() async {
    List<MultipartFile> files = [];
    if (_imageFileList != null && _imageFileList!.isNotEmpty) {
      for (var item in _imageFileList!) {
        var byteData = await item.readAsBytes();

        var multipartFile = MultipartFile.fromBytes(
          'photo',
          byteData,
          filename: '${DateTime.now().second}.jpg',
          contentType: MediaType("image", "jpg"),
        );

        files.add(multipartFile);
      }
      return files;
    } else {
      return null;
    }
  }

  Widget previewImages(
      {EdgeInsetsGeometry padding = const EdgeInsets.only(top: 10),
      List<String>? imageUrls,
      Function? removeImageUrl}) {
    if ((_imageFileList != null && _imageFileList!.isNotEmpty) ||
        (imageUrls != null && imageUrls.isNotEmpty)) {
      return Padding(
        padding: padding,
        child: SizedBox(
          height: 250,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              if (imageUrls != null && imageUrls.isNotEmpty)
                ListView.builder(
                    itemCount: imageUrls.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: Stack(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 60,
                                child: CachedNetworkImage(
                                  imageUrl: imageUrls[index],
                                  placeholder: (_, __) =>
                                      const Icon(Icons.image, size: 100),
                                  errorWidget: (_, __, ___) =>
                                      const Icon(Icons.image, size: 100),
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                  top: 5,
                                  right: 5,
                                  child: CustomIconButton(
                                    icon: Icons.close,
                                    onPressed: () {
                                      if (removeImageUrl != null) {
                                        removeImageUrl(index);
                                      }
                                    },
                                    size: 3,
                                  ))
                            ],
                          ),
                        )),
              if (_imageFileList != null && _imageFileList!.isNotEmpty)
                ListView.builder(
                    itemCount: _imageFileList!.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: Stack(
                            children: [
                              Container(
                                color: Colors.white,
                                width: MediaQuery.of(context).size.width - 60,
                                constraints:
                                    const BoxConstraints(maxHeight: 250),
                                child: Image.file(
                                    File(_imageFileList![index].path),
                                    fit: BoxFit.fitWidth),
                              ),
                              Positioned(
                                  top: 5,
                                  right: 5,
                                  child: CustomIconButton(
                                    icon: Icons.close,
                                    onPressed: () {
                                      _imageFileList!.removeAt(index);
                                      notifyListeners();
                                    },
                                    size: 3,
                                  ))
                            ],
                          ),
                        )),
            ],
          ),
        ),
      );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const SizedBox(width: 0, height: 0);
    }
  }

  Widget pickImageButton(
      {required BuildContext context, int preSelectedNoOfImages = 0}) {
    _initImagePicker();
    return CustomElevatedButton(
      onPressed: () {
        if (((_imageFileList != null ? _imageFileList!.length : 0) +
                preSelectedNoOfImages) >=
            noOfImages) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Not allowed to select more that $noOfImages images')),
          );
        } else {
          _onImageButtonPressed(
              preSelectedNoOfImages: preSelectedNoOfImages, context: context);
        }
      },
      text: "Select Image",
      color: ColorPalette.palette(context).primary,
      type: ButtonType.outlined,
    );
  }
}

typedef OnPickImageCallback = void Function(ImageSource source);
