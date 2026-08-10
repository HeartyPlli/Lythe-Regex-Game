import 'dart:convert';
import 'dart:io';

import 'http_transport.dart';

//=========================================================================
// Service transport io is here for phone desktop api request.
//=========================================================================
//=========================================================================
// This function send GET request on phone or desktop.
//=========================================================================
Future<HttpResponseData> httpGet(Uri uri) async {
  final client = HttpClient();
  try {
    final request = await client.getUrl(uri);
    request.headers.set(HttpHeaders.acceptHeader, 'application/json');
    final response = await request.close();
    return HttpResponseData(
      statusCode: response.statusCode,
      body: await response.transform(utf8.decoder).join(),
    );
  } finally {
    client.close(force: true);
  }
}

//=========================================================================
// This function send POST json request on phone or desktop.
//=========================================================================
Future<HttpResponseData> httpPostJson(
  Uri uri,
  Map<String, Object?> body,
) async {
  final client = HttpClient();
  try {
    final request = await client.postUrl(uri);
    request.headers.set(HttpHeaders.acceptHeader, 'application/json');
    request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
    request.write(jsonEncode(body));
    final response = await request.close();
    return HttpResponseData(
      statusCode: response.statusCode,
      body: await response.transform(utf8.decoder).join(),
    );
  } finally {
    client.close(force: true);
  }
}
