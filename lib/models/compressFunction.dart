import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<Uint8List?> Compress(Uint8List? list) async {
  var result = await FlutterImageCompress.compressWithList(
    list!,
    minHeight: 1920,
    minWidth: 1080,
    quality: 80,
  );
  return result;
}