import 'dart:convert';

/*{
      "source": {
        "id": null,
        "name": "Slashdot.org"
      },
      "author": "feedfeeder",
      "title": "Elon Musk's texts with Jack Dorsey and Parag Agrawal detail tumultuous Twitter negotiations - Engadget",
      "description": "Elon Musk's texts with Jack Dorsey and Parag Agrawal detail tumultuous Twitter negotiationsEngadget Elon Musk & Jack Dorsey’s private texts show Twitter founder tried to involve Tesla CEO in site a year b...The US Sun Sam Bankman-Fried reportedly intended to …",
      "url": "https://slashdot.org/firehose.pl?op=view&amp;id=166501783",
      "urlToImage": null,
      "publishedAt": "2022-09-30T10:52:18Z",
      "content": "The Fine Print: The following comments are owned by whoever posted them. We are not responsible for them in any way."
    }, */
class Source {
  Source({this.id, required this.name});

  factory Source.fromJson(String source) => Source.fromMap(json.decode(source));

  factory Source.fromMap(Map<String, dynamic> map) {
    return Source(
      id: map['id'],
      name: map['name'] ?? '',
    );
  }

  final String? id;
  final String name;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  String toJson() => json.encode(toMap());
}

class Article {
  Article({
    required this.source,
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    this.urlToImage,
    required this.publishedAt,
    required this.content,
  });

  factory Article.fromJson(String source) =>
      Article.fromMap(json.decode(source));

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      source: Source.fromMap(map['source']),
      author: map['author'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      url: map['url'] ?? '',
      urlToImage: map['urlToImage'],
      publishedAt: DateTime.parse(map['publishedAt']),
      content: map['content'] ?? '',
    );
  }

  final String author;
  final String content;
  final String description;
  final DateTime publishedAt;
  final Source source;
  final String title;
  final String url;
  final String? urlToImage;

  Map<String, dynamic> toMap() {
    return {
      'source': source.toMap(),
      'author': author,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt.toIso8601String(),
      'content': content,
    };
  }

  String toJson() => json.encode(toMap());
}
