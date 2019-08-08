import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'cse-results.dart';
import 'caching_directory.dart';

class CachingSearchEngine {
  final String cseKey;
  final String cseEngineID;
  final _resultsCache = CachingDirectory('cse-cache', cacheExt: '.json');

  CachingSearchEngine({@required this.cseEngineID, @required this.cseKey});

  Future<Results> imageSearch(String q) async {
    String json;

    // if the file doesn't exist in the cache, write it
    var file = await _resultsCache.getCacheFile(q);
    if (await file.exists()) {
      json = await file.readAsString();
    } else {
      var params = {
        'cx': cseEngineID,
        'key': cseKey,
        'searchType': 'image',
        'q': q,
      };

      var query = Uri(queryParameters: params).query;
      var url = 'https://www.googleapis.com/customsearch/v1?$query';
      var resp = await http.get(url);
      if (resp.statusCode != 200) throw Exception('get error: statusCode= ${resp.statusCode}');

      json = resp.body;
      await file.writeAsString(json);
    }

    return Results.fromRawJson(json);
  }
}
