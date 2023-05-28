class NewsItem {
  final String id;
  final int storeNumber;
  final int companyNumber;
  final String name;
  final String markdownContent;
  final DateTime lastChanged;
  final DateTime? expires;
  final String? detailImageId;
  DateTime? scannedAt;
  bool read = false;

  NewsItem({
    required this.id,
    required this.name,
    required this.markdownContent,
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
      id: json['id'] as String,
      name: json['name'] as String,
      markdownContent: json['markdownContent'] as String,
      storeNumber: json['storeNumber'] as int,
      companyNumber: json['companyNumber'] as int,
      lastChanged: DateTime.parse(json['lastChanged'] as String),
      expires: json['expires'] == null
          ? null
          : DateTime.parse(json['expires'] as String),
      detailImageId: json['detailImageId'] as String?,
    );
  }

  @override
  String toString() {
    return 'NewsItem{id: $id, storeNumber: $storeNumber, companyNumber: $companyNumber, name: $name, markdownContent: $markdownContent, lastChanged: $lastChanged, expires: $expires, detailImageId: $detailImageId, scannedAt: $scannedAt, read: $read}';
  }
}
