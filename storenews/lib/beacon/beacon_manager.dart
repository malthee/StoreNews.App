import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:beacons_plugin/beacons_plugin.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:storenews/domain/beacon_info.dart';

class BeaconManager extends Disposable {
  static const setupTimeOut = Duration(seconds: 10);

  final StreamController<BeaconInfo> _beaconInformationController =
      StreamController<BeaconInfo>.broadcast();
  final StreamController<String> _beaconEventsController =
      StreamController<String>.broadcast();

  final ValueNotifier<bool> isScanning = ValueNotifier(false);

  Stream<BeaconInfo> get beaconInformationStream =>
      _beaconInformationController.stream;

  BeaconManager._create() {
    BeaconsPlugin.listenToBeacons(_beaconEventsController);
    _listenToBeaconEvents();
  }

  Future stopScanning() async {
    await BeaconsPlugin.stopMonitoring();
    isScanning.value = false;
  }

  /// Starts scanning for beacons.
  /// Throws a [TimeoutException] if the plugin setup takes longer than [setupTimeOut] (may be caused by missing permissions).
  Future startScanning() async {
    await BeaconsPlugin.startMonitoring().timeout(setupTimeOut);
    isScanning.value = true;
  }

  /// Creates a new instance of [BeaconManager] and initializes the plugin.
  /// Throws a [TimeoutException] if the plugin setup takes longer than [setupTimeOut] (may be caused by missing permissions).
  static Future<BeaconManager> create() async {
    // TODO REMOVE
    BeaconsPlugin.setDebugLevel(2);

    BeaconsPlugin.channel.setMethodCallHandler((call) async {
      debugPrint("!!!!Method: ${call.method}");
    });

    // TODO handle with other permissions thing, should not be shown, but call is required here
    if (Platform.isAndroid) {
      await BeaconsPlugin.setDisclosureDialogMessage(
          title: "Background Locations",
          message:
              "[This app] collects location data to enable [feature], [feature], & [feature] even when the app is closed or not in use");
    }

    await BeaconsPlugin.setForegroundServiceNotification("Store News Scan", "Store News is scanning for news.");

    // TODO UUID
    await BeaconsPlugin.addRegion(
            "ADFLJK", "acfd065e-c3c0-11e3-9bbe-1a514932ac01")
        .timeout(setupTimeOut);

    // TODO values from config
    //BeaconsPlugin.setForegroundScanPeriodForAndroid(foregroundScanPeriod: 2200, foregroundBetweenScanPeriod: 10);
    //BeaconsPlugin.setBackgroundScanPeriodForAndroid(backgroundScanPeriod: 2200, backgroundBetweenScanPeriod: 10);

    await BeaconsPlugin.runInBackground(true).timeout(setupTimeOut);

    return BeaconManager._create();
  }

  void _listenToBeaconEvents() async {
    await for (final data in _beaconEventsController.stream) {
      try {
        if (data.isNotEmpty) {
          _beaconInformationController
              .add(BeaconInfo.fromJson(jsonDecode(data)));
        }
      } catch (e) {
        isScanning.value = false;
        _beaconInformationController.addError(e);
      }
    }
  }

  @override
  FutureOr onDispose() {
    _beaconInformationController.close();
    _beaconEventsController.close();
  }
}
