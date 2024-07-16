import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Article {
  final String title;
  final String description;
  final String url;
  final String urlToImage;

  Article({
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      description: json['description'],
      url: json['url'],
      urlToImage: json['urlToImage'] ?? '',
    );
  }
}

class ArticleProvider with ChangeNotifier {
  List<Article> _articles = [];

  List<Article> get articles => _articles;

  Future<void> fetchArticles() async {
    final url = 'https://newsapi.org/v2/everything?q=nutrition+fitness+bodybuilding&apiKey=62c0033a63e644a49cdc1334358c574b';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<Article> loadedArticles = [];
        for (var articleJson in data['articles']) {
          loadedArticles.add(Article.fromJson(articleJson));
        }
        _articles = loadedArticles;
        notifyListeners();
      } else {
        throw Exception('Failed to load articles');
      }
    } catch (error) {
      throw error;
    }
  }
}
