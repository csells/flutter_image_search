import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_image_search/caching_directory.dart';
import 'package:http/http.dart' as http;

class CachingNetworkImage extends StatefulWidget {
  final String url;
  CachingNetworkImage(this.url);

  @override
  _CachingNetworkImageState createState() => _CachingNetworkImageState();
}

class _CachingNetworkImageState extends State<CachingNetworkImage> {
  final _imageCache = CachingDirectory('image-cache');
  Image _image;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    Uint8List bytes;

    // if the file doesn't exist in the cache, write it
    var file = await _imageCache.getCacheFile(widget.url);
    if (await file.exists()) {
      bytes = await file.readAsBytes();
    } else {
      var resp = await http.get(widget.url);
      if (resp.statusCode != 200) throw Exception('get error: statusCode= ${resp.statusCode}');

      bytes = resp.bodyBytes;
      await file.writeAsBytes(bytes, flush: true);
    }

    setState(() => _image = Image.memory(bytes));
  }

  @override
  Widget build(BuildContext context) =>
      _image == null ? Center(child: CircularProgressIndicator()) : _image;
}
