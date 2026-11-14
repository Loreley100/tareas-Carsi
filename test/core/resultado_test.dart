// IA: bloque generado con asistencia de IA (ver docs/ia-t3.md) y revisado a mano.
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_cafeteria/core/resultado.dart';

/// El `switch` no lleva `default`: si falta un estado, esto no compila.
String describir(Resultado<List<String>> resultado) => switch (resultado) {
      Cargando() => 'cargando',
      Exito(datos: final datos) => 'exito: ${datos.length}',
      Error(mensaje: final mensaje) => 'error: $mensaje',
    };

void main() {
  group('Resultado', () {
    test('describe los tres estados', () {
      expect(describir(const Cargando<List<String>>()), 'cargando');
      expect(
        describir(const Exito<List<String>>(<String>['a', 'b'])),
        'exito: 2',
      );
      expect(describir(const Error<List<String>>('sin red')), 'error: sin red');
    });

    test('guarda los datos y el mensaje', () {
      const exito = Exito<int>(7);
      const error = Error<int>('no se pudo');

      expect(exito.datos, 7);
      expect(error.mensaje, 'no se pudo');
    });
  });
}
