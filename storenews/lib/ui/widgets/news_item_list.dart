import 'package:flutter/material.dart';
import 'package:i18n_extension/default.i18n.dart';
import 'package:storenews/domain/news_item.dart';
import 'package:storenews/ui/widgets/news_item_expires_icon.dart';
import 'package:storenews/util/dynamic_datetime_format.dart';

import '../../util/constants.dart';
import '../pages/news_detail.dart';
import '../pages/store_detail.dart';

class NewsItemList extends StatelessWidget {
  final List<NewsItem> newsItems;

  const NewsItemList({super.key, required this.newsItems});

  // TODO may also implement the replacement of visible here
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: newsItems.length,
        itemBuilder: (context, index) {
          final newsItem = newsItems[index];

          return Card(
            key: ValueKey('$newsItem.id_listItem'),
            child: ListTile(
              onTap: () => _newsItemTapped(context, newsItem),
              contentPadding: const EdgeInsets.only(
                  right: InsetSizes.small,
                  top: InsetSizes.medium,
                  bottom: InsetSizes.medium),
              horizontalTitleGap: 4.0,
              titleAlignment: ListTileTitleAlignment.center,
              leading: _StoreIconNavigator(newsItem: newsItem),
              title: Text(newsItem.name,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text(newsItem.markdownContent,
                  maxLines: 2, overflow: TextOverflow.ellipsis),
              trailing: _SeenExpiresInfo(newsItem: newsItem),
            ),
          );
        },
      ),
    );
  }

  void _newsItemTapped(BuildContext context, NewsItem newsItem) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => NewsDetail(
            key: ValueKey('$newsItem.id_detail'), newsItem: newsItem)));
  }
}

class _StoreIconNavigator extends StatelessWidget {
  final NewsItem newsItem;

  const _StoreIconNavigator({super.key, required this.newsItem});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _storeIconTapped(
          context, newsItem.companyNumber, newsItem.storeNumber),
      icon: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(BorderSizes.circularRadius),
              color: Theme.of(context).colorScheme.surface),
          child: const Icon(Icons.more_horiz_rounded)),
    );
  }

  void _storeIconTapped(
          BuildContext context, int companyNumber, int storeNumber) =>
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => StoreDetail(
              key: ValueKey(
                  '${newsItem.companyNumber}.${newsItem.storeNumber}_store_detail'),
              storeNumber: newsItem.storeNumber,
              companyNumber: newsItem.companyNumber)));
}

class _SeenExpiresInfo extends StatelessWidget {
  const _SeenExpiresInfo({
    super.key,
    required this.newsItem,
  });

  final NewsItem newsItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (newsItem.scannedAt != null)
          Text('scanned %s'
              .i18n
              .fill([formatDateTimeDynamically(newsItem.scannedAt!)]))
        else
          const Text(''), // Same height as scannedAt text
        NewsItemExpiredIcon(newsItem: newsItem),
      ],
    );
  }
}
