import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:storenews/util/constants.dart';

import '../domain/news_item.dart';

typedef Client = http.Client;

class NewsService {
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
    final response =
        await httpClient.get(newsLatestEndpoint(companyNumber, storeNumber));
    return response.statusCode == 200
        ? NewsItem.fromJson(jsonDecode(utf8.decode(response.bodyBytes)))
        : null;
  }
}
