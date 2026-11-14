// IA: bloque generado con asistencia de IA (ver docs/ia-t3.md) y revisado a mano.
import 'package:flutter/material.dart';

import '../core/formato_dinero.dart';
import '../core/resultado.dart';
import '../models/producto.dart';
import '../repositories/repositorio_productos_falso.dart';

/// Pantalla del menú con tres estados: cargando, lista y error con reintento.
///
/// El estado vive en un campo [Resultado] y se pinta con un `switch` exhaustivo
/// sobre la clase sellada: no hay `default`.
class ListaTresEstadosView extends StatefulWidget {
  const ListaTresEstadosView({super.key, this.repositorio});

  /// Se puede inyectar otro repositorio; en la app se usa el falso.
  final RepositorioProductos? repositorio;

  @override
  State<ListaTresEstadosView> createState() => _ListaTresEstadosViewState();
}

class _ListaTresEstadosViewState extends State<ListaTresEstadosView> {
  late final RepositorioProductos _repositorio =
      widget.repositorio ?? RepositorioProductosFalso();

  Resultado<List<Producto>> _resultado = const Cargando<List<Producto>>();

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _resultado = const Cargando<List<Producto>>());

    try {
      final productos = await _repositorio.obtener();
      // La pantalla pudo cerrarse mientras esperábamos la respuesta.
      if (!mounted) return;
      setState(() => _resultado = Exito(productos));
    } on Exception {
      if (!mounted) return;
      setState(
        () => _resultado = const Error<List<Producto>>(
          'No pudimos cargar el menú. Revisa tu conexión e inténtalo de nuevo.',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menú de la cafetería')),
      body: switch (_resultado) {
        Cargando() => const Center(child: CircularProgressIndicator()),
        Exito(datos: final productos) => _ListaProductos(productos: productos),
        Error(mensaje: final mensaje) => _MensajeError(
            mensaje: mensaje,
            onReintentar: _cargar,
          ),
      },
    );
  }
}

class _ListaProductos extends StatelessWidget {
  const _ListaProductos({required this.productos});

  final List<Producto> productos;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: productos.length,
      itemBuilder: (context, indice) {
        final producto = productos[indice];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(producto.nombre, style: tema.textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(
                        producto.descripcion,
                        style: tema.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        producto.categoria,
                        style: tema.textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  formatearPrecio(producto.precioCentavos),
                  style: tema.textTheme.titleMedium,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MensajeError extends StatelessWidget {
  const _MensajeError({required this.mensaje, required this.onReintentar});

  final String mensaje;
  final VoidCallback onReintentar;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off, size: 56, color: tema.colorScheme.error),
            const SizedBox(height: 16),
            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: tema.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onReintentar,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
