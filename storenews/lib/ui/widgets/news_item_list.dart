import 'package:flutter/material.dart';
import 'package:storenews/domain/news_item.dart';
import 'package:storenews/ui/widgets/news_item_expires_icon.dart';
import 'package:storenews/util/dynamic_datetime_format.dart';
import 'package:storenews/util/navigation_helper.dart';

import '../../util/constants.dart';
import '../../i18n/news_item_list.i18n.dart';

/// Shows either a list of [NewsItem]s or a message that there are none
class NewsItemList extends StatelessWidget {
  final List<NewsItem> newsItems;
  final ScrollPhysics? scrollPhysics;
  final bool showTimeAgo;

  const NewsItemList(
      {super.key,
      required this.newsItems,
      this.scrollPhysics,
      this.showTimeAgo = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentDateTime = DateTime.now();
    String? lastScannedAgoString; // Used for showing .. time ago

    return Visibility(
      visible: newsItems.isNotEmpty,
      replacement: const _NewsNotFound(),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: InsetSizes.small),
        shrinkWrap: true,
        physics: scrollPhysics,
        itemCount: newsItems.length,
        itemBuilder: (context, index) {
          final newsItem = newsItems[index];
          // Create a string to group the news items by time ago
          final agoString =
              _scannedTimeAgoString(currentDateTime, newsItem.scannedAt);
          final showAgoTitle = showTimeAgo && lastScannedAgoString != agoString;
          lastScannedAgoString = agoString;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                  visible: showAgoTitle,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: InsetSizes.medium,
                        top: InsetSizes.medium,
                        bottom: InsetSizes.small),
                    child: Text(agoString, style: theme.textTheme.titleLarge),
                  )),
              Card(
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
              ),
            ],
          );
        },
      ),
    );
  }

  void _newsItemTapped(BuildContext context, NewsItem newsItem) {
      navigateToNewsDetail(context, newsItem);
  }

  String _scannedTimeAgoString(DateTime currentDateTime, DateTime? dateTime) {
    if (dateTime == null) return 'Unknown'.i18n;
    final difference = currentDateTime.difference(dateTime);

    if (difference.inDays > 0) {
      return 'Older'.i18n;
    } else if (difference.inHours > 0) {
      return 'Hours ago'.i18n;
    } else if (difference.inMinutes > 0) {
      return 'A few minutes ago'.i18n;
    } else {
      return 'Just now'.i18n;
    }
  }
}

class _StoreIconNavigator extends StatelessWidget {
  final NewsItem newsItem;

  const _StoreIconNavigator({super.key, required this.newsItem});

  @override
  Widget build(BuildContext context) {
    // TODO icon from company, may own component with store_icon_name
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
      navigateToStore(context, companyNumber, storeNumber);
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

class _NewsNotFound extends StatelessWidget {
  const _NewsNotFound({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(InsetSizes.medium),
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
      ),
    );
  }
}
