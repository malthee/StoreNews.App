import 'package:flutter/material.dart';

// Replace with translations for multiple language support
import 'package:i18n_extension/default.i18n.dart';
import 'package:storenews/domain/news_item.dart';
import 'package:storenews/ui/widgets/bt_settings_button.dart';
import 'package:storenews/ui/widgets/news_item_list.dart';

class NewsOverview extends StatelessWidget {
  NewsOverview({super.key});

  final newsItems = <NewsItem>[
    NewsItem(
        name: 'News Item 1',
        markdownContent: 'News Item 1 Description #HELLO and so on',
        lastChanged: DateTime.now(),
        companyNumber: 1,
        storeNumber: 1,
        id: '1')..scannedAt = DateTime.now(),
    NewsItem(
        name: 'News Item 2aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
        markdownContent:
            'News Item 2 Description #HELLO and so onaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa and more more more',
        lastChanged: DateTime.now(),
        companyNumber: 1,
        storeNumber: 1,
        id: '2',
        expires: DateTime.now().subtract(const Duration(days: 1))),
    NewsItem(
        name: 'News Item 3',
        markdownContent: 'News Item 3 Description #HELLO and so on',
        lastChanged: DateTime.now(),
        companyNumber: 1,
        storeNumber: 1,
        id: '3',
        expires: DateTime.now().add(const Duration(days: 1))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.business_center),
        title: Text('Store News'.i18n),
        actions: const [BtSettingsButton()],
      ),
      body: Visibility(
          visible: newsItems.isEmpty,
          replacement: NewsItemList(newsItems: newsItems),
          child: _noNewsFound(context)),
    );
  }

  Widget _noNewsFound(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.article_outlined,
            size: 80,
            color: theme.disabledColor,
          ),
          const SizedBox(height: 16.0),
          Text(
            "No news items available".i18n,
            style: theme.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8.0),
          Text(
            "Visit some locations and make sure scanning is enabled.".i18n,
            style: theme.textTheme.bodyMedium!
                .merge(TextStyle(color: theme.disabledColor)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
