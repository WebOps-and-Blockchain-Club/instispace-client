import 'dart:convert';
import 'dart:io' as io;
import 'package:http_parser/http_parser.dart';
import 'package:client/services/client.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

class ImageService {
  final ImagePicker _picker = ImagePicker();
  List<dynamic> images = [];
  Future<List<MultipartFile>?> getMultipartFiles(List<dynamic> files) async {
    List<MultipartFile> multipart_files = [];
    if (files.isNotEmpty) {
      for (var item in files) {
        var byteData = await item.readAsBytes();

        var multipartFile = MultipartFile.fromBytes(
          'images',
          byteData,
          filename: '${DateTime.now().second}.jpg',
          contentType: MediaType("image", "jpg"),
        );

        multipart_files.add(multipartFile);
      }

      return multipart_files;
    } else {
      return null;
    }
  }

  // upload images to the uploader api (uses getMultipartFiles function to first convert images to multipart files)
  Future<List<String>> upload(List<dynamic> files) async {
    List<MultipartFile>? images = await getMultipartFiles(files);
    if (images == null || images.isEmpty) return [];
    var request = uploadClient();
    request.files.addAll(images);
    try {
      StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        dynamic res = await response.stream.bytesToString();

        return jsonDecode(res)["urls"].cast<String>();
      } else {
        throw (await response.stream.bytesToString());
      }
    } on io.SocketException {
      throw ('server error');
    } catch (e) {
      rethrow;
    }
  }

  Future<io.File?> pickCamera() async {
    XFile? img = await _picker.pickImage(source: ImageSource.camera);
    io.File? file = img != null ? io.File(img.path) : null;

    return file;
  }

  Future<List<io.File>> pickGalley() async {
    List<io.File> files = [];
    List<XFile>? imgs = await _picker.pickMultiImage();

    for (XFile img in imgs) {
      files.add(io.File(img.path));
    }

    return files;
  }
}
