import 'http_transport.dart';

//=========================================================================
// Service transport stub is here for unsupported platform api request.
//=========================================================================
//=========================================================================
// This function fail when platform cannot do http here.
//=========================================================================
Future<HttpResponseData> httpGet(Uri uri) {
  throw UnsupportedError('HTTP transport is not available on this platform.');
}

//=========================================================================
// This function fail when platform cannot post http here.
//=========================================================================
Future<HttpResponseData> httpPostJson(Uri uri, Map<String, Object?> body) {
  throw UnsupportedError('HTTP transport is not available on this platform.');
}
