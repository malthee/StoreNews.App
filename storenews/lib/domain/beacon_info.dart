import '../util/constants.dart';

class BeaconInfo {
  final int major, minor;
  final double distanceMeter;

  // Last time news for this beacon was fetched, TODO extract to logic
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
    required this.distanceMeter,
  });

  factory BeaconInfo.fromJson(Map<String, dynamic> json) {
    return BeaconInfo(
      major: int.parse(json['major']),
      minor: int.parse(json['minor']),
      distanceMeter: double.parse(json['distance']),
    );
  }

  @override
  String toString() {
    return 'BeaconInfo{major: $major, minor: $minor, distanceMeter: $distanceMeter}';
  }
}
