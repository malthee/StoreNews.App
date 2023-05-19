import 'package:flutter/material.dart';
import 'package:i18n_extension/default.i18n.dart';
import 'package:storenews/domain/news_item.dart';
import 'package:storenews/ui/widgets/news_item_expires_icon.dart';
import 'package:storenews/util/dynamic_datetime_format.dart';

import '../../util/constants.dart';
import '../pages/news_detail.dart';

class NewsItemList extends StatelessWidget {
  final List<NewsItem> newsItems;

  const NewsItemList({super.key, required this.newsItems});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: newsItems.length,
      itemBuilder: (context, index) {
        final newsItem = newsItems[index];

        return Card(
          key: ValueKey('$newsItem.id_listItem'),
          child: ListTile(
            onTap: () => _itemTapped(context, newsItem),
            contentPadding: const EdgeInsets.only(
                right: InsetSizes.small,
                top: InsetSizes.medium,
                bottom: InsetSizes.medium),
            horizontalTitleGap: 4.0,
            titleAlignment: ListTileTitleAlignment.center,
            leading: _leadingIcon(context),
            title: Text(newsItem.name,
                maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text(newsItem.markdownContent,
                maxLines: 2, overflow: TextOverflow.ellipsis),
            trailing: _seenExpiresInfo(newsItem),
          ),
        );
      },
    );
  }

  IconButton _leadingIcon(BuildContext context) {
    return IconButton(
      icon: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(BorderSizes.circularRadius),
              color: Theme.of(context).colorScheme.surface),
          child: const Icon(Icons.more_horiz_rounded)),
      onPressed: () {}, // TODO add link to store
    );
  }

  Column _seenExpiresInfo(NewsItem newsItem) {
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

  void _itemTapped(BuildContext context, NewsItem newsItem) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => NewsDetail(
            key: ValueKey('$newsItem.id_detail'), newsItem: newsItem)));
  }
}
