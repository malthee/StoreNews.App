import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:storenews/manager/beacon_manager.dart';
import 'package:storenews/manager/news_manager.dart';
import 'package:storenews/manager/news_notification_manager.dart';

void registerServices(GetIt getIt) {
  // -- Tooling -- //
  getIt.registerLazySingleton<FlutterLocalNotificationsPlugin>(() =>
      FlutterLocalNotificationsPlugin()
        ..initialize(const InitializationSettings(
            android: AndroidInitializationSettings('@mipmap/ic_launcher'),
            iOS: IOSInitializationSettings())));
  getIt.registerSingleton<Logger>(Logger());

  // -- Managers -- //
  getIt.registerLazySingleton<BeaconManager>(() => BeaconManager());
  getIt.registerLazySingleton<NewsManager>(() => NewsManager());
  getIt.registerLazySingleton<NewsNotificationManager>(() => NewsNotificationManager());

  // -- Services -- //
}
