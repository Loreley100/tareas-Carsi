// IA: bloque generado con asistencia de IA (ver docs/ia-t3.md) y revisado a mano.
/// Resultado de una operación asíncrona: o está cargando, o salió bien, o falló.
///
/// Es la clase sellada que se trabajó en la Nivelación T1. Al ser `sealed`, el
/// `switch` que la consume no necesita `default`: el compilador exige cubrir
/// `Cargando`, `Exito` y `Error`.
sealed class Resultado<T> {
  const Resultado();
}

/// Todavía no hay respuesta del repositorio.
class Cargando<T> extends Resultado<T> {
  const Cargando();
}

/// La operación terminó y trae los datos.
class Exito<T> extends Resultado<T> {
  const Exito(this.datos);

  final T datos;
}

/// La operación falló; `mensaje` ya viene listo para mostrarse a la persona.
class Error<T> extends Resultado<T> {
  const Error(this.mensaje);

  final String mensaje;
}
