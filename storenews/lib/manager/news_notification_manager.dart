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
  late final StreamSubscription<NewsItem> _newsItemSubscription;

  set appInForeground(bool value) {
    // Pause the news item subscription when the app is in the foreground.
    if (value) {
      _newsItemSubscription.pause();
    } else {
      _newsItemSubscription.resume();
    }
  }

  DateTime? _lastNotificationSent;

  NewsNotificationManager({NewsManager? newsManager})
      : _newsManager = newsManager ?? GetIt.I<NewsManager>() {
    _newsItemSubscription = _listenToFetchedNews();
  }

  /// Aggregate and send out notifications
  StreamSubscription<NewsItem> _listenToFetchedNews() {
    return _newsManager.fetchedNewsStream.listen((newsItem) {
      final currentDate = DateTime.now();
      _itemsSinceLastNotification.add(newsItem);

      if (_lastNotificationSent == null ||
          currentDate.difference(_lastNotificationSent!) >
              notificationCoolDown) {
        _lastNotificationSent = currentDate;
        showNewsNotification(
            notificationPlugin, _itemsSinceLastNotification.toList());
        _itemsSinceLastNotification.clear();
      }
    });
  }

  @override
  FutureOr onDispose() {
    _newsItemSubscription.cancel();
  }
}
