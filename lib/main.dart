import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show debugDefaultTargetPlatformOverride, kIsWeb;
import 'package:http/http.dart' as http;
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
  final String _cseKey;
  List<cse.Item> _items;

  _ImageSearchState() : _cseKey = File("cse-key.txt").readAsStringSync();

  @override
  void initState() {
    super.initState();
    search();
  }

  @override
  Widget build(BuildContext context) => Scrollbar(
        child: _items == null
            ? Center(child: CircularProgressIndicator())
            : GridView.count(
                crossAxisCount: 3,
                children: [
                  for (var item in _items)
                    Container(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            // image: CachedNetworkImageProvider(item.link),
                            image: NetworkImage(item.link),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
      );

  // TODO: caching!!!
  void search({String q = '5e goblin'}) async {
    var params = {
      'q': q,
      'cx': '007845364583112319514:wrtaiv3qw8k',
      'searchType': 'image',
      'key': _cseKey,
    };
    var query = Uri(queryParameters: params).query;
    var resp = await http.get('https://www.googleapis.com/customsearch/v1?$query');
    if (resp.statusCode != 200) throw Exception('get error: statusCode= ${resp.statusCode}');

    var res = cse.Results.fromRawJson(resp.body);
    setState(() => _items = res.items);
  }
}
