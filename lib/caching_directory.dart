import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;

class CachingDirectory {
  final Directory cacheDir;
  final String cacheExt;
  CachingDirectory(String dir, {this.cacheExt}) : cacheDir = Directory(dir);

  Future<File> getCacheFile(String key) async {
    await cacheDir.create();
    var ext = cacheExt;
    if (ext == null) {
      // attempt to pull extension off the key (if it's a file or URL)
      var pathPart = key.split('?')[0]; // file path or url path w/o query string portion
      ext = path.extension(pathPart);
    }

    var file = File(path.join(cacheDir.path, '${key.hashCode}$ext'));
    if (await file.exists()) {
      debugPrint('"$key" found in ${file.path}');
    } else {
      debugPrint('"$key" NOT FOUND in ${file.path}');
    }
    return file;
  }
}
