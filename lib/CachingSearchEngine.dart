import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'cse-results.dart';
import 'package:path/path.dart' as path;

class CachingSearchEngine {
  final String cseKey;
  final String cseEngineID;
  final _cacheDir = Directory('cse-cache');

  CachingSearchEngine({@required this.cseEngineID, @required this.cseKey});

  Future<Results> imageSearch(String q) async {
    var cachedRes = await _getCachedResults(q);
    if (cachedRes != null) {
      debugPrint('"$q" found in cache');
      return cachedRes;
    }

    debugPrint('"$q" NOT FOUND cache');
    var params = {
      'cx': cseEngineID,
      'key': cseKey,
      'searchType': 'image',
      'q': q,
    };

    var query = Uri(queryParameters: params).query;
    var resp = await http.get('https://www.googleapis.com/customsearch/v1?$query');
    if (resp.statusCode != 200) throw Exception('get error: statusCode= ${resp.statusCode}');

    var res = Results.fromRawJson(resp.body);
    await _setCachedResults(q, res);
    return res;
  }

  Future<File> _getCacheFile(String key) async {
    await _cacheDir.create();
    return File(path.join(_cacheDir.path, '${key.hashCode}.json'));
  }

  Future<Results> _getCachedResults(String q) async {
    var file = await _getCacheFile(q);
    var exists = await file.exists();
    if (!exists) return null;
    var json = await file.readAsString();
    return Results.fromRawJson(json);
  }

  Future _setCachedResults(String q, Results res) async {
    var file = await _getCacheFile(q);
    var json = res.toRawJson();
    await file.writeAsString(json);
  }
}
