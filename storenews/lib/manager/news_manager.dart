import 'dart:async';

import 'package:flutter/cupertino.dart';
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
  final Set<String> _seenNews = {};

  final StreamController<NewsItem> _fetchedNewsStreamController =
      StreamController.broadcast();
  late final StreamSubscription<BeaconInfo> _beaconInformationSubscription;

  final isRunning = ValueNotifier(false);

  /// Stream of news items that have been fetched because the user was in the beacon range.
  Stream<NewsItem> get fetchedNewsStream => _fetchedNewsStreamController.stream;

  NewsManager(
      {BeaconManager? beaconManager}) // Allow passing in a mock for testing.
      : _beaconManager = beaconManager ?? GetIt.I<BeaconManager>() {
    _beaconInformationSubscription = _listenToBeaconInfo();
  }

  Future<bool> startNewsFetch() async {
    try {
      await _beaconManager.startScanning();
      _beaconInformationSubscription.resume();
      isRunning.value = true;
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
      isRunning.value = false;
      logger.d("News fetch stopped.");
      return true;
    } catch (e) {
      logger.e("BeaconManager stop failed: $e");
      return false;
    }
  }

  // Beacon is close and never fetched news for this beacon, or last fetch was more than configured time ago.
  bool _shouldFetchNewsForBeacon(BeaconInfo bi) {
    final currentTime = DateTime.now();
    final lastFetched = _lastNewsFetch[bi];
    return bi.distanceMeter <= beaconRecognitionDistance &&
        (lastFetched == null ||
            currentTime.difference(lastFetched) > beaconNewsFetchInterval);
  }

  StreamSubscription<BeaconInfo> _listenToBeaconInfo() {
    return _beaconManager.beaconInformationStream.listen((beaconInfo) async {
      if (_shouldFetchNewsForBeacon(beaconInfo)) {
        logger.i("Fetching news for beacon $beaconInfo");
        NewsItem ni = NewsItem(
            name: 'News Item 1',
            markdownContent:
                'News Item 1 content content content Description #HELLO and so on',
            lastChanged: DateTime.now(),
            companyNumber: 1,
            storeNumber: 1,
            id: '1')
          ..scannedAt = DateTime.now();

        _lastNewsFetch[beaconInfo] = DateTime.now();

        // When news was fetched more than once, we don't want to show it again.
        if (!_seenNews.contains(ni.id)) {
          _fetchedNewsStreamController.add(ni);
          _seenNews.add(ni.id);
        } else {
          logger.d("NewsItem fetched but already seen, not showing again: ${ni.id}");
        }
      }
    }, onError: (e) {
      // TODO;
      logger.e("BeaconManager error: $e");
    });
  }

  @override
  FutureOr onDispose() {
    _beaconInformationSubscription.cancel();
    _fetchedNewsStreamController.close();
    logger.d("NewsManager disposed.");
  }
}
