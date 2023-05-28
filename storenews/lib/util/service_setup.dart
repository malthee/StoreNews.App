import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:storenews/manager/beacon_manager.dart';
import 'package:storenews/manager/news_manager.dart';
import 'package:storenews/manager/news_notification_manager.dart';
import 'package:http/http.dart' as http;
import 'package:storenews/service/authorized_client.dart';
import 'package:storenews/service/company_service.dart';
import 'package:storenews/service/image_service.dart';
import 'package:storenews/service/news_service.dart';
import 'package:storenews/util/navigation_helper.dart';
import 'package:storenews/util/notification_helper.dart';

import '../domain/news_item.dart';

void registerServices(GetIt getIt) {
  // -- Tooling -- //
  getIt.registerSingleton<Logger>(Logger());
  getIt.registerSingleton<http.Client>(AuthorizedClient(http.Client()));

  // -- Managers -- //
  getIt.registerLazySingleton<BeaconManager>(() => BeaconManager());
  getIt.registerLazySingleton<NewsManager>(() => NewsManager());
  getIt.registerLazySingleton<NewsNotificationManager>(
      () => NewsNotificationManager());

  // -- Services -- //
  getIt.registerLazySingleton<NewsService>(() => NewsService());
  getIt.registerLazySingleton<ImageService>(() => ImageService());
  getIt.registerLazySingleton<CompanyService>(() => CompanyService());
}

// Notifications Plugin needs context to navigate.
void registerNotificationPlugin(GetIt getIt, BuildContext context) {
  if (getIt.isRegistered<FlutterLocalNotificationsPlugin>()) {
    return;
  }

  const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: IOSInitializationSettings());
  getIt.registerLazySingleton<FlutterLocalNotificationsPlugin>(() =>
      FlutterLocalNotificationsPlugin()
        ..initialize(initSettings,
            onSelectNotification: (payload) =>
                Future(() => handleNotificationClick(payload, context))));
}
