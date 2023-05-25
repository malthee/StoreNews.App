import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:storenews/beacon/beacon_manager.dart';


void registerServices(GetIt getIt){
  getIt.registerLazySingleton<FlutterLocalNotificationsPlugin>(() => FlutterLocalNotificationsPlugin()
  ..initialize(const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/launcher_icon'),
      iOS: IOSInitializationSettings()
  )));

  getIt.registerLazySingletonAsync<BeaconManager>(() {
    print("this happens");
    return BeaconManager.create();
  });



}