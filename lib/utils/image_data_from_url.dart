import 'dart:typed_data';
import 'package:http/http.dart' as http;

Future<Uint8List> getByteArrayFromUrl(String url) async {
  final http.Response response = await http.get(Uri.parse(url));
  return response.bodyBytes;
}
