import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:news_app/Model/news.dart';

class ApiService {
  Future<List<News>> getNews(String query) async {
    String from = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 1)));
    String to = DateFormat('yyyy-MM-dd').format(DateTime.now());

    String url = "https://newsapi.org/v2/everything?"
        "q=$query"
        "&from=$from"
        "&to=$to"
        "&sortBy=latest"
        "country=india"
        "&apiKey=1ad7f4eadff4414881bfd6fedd6949aa";

    try {
      print('Checkkkkk urll $url');
      final res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        print('Checkk ApiService ${res.body}');
        Map<String, dynamic> json = jsonDecode(res.body);

        List data = json['articles'];

        return data.map((e) => News(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Api service Data Error');
      return [];
    }
  }
}
