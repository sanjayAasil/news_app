import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:versatile_dialogs/loading_dialog.dart';

import '../Model/news.dart';

class SingleNewsScreen extends StatelessWidget {
  final News news;

  const SingleNewsScreen({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                news.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: Text(
                  news.description ?? '',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                ),
              ),
              Text(
                DateFormat('EEE, MMM d, yyyy h:mm a').format(news.publishedAt),
                style: const TextStyle(
                  fontSize: 13,
                ),
              ),
              CachedNetworkImage(
                imageUrl: news.urlToImage!,
                errorWidget: (context, string, object) {
                  return const SizedBox(
                    height: 100,
                    width: 100,
                  );
                },
              ),
              news.author == null
                  ? const SizedBox()
                  : Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Author: ${news.author}" ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
              const SizedBox(height: 40),
              Text(
                news.content ?? '',
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 30),
              TextButton(
                style: const ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll(Colors.blue),
                ),
                onPressed: () async {
                  LoadingDialog loadingDialog = LoadingDialog()..show(context);
                  if (await canLaunchUrl(Uri.parse(news.url))) {
                    await launchUrl(Uri.parse(news.url));
                  } else {
                    throw 'Could not launch ${news.url}';
                  }
                  if (context.mounted) {
                    loadingDialog.dismiss(context);
                  }
                },
                child: Text(news.url),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
