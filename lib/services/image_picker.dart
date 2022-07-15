import 'dart:io';
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

  void _setImageFileListFromFile(XFile? value) {
    _imageFileList = value == null ? null : <XFile>[value];
  }

  Future<void> _onImageButtonPressed({
    BuildContext? context,
  }) async {
    await _displayPickImageDialog(context!, (ImageSource source) async {
      _initImagePicker();
      if (noOfImages != 1 && source == ImageSource.gallery) {
        try {
          final List<XFile>? pickedFileList = await _picker!.pickMultiImage(
            imageQuality: quality,
          );
          _imageFileList = pickedFileList;
        } catch (e) {
          _pickImageError = e;
        }
      } else {
        try {
          final XFile? pickedFile = await _picker!.pickImage(
            source: source,
            imageQuality: quality,
          );
          _setImageFileListFromFile(pickedFile);
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
      {EdgeInsetsGeometry padding = const EdgeInsets.only(top: 10)}) {
    if (_imageFileList != null && _imageFileList!.isNotEmpty) {
      return Padding(
        padding: padding,
        child: SizedBox(
          height: 250,
          child: ListView.builder(
              itemCount: _imageFileList!.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Stack(
                      children: [
                        Container(
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width - 60,
                          constraints: const BoxConstraints(maxHeight: 250),
                          child: Image.file(File(_imageFileList![index].path),
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

  Widget pickImageButton(BuildContext context) {
    _initImagePicker();
    return CustomElevatedButton(
      onPressed: () {
        _onImageButtonPressed(context: context);
      },
      text: "Select Image",
      color: ColorPalette.palette(context).primary,
      type: ButtonType.outlined,
    );
  }
}

typedef OnPickImageCallback = void Function(ImageSource source);
