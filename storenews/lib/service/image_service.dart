import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:storenews/util/constants.dart';

import '../domain/image_data.dart';

typedef Client = http.Client;

class ImageService {
  final Client httpClient;

  Uri imageEndpoint(String id) => Uri.parse("$apiBaseUrl/image/$id");

  ImageService({Client? httpClient})
      : httpClient = httpClient ?? GetIt.instance.get<Client>();

  Future<ImageData?> getImageById(String id) async {
    final response = await httpClient.get(imageEndpoint(id));
    return response.statusCode == 200
        ? ImageData.fromJson(jsonDecode(utf8.decode(response.bodyBytes)))
        : null;
  }
}
