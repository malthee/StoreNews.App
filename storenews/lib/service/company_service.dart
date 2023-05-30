import 'dart:convert';
import 'dart:math';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:storenews/domain/company.dart';
import 'package:storenews/util/constants.dart';

typedef Client = http.Client;

class CompanyService {
  static final logger = GetIt.I<Logger>();
  final Client httpClient;
  final Map<int, Company> _companyCache = {};

  Uri companyEndpoint(int id) => Uri.parse("$apiBaseUrl/company/$id");

  CompanyService({Client? httpClient})
      : httpClient = httpClient ?? GetIt.instance.get<Client>();

  Future<Company?> get(int companyNumber) async {
    if (_companyCache.containsKey(companyNumber)) {
      logger.d("Company $companyNumber found in cache");
      return _companyCache[companyNumber];
    }

    logger.d("Company $companyNumber fetched from API");
    final response = await httpClient.get(companyEndpoint(companyNumber));
    return response.statusCode == 200
        ? _companyCache[companyNumber] =
            Company.fromJson(jsonDecode(utf8.decode(response.bodyBytes)))
        : null;
  }
}
