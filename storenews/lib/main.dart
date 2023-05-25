import 'dart:async';
import 'dart:io';

import 'package:beacons_plugin/beacons_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:storenews/beacon/beacon_manager.dart';
import 'package:storenews/ui/pages/news_overview.dart';
import 'package:storenews/util/constants.dart';
import 'package:storenews/util/service_setup.dart';

final getIt = GetIt.instance;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  registerServices(getIt);
  runApp(const StoreNewsApp());
}

class StoreNewsApp extends StatefulWidget {
  const StoreNewsApp({super.key});

  @override
  State<StoreNewsApp> createState() => _StoreNewsAppState();
}

class _StoreNewsAppState extends State<StoreNewsApp>
    with WidgetsBindingObserver {
  bool _darkModeEnabled = false;
  bool _isInForeground = true;

  void toggleDarkMode(bool enabled) {
    setState(() {
      _darkModeEnabled = enabled;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Only show notifications if the app is in the background.
    super.didChangeAppLifecycleState(state);
    _isInForeground = state == AppLifecycleState.resumed;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    print("haaaaoo");
    await getIt.isReady<BeaconManager>();
    final beaconsManager = await getIt.getAsync<BeaconManager>();

    beaconsManager.beaconInformationStream.listen((beaconInfo) {
      if (!_isInForeground) {
        _showNotification("Beacons DataReceived: $beaconInfo");
      } else {
        debugPrint("Beacons DataReceived: $beaconInfo");
      }
    }, onDone: () {
      debugPrint("DONE!!!!");
    }, onError: (error) {
      // TODO show error
      debugPrint("Error: $error");
    });

    print("start");
    await beaconsManager.startScanning();
  }

  int notifcounter = 0;

  void _showNotification(String subtitle) {
    final notif = getIt<FlutterLocalNotificationsPlugin>();
    notifcounter++;

    Future.delayed(Duration(seconds: 5)).then((result) async {
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id',
        'your channel name',
        'your channel description',
        importance: Importance.low,
        priority: Priority.low,
        ticker: 'ticker',
        playSound: false,
        enableVibration: false,
      );
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);
      await notif.show(notifcounter, "hey", subtitle, platformChannelSpecifics,
          payload: 'item x');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const [Locale('en', 'US')],
      theme: ThemeData.from(colorScheme: lightColorScheme, useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: _darkModeEnabled ? ThemeMode.dark : ThemeMode.light,
      home: NewsOverview(onDarkModeToggle: toggleDarkMode),
    );
  }
}
