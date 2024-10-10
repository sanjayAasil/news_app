class News {
  final Map<String, dynamic> json;

  News(this.json);

  String get title => json['title'];

  String? get description => json['description'];

  String get url => json['url'];

  String? get urlToImage => json['urlToImage'];

  DateTime get publishedAt => DateTime.parse(json['publishedAt']);

  String? get author => json['author'];

  String? get content => json['content'];
}
