class Store {
  final int companyNumber, storeNumber;
  final String name;
  final String description;
  final List<String>? sliderImageIds;

  const Store({
    required this.companyNumber,
    required this.storeNumber,
    required this.name,
    required this.description,
    required this.sliderImageIds,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      companyNumber: json['companyNumber'],
      storeNumber: json['storeNumber'],
      name: json['name'],
      description: json['description'],
      sliderImageIds: json['sliderImageIds']?.cast<String>(),
    );
  }
}

class StoreKey {
  final int companyNumber, storeNumber;

  const StoreKey({
    required this.companyNumber,
    required this.storeNumber,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoreKey &&
          runtimeType == other.runtimeType &&
          companyNumber == other.companyNumber &&
          storeNumber == other.storeNumber;

  @override
  int get hashCode => companyNumber.hashCode ^ storeNumber.hashCode;
}
