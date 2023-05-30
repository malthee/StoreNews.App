import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:storenews/manager/news_manager.dart';
import 'package:storenews/util/constants.dart';
import 'package:storenews/util/notification_helper.dart';

import '../domain/news_item.dart';

class NewsNotificationManager extends Disposable {
  static final logger = GetIt.I<Logger>();
  static final notificationPlugin = GetIt.I<FlutterLocalNotificationsPlugin>();
  final NewsManager _newsManager;
  final Set<NewsItem> _itemsSinceLastNotification = {};
  StreamSubscription<NewsItem>? _newsItemSubscription;
  DateTime? _lastNotificationSent;

  set appInForeground(bool isForeground) {
    // Pause the news item subscription when the app is in the foreground.
    if (isForeground && _newsItemSubscription != null) {
      _newsItemSubscription!.cancel();
      _newsItemSubscription = null;
      logger.d("Stopped notification subscription.");
    } else if (!isForeground && _newsItemSubscription == null) {
      // Only init the subscription when it's not already running.
      _newsItemSubscription = _listenToFetchedNews();
      logger.d("Started notification subscription.");
    }
  }

  NewsNotificationManager({NewsManager? newsManager})
      : _newsManager = newsManager ?? GetIt.I<NewsManager>();

  /// Aggregate and send out notifications
  StreamSubscription<NewsItem> _listenToFetchedNews() {
    return _newsManager.fetchedNewsStream.listen((newsItem) {
      final currentDate = DateTime.now();
      _itemsSinceLastNotification.add(newsItem);

      if (_lastNotificationSent == null ||
          currentDate.difference(_lastNotificationSent!) >
              notificationCoolDown) {
        logger.i("Sending notification.");
        _lastNotificationSent = currentDate;
        showNewsNotification(
            notificationPlugin, _itemsSinceLastNotification.toList());
        _itemsSinceLastNotification.clear();
      }
    });
  }

  @override
  FutureOr onDispose() {
    _newsItemSubscription?.cancel();
    logger.d("NewsNotificationManager disposed.");
  }
}
