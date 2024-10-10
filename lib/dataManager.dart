import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Model/news.dart';

class DataManager extends ChangeNotifier {
  static final DataManager _instance = DataManager._();

  DataManager._();

  factory DataManager() => _instance;

  final List<News> _news = [];

  List<News> get news => _news;

  set addNews(List<News> news) {
    news.addAll(news);
    notifyListeners();
  }
}
