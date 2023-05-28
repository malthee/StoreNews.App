class Company {
  final int companyNumber;
  final String name;
  final String? logoImageId;

  const Company({
    required this.companyNumber,
    required this.name,
    required this.logoImageId,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      companyNumber: json['companyNumber'],
      name: json['name'],
      logoImageId: json['logoImageId'],
    );
  }
}