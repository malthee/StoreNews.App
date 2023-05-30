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

  Uri newsAllEndpoint(int companyNumber, int storeNumber, int start, int end) =>
      Uri.parse("$apiBaseUrl/newsItem/all").replace(queryParameters: {
        "companyNumber": "$companyNumber",
        "storeNumber": "$storeNumber",
        "start": "$start",
        "end": "$end"
      });

  Uri newsLatestEndpoint(int companyNumber, int storeNumber) =>
      Uri.parse("$apiBaseUrl/newsItem/latest").replace(queryParameters: {
        "companyNumber": "$companyNumber",
        "storeNumber": "$storeNumber"
      });

  NewsService({Client? httpClient})
      : httpClient = httpClient ?? GetIt.instance.get<Client>();

  Future<NewsItem?> getLatestNews(int companyNumber, int storeNumber) async {
    logger.d(
        "Latest news for company $companyNumber, store $storeNumber fetched from API");

    final response =
        await httpClient.get(newsLatestEndpoint(companyNumber, storeNumber));
    return response.statusCode == 200
        ? NewsItem.fromJson(jsonDecode(utf8.decode(response.bodyBytes)))
        : null;
  }

  Future<List<NewsItem>?> getAllNews(int companyNumber, int storeNumber, int start, int end) async {
    logger.d(
        "All news for company $companyNumber, store $storeNumber fetched from API");

    final response =
        await httpClient.get(newsAllEndpoint(companyNumber, storeNumber, start, end));
    return response.statusCode == 200
        ? (jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>).map((e) => NewsItem.fromJson(e)).toList()
        : null;
  }
}
