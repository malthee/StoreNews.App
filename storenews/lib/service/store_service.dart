import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:storenews/domain/store.dart';
import 'package:storenews/util/constants.dart';

typedef Client = http.Client;

class StoreService {
  static final logger = GetIt.I<Logger>();
  final Client httpClient;
  final Map<StoreKey, Store> _storeCache = {};

  Uri storeEndpoint(int companyNumber, int storeNumber) =>
      Uri.parse("$apiBaseUrl/store/$companyNumber/$storeNumber");

  StoreService({Client? httpClient})
      : httpClient = httpClient ?? GetIt.instance.get<Client>();

  Future<Store?> get(int companyNumber, int storeNumber) async {
    final key =
        StoreKey(companyNumber: companyNumber, storeNumber: storeNumber);
    // This could be improved with a persistent, timed, limited cache
    if (_storeCache.containsKey(key)) {
      logger.d("Store $key found in cache");
      return _storeCache[key];
    }

    logger.d("Store $key fetched from API");
    final response =
        await httpClient.get(storeEndpoint(companyNumber, storeNumber));
    return response.statusCode == 200
        ? _storeCache[key] =
            Store.fromJson(jsonDecode(utf8.decode(response.bodyBytes)))
        : null;
  }
}
