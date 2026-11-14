// IA: bloque generado con asistencia de IA (ver docs/ia-t3.md) y revisado a mano.
import '../models/producto.dart';

/// Contrato que consume la pantalla. Permite cambiar el repositorio falso por
/// uno real sin tocar la vista.
abstract class RepositorioProductos {
  Future<List<Producto>> obtener();
}

/// Error de ejemplo para el estado de falla.
class SinConexion implements Exception {
  const SinConexion();
}

/// Repositorio falso de la cafetería.
///
/// - Espera [retraso] para poder ver el estado de carga.
/// - La primera llamada falla a propósito; la segunda ya devuelve el menú, así
///   se puede probar el botón Reintentar.
class RepositorioProductosFalso implements RepositorioProductos {
  RepositorioProductosFalso({this.retraso = const Duration(milliseconds: 1500)});

  final Duration retraso;

  int _llamadas = 0;

  static const List<Producto> _menu = <Producto>[
    Producto(
      nombre: 'Café de olla',
      descripcion: 'Con canela y piloncillo, 12 oz',
      precioCentavos: 2500,
      categoria: 'Bebida caliente',
    ),
    Producto(
      nombre: 'Capuchino',
      descripcion: 'Espresso con leche vaporizada',
      precioCentavos: 3800,
      categoria: 'Bebida caliente',
    ),
    Producto(
      nombre: 'Sándwich de pollo',
      descripcion: 'Pechuga, lechuga y aderezo de la casa',
      precioCentavos: 4500,
      categoria: 'Alimento',
    ),
    Producto(
      nombre: 'Molletes',
      descripcion: 'Frijoles, queso gratinado y pico de gallo',
      precioCentavos: 4200,
      categoria: 'Alimento',
    ),
    Producto(
      nombre: 'Agua de horchata',
      descripcion: 'Vaso de 16 oz, bien fría',
      precioCentavos: 2000,
      categoria: 'Bebida fría',
    ),
    Producto(
      nombre: 'Cuernito de jamón',
      descripcion: 'Jamón de pavo y queso amarillo',
      precioCentavos: 3200,
      categoria: 'Alimento',
    ),
  ];

  @override
  Future<List<Producto>> obtener() async {
    await Future<void>.delayed(retraso);
    _llamadas++;
    if (_llamadas == 1) {
      // IA: la falla de la primera llamada es a propósito, para probar el error.
      throw const SinConexion();
    }
    return _menu;
  }
}
