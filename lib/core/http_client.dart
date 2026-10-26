import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:gestor_cafeteria/core/failure.dart';
import 'package:gestor_cafeteria/core/token_storage.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  final http.Client _client;
  final Uri baseUrl;
  final Duration timeout;
  final TokenStorage? _tokens;

  ApiClient({
    http.Client? client,
    String? baseUrl,
    TokenStorage? tokenStorage,
    this.timeout = const Duration(seconds: 10),
  }) : _client = client ?? http.Client(),
       _tokens = tokenStorage,
       baseUrl = _validated(
         baseUrl ??
             (const String.fromEnvironment('API_URL').isNotEmpty
                 ? const String.fromEnvironment('API_URL')
                 : (kIsWeb ? 'http://localhost:8000' : 'http://10.0.2.2:8000')),
       );

  // HTTP sin cifrar se permite solo para el entorno local de desarrollo.
  static const _hostsLocales = {'localhost', '127.0.0.1', '10.0.2.2'};

  static Uri _validated(String raw) {
    final uri = Uri.parse(raw);
    if (uri.scheme == 'https') return uri;
    if (uri.scheme == 'http' && _hostsLocales.contains(uri.host)) return uri;
    throw ArgumentError.value(
      raw,
      'baseUrl',
      'Se exige https fuera de desarrollo local',
    );
  }

  Future<dynamic> get(String path) => _send('GET', path);
  Future<dynamic> post(String path, Object body) => _send('POST', path, body);
  Future<dynamic> patch(String path, Object body) => _send('PATCH', path, body);
  Future<void> delete(String path) => _send('DELETE', path);

  Future<dynamic> _send(String method, String path, [Object? body]) async {
    final request = http.Request(method, baseUrl.resolve(path))
      ..headers['Accept'] = 'application/json';
    final token = await _tokens?.read();
    if (token != null) request.headers['Authorization'] = 'Bearer $token';

    if (body != null) {
      request.headers['Content-Type'] = 'application/json';
      request.body = jsonEncode(body);
    }

    final http.Response response;
    try {
      response = await _client
          .send(request)
          .then(http.Response.fromStream)
          .timeout(timeout);
    } on http.ClientException {
      throw const NetworkFailure();
    } on TimeoutException {
      throw const NetworkFailure();
    }

    final json = _tryDecode(response);
    final code = response.statusCode;
    if (code == 401) {
      await _tokens?.clear();
      throw const UnauthorizedFailure();
    }
    if (code >= 200 && code < 300) {
      return json;
    }
    throw mapHttpError(code, json);
  }

  dynamic _tryDecode(http.Response response) {
    if (response.bodyBytes.isEmpty) return null;
    try {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } on FormatException {
      return null;
    }
  }

  Failure mapHttpError(int code, Object? json) {
    final detail = _detailMessage(json);
    return switch (code) {
      404 => NotFoundFailure(detail ?? 'Recurso no encontrado'),
      409 => ConflictFailure(detail ?? 'Conflicto con la solicitud'),
      422 => ValidationFailure(_fieldsFrom(json)),
      >= 500 && < 600 => ServerFailure(code),
      _ => UnexpectedFailure(code, detail ?? 'Error HTTP $code'),
    };
  }

  String? _detailMessage(Object? json) {
    if (json is Map && json['detail'] is String) {
      return json['detail'] as String;
    }
    return null;
  }

  Map<String, String> _fieldsFrom(Object? json) {
    final fields = <String, String>{};
    if (json is Map && json['detail'] is List) {
      for (final error in json['detail'] as List) {
        if (error is! Map || error['loc'] is! List || error['msg'] is! String) {
          continue;
        }
        final loc = error['loc'] as List;
        if (loc.length > 1) fields[loc[1].toString()] = error['msg'] as String;
      }
    }
    return fields;
  }
}
