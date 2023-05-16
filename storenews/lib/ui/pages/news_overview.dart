import 'package:flutter/material.dart';

// Replace with translations for multiple language support
import 'package:i18n_extension/default.i18n.dart';
import 'package:storenews/domain/news_item.dart';
import 'package:storenews/ui/widgets/bt_settings_button.dart';
import 'package:storenews/ui/widgets/news_item_stepper.dart';

class NewsOverview extends StatelessWidget {
  NewsOverview({super.key});

  final newsItems = <NewsItem>[
    NewsItem(
        name: 'News Item 1',
        markdownContent: 'News Item 1 Description #HELLO and so on',
        lastChanged: DateTime.now(),
        companyNumber: 1,
        storeNumber: 1,
        id: '1'
    ),
    NewsItem(
        name: 'News Item 2aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
        markdownContent: 'News Item 2 Description #HELLO and so onaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
        lastChanged: DateTime.now(),
        companyNumber: 1,
        storeNumber: 1,
        id: '2'
    ),
    NewsItem(
        name: 'News Item 3',
        markdownContent: 'News Item 3 Description #HELLO and so on',
        lastChanged: DateTime.now(),
        companyNumber: 1,
        storeNumber: 1,
        id: '3'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.business_center),
        title: Text('Store News'.i18n),
        actions: const [
          BtSettingsButton()
        ],
      ),
      body: Visibility(
          visible: newsItems.isEmpty,
          replacement: NewsItemStepper(newsItems: newsItems),
          child: Center(
            child: Text('No news found'.i18n),
          )
      ),
    );
  }
}