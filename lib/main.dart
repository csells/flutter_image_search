import 'dart:async';
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
  final _debouncer = Debouncer();
  var _items = List<cse.Item>();
  var _selectedLink = '';

  _ImageSearchState()
      : _engine = CachingSearchEngine(
          cseEngineID: File("cse-engine-id.txt").readAsStringSync(),
          cseKey: File("cse-key.txt").readAsStringSync(),
        );

  static final _imageExts = ['.jpg', '.jpeg', '.bmp', '.png'];
  static bool _isImageExt(String ext) => _imageExts.contains(ext.toLowerCase());

  Future search(String q) async {
    debugPrint('search: q= "$q"');

    var res = await _engine.imageSearch(q);

    var items = List<cse.Item>();
    for (var item in res.items ?? List<cse.Item>()) {
      // only show results that look like they're images
      // TODO: actually download and check the MIME type
      var pathPart = item.link.split('?')[0]; // file path or url path w/o query string portion
      var ext = path.extension(pathPart);
      if (_isImageExt(ext)) items.add(item);
    }

    setState(() => _items = items);
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Search'),
              onChanged: onSearchTextChanged,
            ),
            Expanded(
              child: _debouncer.isRunning
                  ? Center(child: CircularProgressIndicator())
                  : Scrollbar(
                      child: GridView.count(
                        crossAxisCount: 3,
                        children: [
                          for (var item in _items)
                            RawMaterialButton(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CachingNetworkImage(item.link),
                              ),
                              fillColor: item.link == _selectedLink ? Colors.blue : Colors.white,
                              onPressed: () => setState(() => _selectedLink = item.link),
                            ),
                        ],
                      ),
                    ),
            ),
            Text(_selectedLink),
          ],
        ),
      );

  void onSearchTextChanged(String value) {
    debugPrint('onSearchTextChanged: value= "$value"');

    if (value.length < 5)
      _debouncer.stop();
    else
      _debouncer.run(() => search(value));

    setState(() {
      _items.clear();
      _selectedLink = '';
    });
  }
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds = 500});

  void run(VoidCallback action) {
    stop();
    _timer = Timer(Duration(milliseconds: milliseconds), () {
      stop();
      action();
    });
  }

  void stop() {
    if (_timer == null) return;
    _timer.cancel();
    _timer = null;
  }

  bool get isRunning => _timer != null;
}
