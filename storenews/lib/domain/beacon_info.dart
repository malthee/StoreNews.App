
class BeaconInfo {
  /// Major -> Company, Minor -> Store
  final int major, minor;
  final double distanceMeter;

  BeaconInfo({
    required this.major,
    required this.minor,
    required this.distanceMeter,
  });

  factory BeaconInfo.fromBeaconEvent(Map<String, dynamic> event) {
    return BeaconInfo(
      major: int.parse(event['major']),
      minor: int.parse(event['minor']),
      distanceMeter: double.parse(event['distance']),
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
