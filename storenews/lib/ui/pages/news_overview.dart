import 'package:flutter/material.dart';

// Replace with translations for multiple language support
import 'package:i18n_extension/default.i18n.dart';
import 'package:storenews/domain/news_item.dart';
import 'package:storenews/ui/widgets/bt_settings_button.dart';
import 'package:storenews/ui/widgets/news_item_list.dart';
import 'package:storenews/util/constants.dart';

class NewsOverview extends StatelessWidget {
  final Function(bool) onDarkModeToggle;

  NewsOverview({super.key, required this.onDarkModeToggle});

  final newsItems = <NewsItem>[
    NewsItem(
        name: 'News Item 1',
        markdownContent: 'News Item 1 Description #HELLO and so on',
        lastChanged: DateTime.now(),
        companyNumber: 1,
        storeNumber: 1,
        id: '1')
      ..scannedAt = DateTime.now(),
    NewsItem(
        name: 'News Item 2aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
        markdownContent:
            'News Item 2 Description #HELLO and so onaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa and more more more',
        lastChanged: DateTime.now(),
        companyNumber: 1,
        storeNumber: 1,
        id: '2',
        expires: DateTime.now().subtract(const Duration(days: 1)))
      ..scannedAt = DateTime.now().subtract(const Duration(minutes: 2)),
    NewsItem(
        name: 'News Item 3',
        markdownContent: 'News Item 3 Description #HELLO and so on',
        lastChanged: DateTime.now(),
        companyNumber: 1,
        storeNumber: 1,
        id: '3',
        expires: DateTime.now().add(const Duration(days: 1)))
      ..scannedAt = DateTime.now().subtract(const Duration(minutes: 20)),
    NewsItem(
        name: 'News Item 4',
        markdownContent: 'News Item 4 Description #HELLO and so on',
        lastChanged: DateTime.now(),
        companyNumber: 1,
        storeNumber: 1,
        id: '4',
        expires: DateTime.now().add(const Duration(days: 1)))
      ..scannedAt = DateTime.now().subtract(const Duration(hours: 4)),
    NewsItem(
        name: 'News Item 5',
        markdownContent: 'News Item 5 Description #HELLO and so on',
        lastChanged: DateTime.now(),
        companyNumber: 1,
        storeNumber: 1,
        id: '5',
        expires: DateTime.now().add(const Duration(days: 1)))
      ..scannedAt = DateTime.now().subtract(const Duration(hours: 6)),
    NewsItem(
        name: 'News Item 6',
        markdownContent: 'News Item 6 Description #HELLO and so on',
        lastChanged: DateTime.now(),
        companyNumber: 1,
        storeNumber: 1,
        id: '6',
        expires: DateTime.now().add(const Duration(days: 1)))
      ..scannedAt = DateTime.now().subtract(const Duration(days: 4)),
  ];

  @override
  Widget build(BuildContext context) {
    final darkModeEnabled = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
        appBar: AppBar(
          leading: const Padding(
            padding: EdgeInsets.all(InsetSizes.small),
            child: Image(image: AssetImage('assets/icon/storenews.png')),
          ),
          title: Text('Store News'.i18n),
          // TODO scan toggle
          actions: [
            IconButton(
                onPressed: () => onDarkModeToggle(!darkModeEnabled),
                icon: Visibility(
                  visible: darkModeEnabled,
                  replacement: const Icon(Icons.dark_mode),
                  child: const Icon(Icons.light_mode),
                )),
            BtSettingsButton(isScanning: true, onScanToggle: () {})
          ],
        ),
        body: Column(
          children: [
            // TODO also show latest images
            _ScanNotRunning(isScanning: true), // TODO connect state
            Expanded(
                child: NewsItemList(newsItems: newsItems, showTimeAgo: true)),
          ],
        ));
  }
}

class _ScanNotRunning extends StatelessWidget {
  final bool isScanning;

  const _ScanNotRunning({super.key, required this.isScanning});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !isScanning,
      child: Container(
        alignment: Alignment.topRight,
        padding: const EdgeInsets.only(right: InsetSizes.medium),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('Restart scanning to get the latest news'.i18n),
            const SizedBox(width: InsetSizes.small),
            const Icon(Icons.switch_access_shortcut)
          ],
        ),
      ),
    );
  }
}
