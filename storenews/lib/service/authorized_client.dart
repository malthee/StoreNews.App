import 'package:http/http.dart' as http;
import 'package:storenews/util/constants.dart';

typedef Client = http.Client;

/// A wrapper for the http client that gets JWT tokens for authorization.
class AuthorizedClient extends http.BaseClient {
  static final Uri tokenUri = Uri.parse(apiBaseUrl + tokenEndpoint);

  final http.Client _inner;

  String? _token;

  AuthorizedClient(this._inner);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // Get token first if not already present
    if (_token == null) {
      await _refreshToken();
    }

    request.headers["Authorization"] = "Bearer $_token";
    var response = await _inner.send(request);

    // Retry once with new token if unauthorized
    if (response.statusCode == 401) {
      // Retry
      await _refreshToken();
      request.headers["Authorization"] = "Bearer $_token";
      request.headers["Content-Type"] = "application/json";
      response = await _inner.send(request);
    }

    return response;
  }

  Future _refreshToken() async {
    final response = await _inner.get(tokenUri);
    _token = response.body;
  }
}
