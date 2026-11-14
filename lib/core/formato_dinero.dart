// IA: bloque generado con asistencia de IA (ver docs/ia-t3.md) y revisado a mano.
/// Formato de dinero con centavos enteros: nunca convierte a `double`.
String formatearPrecio(int centavos) {
  final signo = centavos < 0 ? '-' : '';
  final absoluto = centavos.abs();
  final pesos = absoluto ~/ 100;
  final resto = (absoluto % 100).toString().padLeft(2, '0');
  return '$signo\$$pesos.$resto';
}
