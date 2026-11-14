// IA: bloque generado con asistencia de IA (ver docs/ia-t3.md) y revisado a mano.
/// Un producto del menú de la cafetería.
///
/// El precio se guarda en centavos enteros para no usar `double` con dinero.
class Producto {
  const Producto({
    required this.nombre,
    required this.descripcion,
    required this.precioCentavos,
    required this.categoria,
  });

  final String nombre;
  final String descripcion;
  final int precioCentavos;
  final String categoria;
}
