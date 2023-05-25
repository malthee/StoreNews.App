import '../util/constants.dart';

class BeaconInfo {
  final int major, minor;

  // Last time news for this beacon was fetched
  DateTime? _lastNewsFetch;

  set lastNewsFetch(DateTime value) {
    _lastNewsFetch = value;
  }

  bool isNewsFetchNeeded(DateTime currentTime) {
    if (_lastNewsFetch == null) return true;
    return currentTime.difference(_lastNewsFetch!) > beaconNewsFetchInterval;
  }

  BeaconInfo({
    required this.major,
    required this.minor,
  });

  factory BeaconInfo.fromJson(Map<String, dynamic> json) {
    return BeaconInfo(
      major: json['major'] as int,
      minor: json['minor'] as int,
    );
  }
}
