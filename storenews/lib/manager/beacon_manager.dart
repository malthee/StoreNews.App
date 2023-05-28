import 'dart:async';
import 'dart:convert';
import 'package:beacons_plugin/beacons_plugin.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:storenews/domain/beacon_info.dart';
import 'package:storenews/i18n/beacon_manager.i18n.dart';
import 'package:storenews/util/constants.dart';

class BeaconManager extends Disposable {
  static const setupTimeOut = Duration(
      seconds: 10); // Otherwise BeaconPlugin methods may block forever.

  static final logger = GetIt.I<Logger>();

  final StreamController<BeaconInfo> _beaconInformationController =
      StreamController<BeaconInfo>.broadcast();
  final StreamController<String> _beaconEventsController =
      StreamController<String>.broadcast();

  final ValueNotifier<bool> isScanning = ValueNotifier(false);

  /// Stream of [BeaconInfo]s that have been detected.
  Stream<BeaconInfo> get beaconInformationStream =>
      _beaconInformationController.stream;

  /// Starts scanning for beacons.
  /// Throws a [TimeoutException] if the plugin setup takes longer than [setupTimeOut] (may be caused by missing permissions).
  Future startScanning() async {
    await _init();
    await BeaconsPlugin.startMonitoring().timeout(setupTimeOut);
    isScanning.value = true;
    logger.d("BeaconManager started scanning.");
  }

  /// Stops scanning for beacons.
  Future stopScanning() async {
    await BeaconsPlugin.stopMonitoring();
    isScanning.value = false;
    logger.d("BeaconManager stopped scanning.");
  }

  /// Requests permissions, initializes the BeaconsPlugin and sets up the beacon scanning parameters.
  /// Throws a [TimeoutException] if the plugin setup takes longer than [setupTimeOut] (may be caused by missing permissions).
  Future _init() async {
    if (enableBeaconPluginDebug) BeaconsPlugin.setDebugLevel(2);

    await Permission.location.request();
    if (!await Permission.locationAlways.request().isGranted) {
      throw Exception("Location permission not granted");
    }

    await BeaconsPlugin.setForegroundServiceNotification(
        "Store News Scan".i18n, "Store News is scanning for news.".i18n);

    await BeaconsPlugin.addRegion(beaconRegionName, beaconRegionUUID)
        .timeout(setupTimeOut);

    // TODO values from config
    //BeaconsPlugin.setForegroundScanPeriodForAndroid(foregroundScanPeriod: 2200, foregroundBetweenScanPeriod: 10);
    //BeaconsPlugin.setBackgroundScanPeriodForAndroid(backgroundScanPeriod: 2200, backgroundBetweenScanPeriod: 10);

    await BeaconsPlugin.runInBackground(true).timeout(setupTimeOut);
    BeaconsPlugin.listenToBeacons(_beaconEventsController);
    _listenToBeaconEvents();
    logger.d("BeaconManager setup complete.");
  }

  void _listenToBeaconEvents() async {
    await for (final data in _beaconEventsController.stream) {
      try {
        if (data.isNotEmpty) {
          final decoded = jsonDecode(data);
          // Only add beacons with the correct region.
          if (decoded["name"] == beaconRegionName) {
            _beaconInformationController.add(BeaconInfo.fromJson(decoded));
          }
        }
      } catch (e) {
        isScanning.value = false;
        _beaconInformationController.addError(e);
        logger.d("Error occurred in beacon event stream: $e");
      }
    }
  }

  @override
  FutureOr onDispose() {
    _beaconInformationController.close();
    _beaconEventsController.close();
    logger.d("BeaconManager disposed.");
  }
}
