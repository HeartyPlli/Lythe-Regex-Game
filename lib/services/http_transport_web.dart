// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:convert';
import 'dart:html' as html;

import 'http_transport.dart';

Future<HttpResponseData> httpGet(Uri uri) async {
  final request = await html.HttpRequest.request(
    uri.toString(),
    method: 'GET',
    requestHeaders: const {'Accept': 'application/json'},
  );
  return HttpResponseData(
    statusCode: request.status ?? 0,
    body: request.responseText ?? '',
  );
}

Future<HttpResponseData> httpPostJson(
  Uri uri,
  Map<String, Object?> body,
) async {
  final request = await html.HttpRequest.request(
    uri.toString(),
    method: 'POST',
    requestHeaders: const {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
    sendData: jsonEncode(body),
  );
  return HttpResponseData(
    statusCode: request.status ?? 0,
    body: request.responseText ?? '',
  );
}
