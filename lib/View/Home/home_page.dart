import 'package:flutter/material.dart';
import 'package:news_app/Api/api_service.dart';
import 'package:news_app/View/Home/news_tile.dart';
import 'package:news_app/ViewModel/theme_provider.dart';
import 'package:news_app/dataManager.dart';
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
    context.watch<DataManager>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'NewsApp',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Switch(
            activeColor: Colors.grey,
            value: ThemeProvider().isDarkTheme,
            onChanged: (value) => ThemeProvider().toggleTheme(),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: ThemeProvider.primaryColor,
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                        onPressed: () =>
                            _fetchData(searchController.text.trim().isEmpty ? 'today' : searchController.text.trim()),
                        child: const Icon(Icons.sync),
                      ),
                    ],
                  ),
                Expanded(
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
              ],
            ),
    );
  }

  _searchNews(String query) async {
    if(query.isEmpty) return;
    FocusScope.of(context).unfocus();

    _fetchData(query);
  }
}
