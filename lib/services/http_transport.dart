import 'http_transport_stub.dart'
    if (dart.library.io) 'http_transport_io.dart'
    if (dart.library.html) 'http_transport_web.dart';

abstract final class HttpTransport {
  static Future<HttpResponseData> get(Uri uri) => httpGet(uri);

  static Future<HttpResponseData> postJson(
    Uri uri,
    Map<String, Object?> body,
  ) => httpPostJson(uri, body);
}

class HttpResponseData {
  const HttpResponseData({required this.statusCode, required this.body});

  final int statusCode;
  final String body;
}
