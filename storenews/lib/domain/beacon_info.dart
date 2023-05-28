import '../util/constants.dart';

class BeaconInfo {
  final int major, minor;
  final double distanceMeter;

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

  // BeaconInfo is equal when major and minor are equal
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BeaconInfo &&
          runtimeType == other.runtimeType &&
          major == other.major &&
          minor == other.minor;

  @override
  int get hashCode => major.hashCode ^ minor.hashCode;
}
