import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show debugDefaultTargetPlatformOverride, kIsWeb;
import 'package:flutter_image_search/CachingSearchEngine.dart';
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
            cseKey: File("cse-key.txt").readAsStringSync());

  @override
  void initState() {
    super.initState();
    search();
  }

  void search() => _engine.imageSearch('kitties').then((res) => setState(() => _items = res.items));

  @override
  Widget build(BuildContext context) => Scrollbar(
        child: _items == null
            ? Center(child: CircularProgressIndicator())
            : Scrollbar(
                child: GridView.count(
                  crossAxisCount: 3,
                  children: [
                    for (var item in _items) Image.network(item.link),
                  ],
                ),
              ),
      );
}
