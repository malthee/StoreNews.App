import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:storenews/domain/news_item.dart';
import 'package:storenews/manager/beacon_manager.dart';
import 'package:storenews/util/constants.dart';
import '../domain/beacon_info.dart';

class NewsManager extends Disposable {
  static final logger = GetIt.I<Logger>();
  final BeaconManager _beaconManager;
  final Map<BeaconInfo, DateTime> _lastNewsFetch = {};
  final StreamController<NewsItem> _fetchedNewsStreamController =
      StreamController.broadcast();
  late final StreamSubscription<BeaconInfo> _beaconInformationSubscription;

  /// Stream of news items that have been fetched because the user was in the beacon range.
  get fetchedNewsStream => _fetchedNewsStreamController.stream;

  NewsManager(
      {BeaconManager? beaconManager}) // Allow passing in a mock for testing.
      : _beaconManager = beaconManager ?? GetIt.I<BeaconManager>() {
    _beaconInformationSubscription = _listenToBeaconInfo();
  }

  Future<bool> init() async {
    try {
      await _beaconManager.init();
      return true;
    } catch (e) {
      logger.e("BeaconManager init failed: $e");
      return false;
    }
  }

  Future<bool> startNewsFetch() async {
    try {
      await _beaconManager.startScanning();
      _beaconInformationSubscription.resume();
      logger.d("News fetch started.");
      return true;
    } catch (e) {
      logger.e("BeaconManager start failed: $e");
      return false;
    }
  }

  Future<bool> stopNewsFetch() async {
    try {
      _beaconInformationSubscription.pause();
      await _beaconManager.stopScanning();
      logger.d("News fetch stopped.");
      return true;
    } catch (e) {
      logger.e("BeaconManager stop failed: $e");
      return false;
    }
  }

  bool shouldFetchNewsForBeacon(BeaconInfo bi) {
    final currentTime = DateTime.now();
    final lastFetched = _lastNewsFetch[bi];
    // Never fetched news for this beacon, or last fetch was more than configured time ago.
    return lastFetched == null ||
        currentTime.difference(lastFetched) > beaconNewsFetchInterval;
  }

  StreamSubscription<BeaconInfo> _listenToBeaconInfo() {
    return _beaconManager.beaconInformationStream.listen((beaconInfo) async {
      if (shouldFetchNewsForBeacon(beaconInfo)) {
        logger.i("Fetching news for beacon $beaconInfo");
        // TODO FETCH

        _lastNewsFetch[beaconInfo] = DateTime.now();
      }
    });
  }

  @override
  FutureOr onDispose() {
    _beaconInformationSubscription.cancel();
    _fetchedNewsStreamController.close();
    logger.d("NewsManager disposed.");
  }
}
