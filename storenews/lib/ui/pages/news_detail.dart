import 'package:flutter/material.dart';
import 'package:storenews/domain/news_item.dart';

class NewsDetail extends StatelessWidget {
  final NewsItem newsItem;

  const NewsDetail({super.key, required this.newsItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(newsItem.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(newsItem.markdownContent),
          ],
        ),
      ),
    );
  }
}