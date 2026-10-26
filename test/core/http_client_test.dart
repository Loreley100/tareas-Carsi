import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_cafeteria/core/failure.dart';
import 'package:gestor_cafeteria/core/http_client.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

ApiClient clienteQueResponde(int status, [Object? body]) {
  return ApiClient(
    baseUrl: 'https://pruebas.local',
    client: MockClient((request) async {
      return http.Response(
        body == null ? '' : jsonEncode(body),
        status,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );
    }),
  );
}

void main() {
  group('ApiClient: mapeo de errores HTTP', () {
    test('200 devuelve el JSON decodificado', () async {
      final api = clienteQueResponde(200, [
        {'id': 1, 'customer': 'Ana'},
      ]);
      final resultado = await api.get('/orders');
      expect(resultado, isA<List>());
      expect(resultado[0]['id'], 1);
    });

    test('404 conserva detail en NotFoundFailure', () async {
      final api = clienteQueResponde(404, {'detail': 'Order 999 not found'});
      await expectLater(
        api.get('/orders/999'),
        throwsA(isA<NotFoundFailure>().having(
          (failure) => failure.message,
          'message',
          'Order 999 not found',
        )),
      );
    });

    test('409 conserva detail en ConflictFailure', () async {
      const mensaje = 'Cannot change status from pending to delivered';
      final api = clienteQueResponde(409, {'detail': mensaje});
      await expectLater(
        api.patch('/orders/1', {'status': 'delivered'}),
        throwsA(isA<ConflictFailure>().having(
          (failure) => failure.message,
          'message',
          mensaje,
        )),
      );
    });

    test('422 guarda los mensajes por campo en ValidationFailure', () async {
      final api = clienteQueResponde(422, {
        'detail': [
          {'loc': ['body', 'customer'], 'msg': 'Must be 1-50 characters'},
        ],
      });
      await expectLater(
        api.post('/orders', {'customer': '', 'drink': 'latte', 'size': 'M'}),
        throwsA(isA<ValidationFailure>().having(
          (failure) => failure.fields,
          'fields',
          {'customer': 'Must be 1-50 characters'},
        )),
      );
    });

    test('503 conserva el código en ServerFailure', () async {
      final api = clienteQueResponde(503, {'detail': 'Simulated failure'});
      await expectLater(
        api.get('/orders?fail=503'),
        throwsA(isA<ServerFailure>().having(
          (failure) => failure.statusCode,
          'statusCode',
          503,
        )),
      );
    });

    test('418 se convierte en UnexpectedFailure con status y detail', () async {
      final api = clienteQueResponde(418, {'detail': 'Simulated failure'});
      await expectLater(
        api.get('/orders?fail=418'),
        throwsA(isA<UnexpectedFailure>()
            .having((failure) => failure.statusCode, 'statusCode', 418)
            .having((failure) => failure.message, 'message', 'Simulated failure')),
      );
    });

    test('ClientException se convierte en NetworkFailure', () async {
      final api = ApiClient(
        baseUrl: 'https://pruebas.local',
        client: MockClient((request) async {
          throw http.ClientException('sin red');
        }),
      );
      await expectLater(api.get('/orders'), throwsA(isA<NetworkFailure>()));
    });
  });
}
