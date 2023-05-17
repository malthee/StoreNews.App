import 'package:flutter/material.dart';
import 'package:i18n_extension/default.i18n.dart';
import 'package:storenews/domain/news_item.dart';
import 'package:storenews/ui/widgets/news_item_expires_icon.dart';
import 'package:storenews/util/dynamic_datetime_format.dart';

import '../pages/news_detail.dart';

class NewsItemStepper extends StatelessWidget {
  final List<NewsItem> newsItems;

  const NewsItemStepper({super.key, required this.newsItems});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: newsItems.length,
      itemBuilder: (context, index) {
        final newsItem = newsItems[index];

        return Card(
          key: ValueKey('$newsItem.id_listItem'),
          child: ListTile(
            contentPadding: const EdgeInsets.only(right: 8.0),
            horizontalTitleGap: 4.0,
            titleAlignment: ListTileTitleAlignment.center,
            onTap: () => _itemTapped(context, index),
            leading: _leadingIcon(context),
            title: Text(newsItems[index].name,
                maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text(newsItems[index].markdownContent,
                maxLines: 2, overflow: TextOverflow.ellipsis),
            trailing: _seenExpiresInfo(index),
          ),
        );
      },
    );
  }

  IconButton _leadingIcon(BuildContext context) {
    // TODO add link to store
    return IconButton(
      icon: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              color: Theme.of(context).colorScheme.surface),
          child: const Icon(Icons.business_center)),
      onPressed: () {},
    );
  }

  Column _seenExpiresInfo(int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text('seen %s'
            .i18n
            // TODO change to seen from bluetooth
            .fill([formatDateTimeDynamically(newsItems[index].lastChanged)])),
        NewsItemExpiredIcon(newsItem: newsItems[index]),
      ],
    );
  }

  void _itemTapped(BuildContext context, int index) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => NewsDetail(newsItem: newsItems[index])));
  }
}
