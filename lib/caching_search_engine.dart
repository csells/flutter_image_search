import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'cse-results.dart';
import 'caching_directory.dart';

class CachingSearchEngine {
  final String cseKey;
  final String cseEngineID;
  final _cachingDir = CachingDirectory('cse-cache', cacheExt: '.json');

  CachingSearchEngine({@required this.cseEngineID, @required this.cseKey});

  Future<Results> imageSearch(String q) async {
    var json = await _cachingDir.getCachedString(q);
    if (json == null) {
      var params = {
        'cx': cseEngineID,
        'key': cseKey,
        'searchType': 'image',
        'q': q,
      };

      var query = Uri(queryParameters: params).query;
      var resp = await http.get('https://www.googleapis.com/customsearch/v1?$query');
      if (resp.statusCode != 200) throw Exception('get error: statusCode= ${resp.statusCode}');

      json = resp.body;
      await _cachingDir.setCachedString(q, json);
    }

    return Results.fromRawJson(json);
  }
}
