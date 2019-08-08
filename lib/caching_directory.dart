import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;

class CachingDirectory {
  final Directory cacheDir;
  final String cacheExt;
  CachingDirectory(String dir, {this.cacheExt}) : cacheDir = Directory(dir);

  Future<File> _getCacheFile(String key) async {
    await cacheDir.create();
    var ext = cacheExt;
    if (ext == null) {
      // attempt to pull extension off the key (if it's a file or URL)
      var pathPart = key.split('?')[0]; // file path or url path w/o query string portion
      ext = path.extension(pathPart);
    }

    return File(path.join(cacheDir.path, '${key.hashCode}$ext'));
  }

  Future<File> _getExistingCacheFile(String key) async {
    var file = await _getCacheFile(key);
    var exists = await file.exists();

    if (exists) {
      debugPrint('"$key" found in ${file.path}');
    } else {
      debugPrint('"$key" NOT FOUND in ${cacheDir.path}');
    }

    return exists ? file : null;
  }

  Future<String> getCachedString(String key) async {
    var file = await _getExistingCacheFile(key);
    return file == null ? null : file.readAsString();
  }

  Future setCachedString(String key, String value) async {
    var file = await _getCacheFile(key);
    await file.writeAsString(value);
  }

  Future<Uint8List> getCachedBytes(String key) async {
    var file = await _getExistingCacheFile(key);
    return file == null ? null : file.readAsBytes();
  }

  Future setCachedBytes(String key, Uint8List value) async {
    var file = await _getCacheFile(key);
    await file.writeAsBytes(value);
  }
}
