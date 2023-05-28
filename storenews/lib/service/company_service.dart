import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:storenews/domain/company.dart';
import 'package:storenews/util/constants.dart';

typedef Client = http.Client;
// TODO caching as companies dont change often

class CompanyService {
  final Client httpClient;

  Uri companyEndpoint(int id) => Uri.parse("$apiBaseUrl/company/$id");

  CompanyService({Client? httpClient})
      : httpClient = httpClient ?? GetIt.instance.get<Client>();

  Future<Company?> get(int companyNumber) async {
    final response = await httpClient.get(companyEndpoint(companyNumber));
    return response.statusCode == 200
        ? Company.fromJson(jsonDecode(utf8.decode(response.bodyBytes)))
        : null;
  }
}
