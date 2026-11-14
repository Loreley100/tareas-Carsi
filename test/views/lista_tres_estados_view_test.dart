// IA: bloque generado con asistencia de IA (ver docs/ia-t3.md) y revisado a mano.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_cafeteria/models/producto.dart';
import 'package:gestor_cafeteria/repositories/repositorio_productos_falso.dart';
import 'package:gestor_cafeteria/views/lista_tres_estados_view.dart';

/// Repositorio de prueba que responde de inmediato y siempre bien.
class _RepositorioExito implements RepositorioProductos {
  @override
  Future<List<Producto>> obtener() async => const <Producto>[
        Producto(
          nombre: 'Café de olla',
          descripcion: 'Con canela y piloncillo',
          precioCentavos: 2500,
          categoria: 'Bebida caliente',
        ),
        Producto(
          nombre: 'Molletes',
          descripcion: 'Con queso gratinado',
          precioCentavos: 4200,
          categoria: 'Alimento',
        ),
      ];
}

void main() {
  testWidgets('muestra el indicador y después las tarjetas', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: ListaTresEstadosView(repositorio: _RepositorioExito())),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1));

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(Card), findsNWidgets(2));
    expect(find.text('Café de olla'), findsOneWidget);
    expect(find.text('Molletes'), findsOneWidget);
    expect(find.text(r'$25.00'), findsOneWidget);
    expect(find.text('Bebida caliente'), findsOneWidget);
  });

  testWidgets('el error se lee sin excepción y Reintentar llega a la lista',
      (tester) async {
    final repositorio = RepositorioProductosFalso(retraso: Duration.zero);

    await tester.pumpWidget(
      MaterialApp(home: ListaTresEstadosView(repositorio: repositorio)),
    );
    await tester.pump(const Duration(milliseconds: 1));

    expect(find.textContaining('No pudimos cargar el menú'), findsOneWidget);
    expect(find.text('Reintentar'), findsOneWidget);
    expect(find.textContaining('Exception'), findsNothing);

    await tester.tap(find.text('Reintentar'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1));

    expect(find.text('Café de olla'), findsOneWidget);
    expect(find.text('Reintentar'), findsNothing);
  });
}
