// IA: bloque generado con asistencia de IA (ver docs/ia-t3.md) y revisado a mano.
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_cafeteria/repositories/repositorio_productos_falso.dart';

void main() {
  group('RepositorioProductosFalso', () {
    test('falla la primera llamada y la segunda devuelve el menú', () async {
      final repositorio =
          RepositorioProductosFalso(retraso: Duration.zero);

      await expectLater(repositorio.obtener(), throwsA(isA<SinConexion>()));

      final productos = await repositorio.obtener();

      expect(productos.length, greaterThanOrEqualTo(5));
      expect(productos.first.nombre, 'Café de olla');
      expect(productos.first.descripcion, isNotEmpty);
      expect(productos.first.precioCentavos, greaterThan(0));
    });

    test('cada producto trae los datos que pinta la tarjeta', () async {
      final repositorio =
          RepositorioProductosFalso(retraso: Duration.zero);
      await expectLater(repositorio.obtener(), throwsA(isA<SinConexion>()));

      final productos = await repositorio.obtener();

      for (final producto in productos) {
        expect(producto.nombre, isNotEmpty);
        expect(producto.descripcion, isNotEmpty);
        expect(producto.categoria, isNotEmpty);
        expect(producto.precioCentavos, greaterThan(0));
      }
    });
  });
}
