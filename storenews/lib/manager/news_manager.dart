import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:storenews/domain/news_item.dart';
import 'package:storenews/manager/beacon_manager.dart';
import 'package:storenews/service/news_service.dart';
import 'package:storenews/util/constants.dart';
import '../domain/beacon_info.dart';

class NewsManager extends Disposable {
  static final logger = GetIt.I<Logger>();
  final BeaconManager _beaconManager;
  final NewsService _newsService;
  final Map<BeaconInfo, DateTime> _lastNewsFetch = {};
  final Set<NewsItem> _seenNews = {}; // TODO allow merge with store newsitems

  final StreamController<NewsItem> _fetchedNewsStreamController =
      StreamController.broadcast();
  StreamSubscription<BeaconInfo>? _beaconInformationSubscription;

  final isRunning = ValueNotifier(false);

  /// Stream of news items that have been fetched because the user was in the beacon range.
  Stream<NewsItem> get fetchedNewsStream => _fetchedNewsStreamController.stream;

  Set<NewsItem> get seenNews => _seenNews;

  NewsManager(
      {BeaconManager? beaconManager,
      NewsService? newsService}) // Allow passing in a mock for testing.
      : _beaconManager = beaconManager ?? GetIt.I<BeaconManager>(),
        _newsService = newsService ?? GetIt.I<NewsService>();

  /// Starts the news fetching process. This will start the beacon manager and listen to beacon information.
  Future<bool> startNewsFetch() async {
    try {
      _beaconInformationSubscription ??= _listenToBeaconInfo();
      await _beaconManager.startScanning();
      isRunning.value = true;
      logger.d("News fetch started.");
      return true;
    } catch (e) {
      logger.e("BeaconManager start failed: $e");
      return false;
    }
  }

  /// Stops the news fetching process. This will stop the beacon manager and stop listening to beacon information.
  Future<bool> stopNewsFetch() async {
    try {
      _beaconInformationSubscription?.cancel();
      _beaconInformationSubscription = null;
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

  /// Listens to the scanned beacons and fetches news for them. New news items are added to the [_fetchedNewsStreamController].
  StreamSubscription<BeaconInfo> _listenToBeaconInfo() {
    return _beaconManager.beaconInformationStream.listen((beaconInfo) async {
      if (_shouldFetchNewsForBeacon(beaconInfo)) {
        logger.i("Fetching news for beacon $beaconInfo");
        _fetchLatestNews(beaconInfo); // Async fetch, do not block stream
      }
    });
  }

  Future _fetchLatestNews(BeaconInfo beaconInfo) async {
    // Prevent fetching news for this beacon again for a while.
    _lastNewsFetch[beaconInfo] = DateTime.now();

    final ni =
        await _newsService.getLatestNews(beaconInfo.major, beaconInfo.minor)
          ?..scannedAt = DateTime.now();

    // When news was fetched more than once, we don't want to show it again.
    if (ni != null) {
      if (!_seenNews.contains(ni)) {
        _fetchedNewsStreamController.add(ni);
        _seenNews.add(ni);
        logger.i("New news fetched for beacon $beaconInfo: $ni");
      } else {
        logger.d("Latest news has not changed for $beaconInfo");
      }
    }
  }

  @override
  FutureOr onDispose() {
    _beaconInformationSubscription?.cancel();
    _fetchedNewsStreamController.close();
    logger.d("NewsManager disposed.");
  }
}
