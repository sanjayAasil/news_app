import 'dart:async';

import 'package:flutter/material.dart';
import 'package:news_app/Api/api_service.dart';
import 'package:news_app/View/Home/news_tile.dart';
import 'package:news_app/ViewModel/theme_provider.dart';
import 'package:provider/provider.dart';
import '../../Model/news.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<News> newsList = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();
  Timer? searchTimer;

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  _fetchData([String query = 'today']) async {
    setState(() => isLoading = true);
    newsList.clear();
    newsList = await ApiService().getNews(query);

    newsList.removeWhere((e) {
      if (e.title == '[Removed]') return true;

      if (e.urlToImage == null) return true;

      return false;
    });

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'NewsApp',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              onPressed: ThemeProvider().toggleTheme,
              icon: ThemeProvider().isDarkTheme ? const Icon(Icons.dark_mode) : const Icon(Icons.sunny),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: ThemeProvider().isDarkTheme ? Colors.grey.shade900 : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: TextField(
                        controller: searchController,
                        onChanged: _onTextChanged,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search News',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: IconButton(
                      color: Colors.grey,
                      onPressed: () => _searchNews(searchController.text.trim()),
                      icon: const Icon(Icons.search),
                    ),
                  ),
                ],
              ),
            ),
          ),
          isLoading
              ? const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: ThemeProvider.primaryColor,
                    ),
                  ),
                )
              : Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (searchController.text.trim().isNotEmpty && newsList.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
                          child: Text(
                            'Results from "${searchController.text.trim()}"',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      if (newsList.isEmpty)
                        Column(
                          children: [
                            const SizedBox(height: 100),
                            const Text('  No News Found\nCheck connectivity'),
                            TextButton(
                              onPressed: () => _fetchData(
                                  searchController.text.trim().isEmpty ? 'today' : searchController.text.trim()),
                              child: const Icon(Icons.sync),
                            ),
                          ],
                        ),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            _fetchData();
                          },
                          child: GridView.builder(
                            itemCount: newsList.length,
                            itemBuilder: (context, index) {
                              News news = newsList[index];
                              return newsList.isNotEmpty ? NewsTile(news: news) : const Text('No News Found');
                            },
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 3 / 4,
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
        ],
      ),
    );
  }

  _onTextChanged(String? query) async {
    searchTimer?.cancel();
    searchTimer = Timer(const Duration(milliseconds: 300), () {
      _fetchData(query!);
    });
    if (query?.isEmpty ?? false) return;
  }

  _searchNews(String query) async {
    if (query.isEmpty) return;
    FocusScope.of(context).unfocus();

    _fetchData(query);
  }
}
