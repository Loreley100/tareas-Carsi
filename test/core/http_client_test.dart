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
  group('ApiClient: respuestas HTTP', () {
    test('200 devuelve el JSON decodificado', () async {
      final api = clienteQueResponde(200, [
        {'id': 1, 'customer': 'Ana'},
      ]);

      final resultado = await api.get('/orders');

      expect(resultado, isA<List>());
      expect(resultado[0]['id'], 1);
      expect(resultado[0]['customer'], 'Ana');
    });

    test('404 conserva el detail en NotFoundFailure', () async {
      final api = clienteQueResponde(404, {'detail': 'Order 9 not found'});

      await expectLater(
        api.get('/orders/9'),
        throwsA(
          isA<NotFoundFailure>().having(
            (failure) => failure.message,
            'message',
            'Order 9 not found',
          ),
        ),
      );
    });

    test('409 conserva el detail en ConflictFailure', () async {
      final mensaje = 'Cannot change status from pending to delivered';
      final api = clienteQueResponde(409, {'detail': mensaje});

      await expectLater(
        api.patch('/orders/9', {'status': 'delivered'}),
        throwsA(
          isA<ConflictFailure>().having(
            (failure) => failure.message,
            'message',
            mensaje,
          ),
        ),
      );
    });

    test('422 convierte detail en un mapa de errores por campo', () async {
      final api = clienteQueResponde(422, {
        'detail': [
          {
            'loc': ['body', 'customer'],
            'msg': 'Must be 1-50 characters',
          },
        ],
      });

      await expectLater(
        api.post('/orders', {'customer': '', 'drink': 'latte', 'size': 'M'}),
        throwsA(
          isA<ValidationFailure>().having(
            (failure) => failure.fields,
            'fields',
            {'customer': 'Must be 1-50 characters'},
          ),
        ),
      );
    });

    test('503 conserva el código en ServerFailure', () async {
      final api = clienteQueResponde(503, {'detail': 'Simulated failure'});

      await expectLater(
        api.get('/orders'),
        throwsA(
          isA<ServerFailure>().having(
            (failure) => failure.statusCode,
            'statusCode',
            503,
          ),
        ),
      );
    });

    test('300 se trata como UnexpectedFailure', () async {
      final api = clienteQueResponde(300, {'detail': 'Multiple Choices'});

      await expectLater(
        api.get('/orders'),
        throwsA(
          isA<UnexpectedFailure>()
              .having((failure) => failure.statusCode, 'statusCode', 300)
              .having((failure) => failure.message, 'message', 'Multiple Choices'),
        ),
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
