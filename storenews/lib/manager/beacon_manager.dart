import 'dart:async';
import 'dart:convert';
import 'package:beacons_plugin/beacons_plugin.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:storenews/domain/beacon_info.dart';
import 'package:storenews/i18n/beacon_manager.i18n.dart';
import 'package:storenews/util/constants.dart';

const setupTimeOut = Duration(
    seconds: 10); // Otherwise BeaconPlugin methods may block forever.

class BeaconManager extends Disposable {

  static final logger = GetIt.I<Logger>();

  final StreamController<BeaconInfo> _beaconInformationController =
  StreamController<BeaconInfo>.broadcast();
  final StreamController<String> _beaconEventsController =
  StreamController<String>.broadcast();
  StreamSubscription<String>? _beaconEventsSubscription;

  /// Stream of [BeaconInfo]s that have been detected.
  Stream<BeaconInfo> get beaconInformationStream =>
      _beaconInformationController.stream;

  /// Starts scanning for beacons.
  /// Throws a [TimeoutException] if the plugin setup takes longer than [setupTimeOut] (may be caused by missing permissions).
  Future startScanning() async {
    await _init();
    _beaconEventsSubscription ??= _listenToBeaconEvents();
    await BeaconsPlugin.startMonitoring().timeout(setupTimeOut);
    logger.d("BeaconManager started scanning.");
  }

  /// Stops scanning for beacons.
  Future stopScanning() async {
    _beaconEventsSubscription?.cancel();
    _beaconEventsSubscription = null;
    await BeaconsPlugin.stopMonitoring();
    logger.d("BeaconManager stopped scanning.");
  }

  /// Requests permissions, initializes the BeaconsPlugin and sets up the beacon scanning parameters.
  /// Throws a [TimeoutException] if the plugin setup takes longer than [setupTimeOut] (may be caused by missing permissions).
  Future _init() async {
    if (enableBeaconPluginDebug) BeaconsPlugin.setDebugLevel(2);

    await Permission.location.request();
    if (!await Permission.locationAlways
        .request()
        .isGranted) {
      throw Exception("Location permission not granted");
    }

    await BeaconsPlugin.setForegroundServiceNotification(
        "Store News Scan".i18n, "Store News is scanning for news.".i18n);

    await BeaconsPlugin.addRegion(beaconRegionName, beaconRegionUUID)
        .timeout(setupTimeOut);

    BeaconsPlugin.setForegroundScanPeriodForAndroid(
        foregroundScanPeriod: beaconScanDuration.inMilliseconds,
        foregroundBetweenScanPeriod: beaconForegroundScanPause.inMilliseconds);
    BeaconsPlugin.setBackgroundScanPeriodForAndroid(
        backgroundScanPeriod: beaconScanDuration.inMilliseconds,
        backgroundBetweenScanPeriod: beaconBackgroundScanPause.inMilliseconds);

    await BeaconsPlugin.runInBackground(true).timeout(setupTimeOut);
    BeaconsPlugin.listenToBeacons(_beaconEventsController);
    logger.d("BeaconManager setup complete.");
  }

  StreamSubscription<String> _listenToBeaconEvents() {
    return _beaconEventsController.stream.listen((data) {
      try {
        if (data.isNotEmpty) {
          final decoded = jsonDecode(data);
          // Only add beacons with the correct region.
          if (decoded["name"] == beaconRegionName) {
            _beaconInformationController
                .add(BeaconInfo.fromBeaconEvent(decoded));
          }
        }
      } catch (e) {
        logger.e("Error occurred in handling beacon data: $e");
      }
    }, onError: (error) {
      _beaconInformationController.addError(error);
      logger.e("Error occurred in beacon event stream: $error");
    });
  }

  @override
  FutureOr onDispose() {
    _beaconInformationController.close();
    _beaconEventsController.close();
    logger.d("BeaconManager disposed.");
  }
}
