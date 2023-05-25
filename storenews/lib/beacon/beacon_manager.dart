import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:beacons_plugin/beacons_plugin.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:storenews/domain/beacon_info.dart';

class BeaconManager extends Disposable {
  final StreamController<BeaconInfo> _beaconInformationController =
      StreamController<BeaconInfo>.broadcast();
  final StreamController<String> _beaconEventsController =
      StreamController<String>.broadcast();

  final ValueNotifier<bool> isScanning = ValueNotifier(false);
  Stream<BeaconInfo> get beaconInformationStream => _beaconInformationController.stream;

  BeaconManager._create() {
    BeaconsPlugin.listenToBeacons(_beaconEventsController);
    _listenToBeaconEvents();
    print("i get heree!");
  }

  Future stopScanning() async {
    await BeaconsPlugin.clearRegions();
    await BeaconsPlugin.stopMonitoring();
    isScanning.value = false;
  }

  Future startScanning() async {
   // await BeaconsPlugin.startMonitoring();
    print("stillstart");

    // BeaconsPlugin.addBeaconLayoutForAndroid(
    //     "m:2-3=beac,i:4-19,i:20-21,i:22-23,p:24-24,d:25-25");
    // BeaconsPlugin.addBeaconLayoutForAndroid(
    //     "m:2-3=0215,i:4-19,i:20-21,i:22-23,p:24-24");
    //BeaconsPlugin.addRegion("ADFLJK", "acfd065e-c3c0-11e3-9bbe-1a514932ac01");
    //await BeaconsPlugin.clearRegions();

    BeaconsPlugin.channel.setMethodCallHandler((call) async {
      debugPrint("!!!!Method: ${call.method}");
      await BeaconsPlugin.startMonitoring();
    });
    print("still");
    isScanning.value = true;
  }

  static Future<BeaconManager> create() async {
    //await _resetBeaconsPlugin();


    // TODO REMOVE
    BeaconsPlugin.setDebugLevel(2);

    // TODO UUID

    // TODO values from config
    //BeaconsPlugin.setForegroundScanPeriodForAndroid(foregroundScanPeriod: 2200, foregroundBetweenScanPeriod: 10);
    //BeaconsPlugin.setBackgroundScanPeriodForAndroid(backgroundScanPeriod: 2200, backgroundBetweenScanPeriod: 10);

    await BeaconsPlugin.runInBackground(true);

    return BeaconManager._create();
  }

  static Future<void> _resetBeaconsPlugin() async {
    await BeaconsPlugin.clearRegions();
    await BeaconsPlugin.stopMonitoring();
    BeaconsPlugin.channel.setMethodCallHandler(null);
  }

  void _listenToBeaconEvents() async {
    await for (final data in _beaconEventsController.stream) {
      try {
        print("data: $data IN POG");
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
