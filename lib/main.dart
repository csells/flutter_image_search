import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show debugDefaultTargetPlatformOverride, kIsWeb;
import 'package:path/path.dart' as path;
import 'caching_network_image.dart';
import 'caching_search_engine.dart';
import 'cse-results.dart' as cse;

void _desktopInitHack() {
  if (kIsWeb) return;

  if (Platform.isMacOS) {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
  } else if (Platform.isLinux || Platform.isWindows) {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
  } else if (Platform.isFuchsia) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

void main() {
  _desktopInitHack();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final title = 'Flutter Image Search';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(title: Text(title)),
        body: ImageSearch(),
      ),
    );
  }
}

class ImageSearch extends StatefulWidget {
  @override
  _ImageSearchState createState() => _ImageSearchState();
}

class _ImageSearchState extends State<ImageSearch> {
  final CachingSearchEngine _engine;
  List<cse.Item> _items;

  _ImageSearchState()
      : _engine = CachingSearchEngine(
          cseEngineID: File("cse-engine-id.txt").readAsStringSync(),
          cseKey: File("cse-key.txt").readAsStringSync(),
        );

  @override
  void initState() {
    super.initState();
    search();
  }

  static final _imageExts = ['.jpg', '.jpeg', '.bmp', '.png'];
  static bool _isImageExt(String ext) => _imageExts.contains(ext.toLowerCase());

  void search() async {
    var res = await _engine.imageSearch('kitties');

    var items = List<cse.Item>();
    for (var item in res.items) {
      // only show results that look like they're images
      // TODO: actually download and check the MIME type
      var pathPart = item.link.split('?')[0]; // file path or url path w/o query string portion
      var ext = path.extension(pathPart);
      if (_isImageExt(ext)) items.add(item);
    }

    setState(() => _items = items);
  }

  @override
  Widget build(BuildContext context) => _items == null
      ? Center(child: CircularProgressIndicator())
      : Scrollbar(
          child: GridView.count(
            crossAxisCount: 3,
            children: [
              for (var item in _items) CachingNetworkImage(item.link),
            ],
          ),
        );
}
