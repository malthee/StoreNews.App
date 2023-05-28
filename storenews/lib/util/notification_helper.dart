import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:storenews/util/navigation_helper.dart';

import '../domain/news_item.dart';

var newsNotificationCount = 0;

void showNewsNotification(FlutterLocalNotificationsPlugin notificationsPlugin,
    List<NewsItem> newsItems) async {
  if (newsItems.isEmpty) return;

  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    "newsItemChannel",
    "News Item Channel",
    "Where new News Items detected by StoreNews are shown",
    playSound: false,
    vibrationPattern:
        Int64List.fromList([100, 10, 100, 10, 100]), // Funny feature
  );
  var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);

  if (newsItems.length == 1) {
    final item = newsItems.first;
    await notificationsPlugin.show(newsNotificationCount++, item.name,
        item.markupContent, platformChannelSpecifics,
        payload: jsonEncode(item.toJson()));
  } else {
    final names = newsItems.map((i) => i.name).join('\n');
    await notificationsPlugin.show(newsNotificationCount++,
        '${newsItems.length} new News Items', names, platformChannelSpecifics,
        payload: jsonEncode(newsItems.first.toJson())); // Payload is first item
  }
}

void handleNotificationClick(String? payload, BuildContext context) {
  if (payload != null) {
    try {
      final newsItem = NewsItem.fromJson(jsonDecode(payload));
      navigateToNewsDetail(context, newsItem);
    } catch (_) {} // If navigation does not work, do nothing
  }
}
