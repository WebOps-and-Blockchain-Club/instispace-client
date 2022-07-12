import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerButton extends StatefulWidget {
  const ImagePickerButton({Key? key}) : super(key: key);

  @override
  State<ImagePickerButton> createState() => _ImagePickerButtonState();
}

class _ImagePickerButtonState extends State<ImagePickerButton> {
  List<XFile>? _imageFileList;

  void _setImageFileListFromFile(XFile? value) {
    _imageFileList = value == null ? null : <XFile>[value];
  }

  dynamic _pickImageError;

  String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();

  Future<void> _onImageButtonPressed(
      {double? maxWidth,
      double? maxHeight,
      int? quality,
      BuildContext? context,
      int noOfImages = 0}) async {
    await _displayPickImageDialog(context!, (ImageSource source) async {
      if (noOfImages != 0 && source == ImageSource.gallery) {
        try {
          final List<XFile>? pickedFileList = await _picker.pickMultiImage(
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            imageQuality: quality,
          );
          setState(() {
            _imageFileList = pickedFileList;
          });
        } catch (e) {
          setState(() {
            _pickImageError = e;
          });
        }
      } else {
        await _displayPickImageDialog(context, (ImageSource source) async {
          try {
            final XFile? pickedFile = await _picker.pickImage(
              source: source,
              maxWidth: maxWidth,
              maxHeight: maxHeight,
              imageQuality: quality,
            );
            setState(() {
              _setImageFileListFromFile(pickedFile);
            });
          } catch (e) {
            setState(() {
              _pickImageError = e;
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    maxWidthController.dispose();
    maxHeightController.dispose();
    qualityController.dispose();
    super.dispose();
  }

  Widget _previewImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFileList != null) {
      return Semantics(
        label: 'image_picker_example_picked_images',
        child: ListView.builder(
          key: UniqueKey(),
          itemBuilder: (BuildContext context, int index) {
            // Why network for web?
            // See https://pub.dev/packages/image_picker#getting-ready-for-the-web-platform
            return Semantics(
              label: 'image_picker_example_picked_image',
              child: kIsWeb
                  ? Image.network(_imageFileList![index].path)
                  : Image.file(File(_imageFileList![index].path)),
            );
          },
          itemCount: _imageFileList!.length,
        ),
      );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _handlePreview() {
    return _previewImages();
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        if (response.files == null) {
          _setImageFileListFromFile(response.file);
        } else {
          _imageFileList = response.files;
        }
      });
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          _onImageButtonPressed(
              maxWidth: 5, maxHeight: 10, quality: 30, context: context);
        },
        child: const Text("Select Image"));
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Center(
  //     child: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
  //         ? FutureBuilder<void>(
  //             future: retrieveLostData(),
  //             builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
  //               switch (snapshot.connectionState) {
  //                 case ConnectionState.none:
  //                 case ConnectionState.waiting:
  //                   return const Text(
  //                     'You have not yet picked an image.',
  //                     textAlign: TextAlign.center,
  //                   );
  //                 case ConnectionState.done:
  //                   return _handlePreview();
  //                 default:
  //                   if (snapshot.hasError) {
  //                     return Text(
  //                       'Pick image/video error: ${snapshot.error}}',
  //                       textAlign: TextAlign.center,
  //                     );
  //                   } else {
  //                     return const Text(
  //                       'You have not yet picked an image.',
  //                       textAlign: TextAlign.center,
  //                     );
  //                   }
  //               }
  //             },
  //           )
  //         : _handlePreview(),
  //   );
  // }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Future<void> _displayPickImageDialog(
      BuildContext context, OnPickImageCallback onPick) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Pick Image'),
            content: Column(
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
                // TextField(
                //   controller: maxWidthController,
                //   keyboardType:
                //       const TextInputType.numberWithOptions(decimal: true),
                //   decoration: const InputDecoration(
                //       hintText: 'Enter maxWidth if desired'),
                // ),
                // TextField(
                //   controller: maxHeightController,
                //   keyboardType:
                //       const TextInputType.numberWithOptions(decimal: true),
                //   decoration: const InputDecoration(
                //       hintText: 'Enter maxHeight if desired'),
                // ),
                // TextField(
                //   controller: qualityController,
                //   keyboardType: TextInputType.number,
                //   decoration: const InputDecoration(
                //       hintText: 'Enter quality if desired'),
                // ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              // TextButton(
              //     child: const Text('PICK'),
              //     onPressed: () {
              //       final double? width = maxWidthController.text.isNotEmpty
              //           ? double.parse(maxWidthController.text)
              //           : null;
              //       final double? height = maxHeightController.text.isNotEmpty
              //           ? double.parse(maxHeightController.text)
              //           : null;
              //       final int? quality = qualityController.text.isNotEmpty
              //           ? int.parse(qualityController.text)
              //           : null;
              //       onPick(width, height, quality);
              //       Navigator.of(context).pop();
              //     }),
            ],
          );
        });
  }
}

typedef OnPickImageCallback = void Function(ImageSource source);
