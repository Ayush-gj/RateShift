class NewsArticle {
  final String title;
  final String source;
  final String url;
  final String publishedAt;

  NewsArticle({
    required this.title,
    required this.source,
    required this.url,
    required this.publishedAt,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? 'No Title',
      source: json['source']['name'] ?? 'Unknown Source',
      url: json['url'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
    );
  }
}