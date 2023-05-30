import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:storenews/util/constants.dart';

import '../domain/news_item.dart';

typedef Client = http.Client;

class NewsService {
  static final logger = GetIt.I<Logger>();
  final Client httpClient;

  Uri newsLatestEndpoint(int companyNumber, int storeNumber) =>
      Uri.parse("$apiBaseUrl/newsItem/latest").replace(queryParameters: {
        "companyNumber": "$companyNumber",
        "storeNumber": "$storeNumber"
      });

  // TODO by store endpoint

  NewsService({Client? httpClient})
      : httpClient = httpClient ?? GetIt.instance.get<Client>();

  Future<NewsItem?> getLatestNews(int companyNumber, int storeNumber) async {
    logger.d("Latest news for company $companyNumber, store $storeNumber fetched from API");

    final response =
        await httpClient.get(newsLatestEndpoint(companyNumber, storeNumber));
    return response.statusCode == 200
        ? NewsItem.fromJson(jsonDecode(utf8.decode(response.bodyBytes)))
        : null;
  }
}
