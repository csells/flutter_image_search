import 'dart:convert';

class Results {
  String kind;
  Url url;
  Queries queries;
  Context context;
  SearchInformation searchInformation;
  List<Item> items;

  Results({
    this.kind,
    this.url,
    this.queries,
    this.context,
    this.searchInformation,
    this.items,
  });

  factory Results.fromRawJson(String str) => Results.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Results.fromJson(Map<String, dynamic> json) => new Results(
        kind: json["kind"] == null ? null : json["kind"],
        url: json["url"] == null ? null : Url.fromJson(json["url"]),
        queries: json["queries"] == null ? null : Queries.fromJson(json["queries"]),
        context: json["context"] == null ? null : Context.fromJson(json["context"]),
        searchInformation: json["searchInformation"] == null
            ? null
            : SearchInformation.fromJson(json["searchInformation"]),
        items: json["items"] == null
            ? null
            : new List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "kind": kind == null ? null : kind,
        "url": url == null ? null : url.toJson(),
        "queries": queries == null ? null : queries.toJson(),
        "context": context == null ? null : context.toJson(),
        "searchInformation": searchInformation == null ? null : searchInformation.toJson(),
        "items": items == null ? null : new List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class Context {
  String title;

  Context({
    this.title,
  });

  factory Context.fromRawJson(String str) => Context.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Context.fromJson(Map<String, dynamic> json) => new Context(
        title: json["title"] == null ? null : json["title"],
      );

  Map<String, dynamic> toJson() => {
        "title": title == null ? null : title,
      };
}

class Item {
  Kind kind;
  String title;
  String htmlTitle;
  String link;
  String displayLink;
  String snippet;
  String htmlSnippet;
  Mime mime;
  Image image;

  Item({
    this.kind,
    this.title,
    this.htmlTitle,
    this.link,
    this.displayLink,
    this.snippet,
    this.htmlSnippet,
    this.mime,
    this.image,
  });

  factory Item.fromRawJson(String str) => Item.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Item.fromJson(Map<String, dynamic> json) => new Item(
        kind: json["kind"] == null ? null : kindValues.map[json["kind"]],
        title: json["title"] == null ? null : json["title"],
        htmlTitle: json["htmlTitle"] == null ? null : json["htmlTitle"],
        link: json["link"] == null ? null : json["link"],
        displayLink: json["displayLink"] == null ? null : json["displayLink"],
        snippet: json["snippet"] == null ? null : json["snippet"],
        htmlSnippet: json["htmlSnippet"] == null ? null : json["htmlSnippet"],
        mime: json["mime"] == null ? null : mimeValues.map[json["mime"]],
        image: json["image"] == null ? null : Image.fromJson(json["image"]),
      );

  Map<String, dynamic> toJson() => {
        "kind": kind == null ? null : kindValues.reverse[kind],
        "title": title == null ? null : title,
        "htmlTitle": htmlTitle == null ? null : htmlTitle,
        "link": link == null ? null : link,
        "displayLink": displayLink == null ? null : displayLink,
        "snippet": snippet == null ? null : snippet,
        "htmlSnippet": htmlSnippet == null ? null : htmlSnippet,
        "mime": mime == null ? null : mimeValues.reverse[mime],
        "image": image == null ? null : image.toJson(),
      };
}

class Image {
  String contextLink;
  int height;
  int width;
  int byteSize;
  String thumbnailLink;
  int thumbnailHeight;
  int thumbnailWidth;

  Image({
    this.contextLink,
    this.height,
    this.width,
    this.byteSize,
    this.thumbnailLink,
    this.thumbnailHeight,
    this.thumbnailWidth,
  });

  factory Image.fromRawJson(String str) => Image.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Image.fromJson(Map<String, dynamic> json) => new Image(
        contextLink: json["contextLink"] == null ? null : json["contextLink"],
        height: json["height"] == null ? null : json["height"],
        width: json["width"] == null ? null : json["width"],
        byteSize: json["byteSize"] == null ? null : json["byteSize"],
        thumbnailLink: json["thumbnailLink"] == null ? null : json["thumbnailLink"],
        thumbnailHeight: json["thumbnailHeight"] == null ? null : json["thumbnailHeight"],
        thumbnailWidth: json["thumbnailWidth"] == null ? null : json["thumbnailWidth"],
      );

  Map<String, dynamic> toJson() => {
        "contextLink": contextLink == null ? null : contextLink,
        "height": height == null ? null : height,
        "width": width == null ? null : width,
        "byteSize": byteSize == null ? null : byteSize,
        "thumbnailLink": thumbnailLink == null ? null : thumbnailLink,
        "thumbnailHeight": thumbnailHeight == null ? null : thumbnailHeight,
        "thumbnailWidth": thumbnailWidth == null ? null : thumbnailWidth,
      };
}

enum Kind { CUSTOMSEARCH_RESULT }

final kindValues = new EnumValues({"customsearch#result": Kind.CUSTOMSEARCH_RESULT});

enum Mime { IMAGE_JPEG, IMAGE, IMAGE_PNG }

final mimeValues = new EnumValues(
    {"image/": Mime.IMAGE, "image/jpeg": Mime.IMAGE_JPEG, "image/png": Mime.IMAGE_PNG});

class Queries {
  List<NextPage> request;
  List<NextPage> nextPage;

  Queries({
    this.request,
    this.nextPage,
  });

  factory Queries.fromRawJson(String str) => Queries.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Queries.fromJson(Map<String, dynamic> json) => new Queries(
        request: json["request"] == null
            ? null
            : new List<NextPage>.from(json["request"].map((x) => NextPage.fromJson(x))),
        nextPage: json["nextPage"] == null
            ? null
            : new List<NextPage>.from(json["nextPage"].map((x) => NextPage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "request": request == null ? null : new List<dynamic>.from(request.map((x) => x.toJson())),
        "nextPage":
            nextPage == null ? null : new List<dynamic>.from(nextPage.map((x) => x.toJson())),
      };
}

class NextPage {
  String title;
  String totalResults;
  String searchTerms;
  int count;
  int startIndex;
  String inputEncoding;
  String outputEncoding;
  String safe;
  String cx;
  String searchType;

  NextPage({
    this.title,
    this.totalResults,
    this.searchTerms,
    this.count,
    this.startIndex,
    this.inputEncoding,
    this.outputEncoding,
    this.safe,
    this.cx,
    this.searchType,
  });

  factory NextPage.fromRawJson(String str) => NextPage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NextPage.fromJson(Map<String, dynamic> json) => new NextPage(
        title: json["title"] == null ? null : json["title"],
        totalResults: json["totalResults"] == null ? null : json["totalResults"],
        searchTerms: json["searchTerms"] == null ? null : json["searchTerms"],
        count: json["count"] == null ? null : json["count"],
        startIndex: json["startIndex"] == null ? null : json["startIndex"],
        inputEncoding: json["inputEncoding"] == null ? null : json["inputEncoding"],
        outputEncoding: json["outputEncoding"] == null ? null : json["outputEncoding"],
        safe: json["safe"] == null ? null : json["safe"],
        cx: json["cx"] == null ? null : json["cx"],
        searchType: json["searchType"] == null ? null : json["searchType"],
      );

  Map<String, dynamic> toJson() => {
        "title": title == null ? null : title,
        "totalResults": totalResults == null ? null : totalResults,
        "searchTerms": searchTerms == null ? null : searchTerms,
        "count": count == null ? null : count,
        "startIndex": startIndex == null ? null : startIndex,
        "inputEncoding": inputEncoding == null ? null : inputEncoding,
        "outputEncoding": outputEncoding == null ? null : outputEncoding,
        "safe": safe == null ? null : safe,
        "cx": cx == null ? null : cx,
        "searchType": searchType == null ? null : searchType,
      };
}

class SearchInformation {
  double searchTime;
  String formattedSearchTime;
  String totalResults;
  String formattedTotalResults;

  SearchInformation({
    this.searchTime,
    this.formattedSearchTime,
    this.totalResults,
    this.formattedTotalResults,
  });

  factory SearchInformation.fromRawJson(String str) => SearchInformation.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SearchInformation.fromJson(Map<String, dynamic> json) => new SearchInformation(
        searchTime: json["searchTime"] == null ? null : json["searchTime"].toDouble(),
        formattedSearchTime:
            json["formattedSearchTime"] == null ? null : json["formattedSearchTime"],
        totalResults: json["totalResults"] == null ? null : json["totalResults"],
        formattedTotalResults:
            json["formattedTotalResults"] == null ? null : json["formattedTotalResults"],
      );

  Map<String, dynamic> toJson() => {
        "searchTime": searchTime == null ? null : searchTime,
        "formattedSearchTime": formattedSearchTime == null ? null : formattedSearchTime,
        "totalResults": totalResults == null ? null : totalResults,
        "formattedTotalResults": formattedTotalResults == null ? null : formattedTotalResults,
      };
}

class Url {
  String type;
  String template;

  Url({
    this.type,
    this.template,
  });

  factory Url.fromRawJson(String str) => Url.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Url.fromJson(Map<String, dynamic> json) => new Url(
        type: json["type"] == null ? null : json["type"],
        template: json["template"] == null ? null : json["template"],
      );

  Map<String, dynamic> toJson() => {
        "type": type == null ? null : type,
        "template": template == null ? null : template,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
