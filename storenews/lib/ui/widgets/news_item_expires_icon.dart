import 'package:flutter/material.dart';
import 'package:storenews/util/constants.dart';
import '../../domain/news_item.dart';
import '../../util/dynamic_datetime_format.dart';
import '../../i18n/news_item_expires.i18n.dart';

class NewsItemExpiredIcon extends StatelessWidget {
  final NewsItem newsItem;

  const NewsItemExpiredIcon({super.key, required this.newsItem});

  @override
  Widget build(BuildContext context) {
    final currentTime = DateTime.now();
    final expires = newsItem.expires;

    if (expires == null) {
      return _expiresToolTip('Never expires'.i18n,
          const Icon(Icons.check_circle, color: Colors.green));
    } else if (newsItem.isExpired(currentTime)) {
      return _expiresToolTip(
          'Expired on %s'.i18n.fill([formatDateTimeDynamically(expires)]),
          const Icon(Icons.cancel, color: Colors.red));
    } else {
      return _expiresToolTip(
          'Expires on %s'.i18n.fill([formatDateTimeDynamically(expires)]),
          const Icon(Icons.timelapse, color: Colors.orange));
    }
  }

  Widget _expiresToolTip(String message, Icon icon) => Tooltip(
        triggerMode: TooltipTriggerMode.tap,
        message: message,
        child: icon,
      );
}
