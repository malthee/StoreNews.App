import 'package:flutter/material.dart';
import 'package:storenews/ui/widgets/image_loading_carousel.dart';
import 'package:storenews/ui/widgets/news_item_list.dart';
import 'package:storenews/ui/widgets/store_icon_name.dart';

import '../../domain/news_item.dart';
import '../../util/constants.dart';

class StoreDetail extends StatelessWidget {
  final int companyNumber, storeNumber;

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
        expires: DateTime.now().subtract(const Duration(days: 1))),
    NewsItem(
        name: 'News Item 3',
        markdownContent: 'News Item 3 Description #HELLO and so on',
        lastChanged: DateTime.now(),
        companyNumber: 1,
        storeNumber: 1,
        id: '3',
        expires: DateTime.now().add(const Duration(days: 1))),
    NewsItem(
        name: 'News Item 4',
        markdownContent: 'News Item 4 Description #HELLO and so on',
        lastChanged: DateTime.now(),
        companyNumber: 1,
        storeNumber: 1,
        id: '4',
        expires: DateTime.now().add(const Duration(days: 1))),
  ];

  StoreDetail(
      {super.key, required this.companyNumber, required this.storeNumber});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(
            titleSpacing: 0,
            title: Padding(
              padding: const EdgeInsets.all(InsetSizes.small),
              child: StoreIconName(
                  companyNumber: companyNumber, storeNumber: storeNumber),
            )),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  ImageLoadingCarousel(imageUrls: []),
                  const Divider(),
                  NewsItemList(
                      newsItems: newsItems,
                      // Disable scrolling as is handled by SingleChildScrollView
                      scrollPhysics: const NeverScrollableScrollPhysics())
                ],
              )),
            ),
          ],
        ));
  }
}
