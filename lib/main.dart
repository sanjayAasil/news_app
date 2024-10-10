import 'package:flutter/material.dart';
import 'package:news_app/View/Home/home_page.dart';
import 'package:news_app/ViewModel/theme_provider.dart';
import 'package:news_app/dataManager.dart';
import 'package:news_app/global.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  pref = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = ThemeProvider();
    DataManager dataManager = DataManager();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => themeProvider),
        ChangeNotifierProvider(create: (_) => dataManager),
      ],
      builder: (context, child) {
        context.watch<ThemeProvider>();
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeProvider.themeData,
          darkTheme: ThemeProvider.darkThemeData,
          themeMode: ThemeProvider.themeMode,
          home: const HomePage(),
        );
      },
    );
  }
}
