import 'package:flutter_cache_manager/flutter_cache_manager.dart';

Future<List<String>> imageCachePath(List<String> urls) async {
  List<String> images = [];

  for (var i = 0; i < urls.length; i++) {
    final cache = DefaultCacheManager();
    final file = await cache.getSingleFile(urls[i]);
    images.add(file.path);
  }

  return images;
}
