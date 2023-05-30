class NewsItem {
  final String id;
  final int storeNumber;
  final int companyNumber;
  final String name;
  final String markupContent;
  final DateTime lastChanged;
  final DateTime? expires;
  final String? detailImageId;
  DateTime? scannedAt;
  bool read = false;

  NewsItem({
    required this.id,
    required this.name,
    required this.markupContent,
    required this.storeNumber,
    required this.companyNumber,
    required this.lastChanged,
    this.expires,
    this.detailImageId,
  });

  isExpired(DateTime currentTime) =>
      expires != null && currentTime.isAfter(expires!);

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      id: json['id'],
      name: json['name'],
      markupContent: json['markupContent'],
      storeNumber: json['storeNumber'],
      companyNumber: json['companyNumber'],
      lastChanged: DateTime.parse(json['lastChanged']),
      expires: json['expires'] == null ? null : DateTime.parse(json['expires']),
      detailImageId: json['detailImageId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'markupContent': markupContent,
      'storeNumber': storeNumber,
      'companyNumber': companyNumber,
      'lastChanged': lastChanged.toIso8601String(),
      'expires': expires?.toIso8601String(),
      'detailImageId': detailImageId,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewsItem && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'NewsItem{id: $id, storeNumber: $storeNumber, companyNumber: $companyNumber, name: $name, markupContent: $markupContent, lastChanged: $lastChanged, expires: $expires, detailImageId: $detailImageId, scannedAt: $scannedAt, read: $read}';
  }
}
