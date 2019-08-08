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
    download();
  }

  void download() async {
    var bytes = await _imageCache.getCachedBytes(widget.url);
    if (bytes == null) {
      var resp = await http.get(widget.url);
      bytes = resp.bodyBytes;
      await _imageCache.setCachedBytes(widget.url, bytes);
    }

    setState(() => _image = Image.memory(bytes));
  }

  @override
  Widget build(BuildContext context) => _image == null ? CircularProgressIndicator() : _image;
}
