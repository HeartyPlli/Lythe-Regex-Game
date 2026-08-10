import 'http_transport.dart';

Future<HttpResponseData> httpGet(Uri uri) {
  throw UnsupportedError('HTTP transport is not available on this platform.');
}

Future<HttpResponseData> httpPostJson(Uri uri, Map<String, Object?> body) {
  throw UnsupportedError('HTTP transport is not available on this platform.');
}
