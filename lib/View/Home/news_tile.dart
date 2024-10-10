import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_app/View/single_news_screen.dart';
import '../../Model/news.dart';
import '../../ViewModel/theme_provider.dart';

class NewsTile extends StatelessWidget {
  final News news;

  const NewsTile({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SingleNewsScreen(news: news),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: 300,
          width: 200,
          decoration: BoxDecoration(
            color: ThemeProvider().isDarkTheme ? Colors.grey.shade900 : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  news.title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  news.description ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CachedNetworkImage(
                  height: 100,
                  width: double.infinity,
                  imageUrl: news.urlToImage!,
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    DateFormat('EEE, MMM d, ' 'yyyy').format(news.publishedAt),
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
