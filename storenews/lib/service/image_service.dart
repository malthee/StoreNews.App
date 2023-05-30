import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:storenews/util/constants.dart';

import '../domain/image_data.dart';

typedef Client = http.Client;

class ImageService {
  static final logger = GetIt.I<Logger>();
  final Client httpClient;

  // Handle better with library, sufficient for now (high memory usage)
  final Map<String, ImageData> _imageCache = {};

  Uri imageEndpoint(String id) => Uri.parse("$apiBaseUrl/image/$id");

  ImageService({Client? httpClient})
      : httpClient = httpClient ?? GetIt.instance.get<Client>();

  Future<ImageData?> getImageById(String id) async {
    if (_imageCache.containsKey(id)) {
      logger.d("Image $id found in cache");
      return _imageCache[id];
    }

    logger.d("Image $id fetched from API");
    // No need for image cache as flutter already handles this in providers
    final response = await httpClient.get(imageEndpoint(id));
    return response.statusCode == 200
        ? _imageCache[id] =
            ImageData.fromJson(jsonDecode(utf8.decode(response.bodyBytes)))
        : null;
  }
}
